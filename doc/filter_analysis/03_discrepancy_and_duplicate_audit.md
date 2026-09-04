# Discrepancy, Duplicate Audit & Refactoring

This document provides a forensic peer-review of Script B (`run_SPUKF_Lie.m` and dependencies) against Script A (`run_UKF_Lie.m`), diagnosing theoretical misalignment, manifold violations, and numerical drifts.

## 1. Forensic Root-Cause Audit: The Frankenstein Filter

**Diagnosis: Naming Convention and Attribution Discrepancy.**
The most critical finding of this codebase audit is that **`run_SPUKF_Lie.m` is NOT an implementation of Biswas's SPUKF.**
Instead, the codebase implements **Brossard's UKF on Lie Groups (UKF-LG)**, but mistakenly labels it as SPUKF.

1.  **Biswas's SPUKF (2017):** Proposes propagating the mean using the nonlinear dynamics, but generating sigma points and propagating them forward in time using a Taylor-series approximation involving the system Jacobian exponential ($e^{\mathcal{J}\Delta t}\Delta Y_i$).
2.  **Brossard's UKF-LG (2018):** Bypasses sigma points during the time update entirely. It propagates the covariance analytically using the Invariant-EKF discrete transition matrix ($\Phi P \Phi^T + Q$). Sigma points are strictly reserved for the measurement update to handle nonlinear measurement Jacobians.
3.  **The Codebase Reality:** `run_SPUKF_Lie.m` calls `prediction_EKF_Lie.m` (which executes exactly $F = \text{Ad}_{G}(\dots) + \Phi C$, Brossard's analytical propagation) and `update_SPUKF_Lie.m` (which executes local sigma point generation for the measurement update). This is definitively Brossard's algorithm.

## 2. Mathematical Inconsistencies & Manifold Violations

### 2.1 The Euclidean vs. Lie Algebra Mapping
In `update_SPUKF_Lie.m`:
```matlab
hx_i = hx_pred * exp_multiSE23T6(xi(:, i));
```
*Verdict: Clean.* The generated code perfectly respects the manifold by mapping the Cholesky factorized Euclidean errors `xi` through the exponential map and executing a right-multiplication to perturb the group state.

### 2.2 Numerical Integrity & Covariance Drifts
In both `prediction_EKF_Lie.m` and `update_SPUKF_Lie.m`:
```matlab
P_upd = (P_upd + P_upd') / 2;
```
*Verdict: Necessary Hack.* Standard UKF implementations on Lie Groups suffer from extreme precision loss due to the high-frequency matrix exponentials and logarithms. Without enforcing symmetry, the subsequent Cholesky decomposition `chol((L + lambda) * P_pred, 'lower')` will frequently crash asserting that the matrix is not positive definite.

### 2.3 Weight Indexing & Scale Tuning
In `update_SPUKF_Lie.m`:
```matlab
Wm(1) = lambda / (L + lambda);
Wc(1) = lambda / (L + lambda) + (1 - alpha^2 + beta);
```
*Verdict: Accurate.* The scaling parameter formulation matches the standard Unscented Transform for a dynamically calculated state dimension $L$.

---

## 3. Targeted Code Refactoring (Scripts B1 & B2)

To resolve the naming discrepancies and provide genuinely faithful implementations, we have structured two distinct scripts below.

### Script B1: Genuine Biswas SPUKF (`prediction_Biswas_SPUKF.m`)
To genuinely implement Biswas (2017), the time update must rely on the Jacobian-exponential projection rather than analytical Riccati recursion.

```matlab
function [hx_pred, P_pred] = prediction_Biswas_SPUKF(hx0, P0, u, Q, dt, alpha, beta, kappa)
    L = size(P0, 1);
    lambda = alpha^2 * (L + kappa) - L;
    
    % 1. Single Mean Propagation
    [omeg, gn, Cen] = Omega(hx0, u);
    omegk = omeg * dt;
    hx_pred = hx0 * exp_multiSE23T6(omegk);
    
    % 2. First-Order Jacobian Extraction
    Phi = phi(omegk);
    C = matriz_C_se23T6(hx_pred, u, gn, Cen, dt);
    F_jacobian = Ad_G(exp_multiSE23T6(-omegk)) + Phi * C;
    
    % 3. Sigma Point Generation (Pre-Propagation)
    P0_sym = (P0 + P0') / 2;
    S = chol((L + lambda) * P0_sym, 'lower');
    xi_0 = zeros(L, 2*L+1);
    for i = 1:L
        xi_0(:, i+1)   =  S(:, i);
        xi_0(:, i+L+1) = -S(:, i);
    end
    
    % 4. Taylor-Series Projection (Biswas SPUKF Strategy)
    % xi_pred = e^(F * dt) * xi_0   (Linear projection of Lie algebra error)
    % We approximate the matrix exponential acting on the error state
    expm_F = expm(F_jacobian * dt);
    
    Wc = [lambda/(L+lambda)+(1-alpha^2+beta); repmat(1/(2*(L+lambda)), 2*L, 1)];
    P_pred = Q; % Add process noise directly
    
    for i = 1:(2*L+1)
        if i == 1
            xi_pred = zeros(L, 1);
        else
            xi_pred = expm_F * xi_0(:, i);
        end
        % Reconstruct Covariance from approximated sigma points
        P_pred = P_pred + Wc(i) * (xi_pred * xi_pred');
    end
    
    P_pred = (P_pred + P_pred') / 2;
end
```

### Script B2: Genuine Brossard UKF-LG (`run_Brossard_UKFLG.m`)
The existing `run_SPUKF_Lie.m` should be formally renamed and documented as Brossard's UKF-LG to prevent further academic confusion. 

```matlab
function [rmse, hx, trP, euler] = run_Brossard_UKFLG(N, time, gps_time, hx, trP, P, Pqq, Prr, u, alpha, beta, kappa, L, Cen, y, leverarm, M, euler, ref)
    % RUN_BROSSARD_UKFLG
    % Implements Brossard et al. (2018) Unscented Kalman Filter on Lie Groups.
    % 1. Time Update: Analytical Covariance Propagation (IEKF discrete transition).
    % 2. Measurement Update: Unscented Transform on the Lie Group.
    
    nk = 2;
    CenT = Cen';          
    
    for k = 1:N-1
        dt = time(k+1) - time(k); 
        
        % 1. Brossard Analytical Prediction (Bypassing Sigma Points)
        [hx_pred, P_pred] = prediction_EKF_Lie(hx(:,:,k), P(:,:,k), u(:,k), Pqq, dt);
        
        hx(:,:,k+1) = hx_pred;
        P(:,:,k+1)  = P_pred;
        
        % 2. Local Sigma Point Measurement Update
        if (abs(time(k+1) - gps_time(nk)) < dt)
            % Function identically maps to the current update_SPUKF_Lie.m mechanics
            [hx(:,:,k+1), P(:,:,k+1)] = update_SPUKF_Lie(hx_pred, P_pred, Prr, y(:,nk), alpha, beta, kappa, leverarm, L);
            
            if nk < M 
                nk = nk + 1;
            end
        end
        
        Pk = P(:,:,k+1);
        trP(k+1) = sum(Pk(1:16:end));   
        euler(:,k+1) = eulerdFromRotm(CenT*hx(1:3,1:3,k+1));
    end
    
    rmse = evaluateStateRMSE(euler, squeeze(hx(1:3,5,:)), squeeze(hx(1:3,4,:)), ref, Cen);
end
```
