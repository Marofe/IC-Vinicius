# Codebase Mapping & Line-by-Line Breakdown

This document executes an exhaustive code-to-math cross-reference of the Unscented Kalman Filter and its optimized variants in the workspace.

## 1. Mathematical Symbol to Variable Cross-Reference

| Mathematical Symbol | Script A (Reference `prediction_UKF_Lie.m` & `update_UKF_Lie.m`) | Script B1 (Intended Biswas) | Script B2 (Current Workspace `run_SPUKF_Lie.m` Brossard Hybrid) |
| :--- | :--- | :--- | :--- |
| State Space Dimension $n, p$ | `p=15`, `L=33` (augmented) | `L=15` | `L=15` |
| Prior Mean $\bar{X}_{k\|k-1}$ | `g0` | `hx_pred` | `hx_pred` |
| Prior Covariance $P_{k\|k-1}$ | `Pt0` | `P_pred` | `P_pred` |
| Process Noise $Q_k$ | `Pqq` | `Pqq` | `Pqq` |
| Measurement Matrix $R_k$ | `Prr` | `Prr` | `Prr` |
| Sigma Pt Deviations $\xi^{(i)}$ | `E`, `Q`, `R` from `SigmaPointsLie`| `xi = chol((L+lambda)*P)` | `xi = chol((L+lambda)*P_pred)` |
| Predicted Meas $\mathcal{Y}_k^{(i)}$ | `Y(:,:,i)` (4x4 hom. matrix) | `Y(:,i)` | `Y(:,i)` |
| Mean Pred Meas $\hat{y}_k$ | `ht(1:3,4)` | `y_bar` | `y_bar` |
| Inn. Covariance $P_{yy}$ | `Phh` | `P_hh` | `P_hh` |
| Cross Covariance $P_{xy}$ | `Pgh` | `P_gh` | `P_gh` |
| Kalman Gain $K_k$ | `K` | `K` | `K` |
| Discrete Transition $\Phi_n$ | N/A (Fully Propagated) | N/A (Jacobian approx) | `F = Ad_G(...) + Phi*C` |

---

## 2. Line-by-Line Execution Walkthrough

### 2.1 Initialization & Sigma Point Generation (Time Update)

**Script A (`prediction_UKF_Lie.m`):**
> `12: [Xi,Wm,Wc]=SigmaPointsLie(eta,alpha,beta,kappa,Pt0,Pqq,Prr,L);`
> `14: E=squeeze(Xi(1:15,:)); Q=squeeze(Xi(16:30,:)); R=squeeze(Xi(31:33,:));`
*Equation Mapping:* $\xi^{(i)} = \left( \sqrt{(L+\lambda) P_{\eta}} \right)_i$.
*Manifold Geometry:* The reference directly samples the augmented 33x33 covariance matrix to generate process and measurement noise alongside state perturbations in the Lie algebra.

### 2.2 Time Propagation

**Script A (`prediction_UKF_Lie.m`):**
> `35: G_t_1 = g0*exp_multiSE23T6(E(:,i));`
> `44: Omegk = [f1;f2;f3;zeros(6,1)]*dt;`
> `45: G_t(:,:,i) = G_t_1*exp_multiSE23T6(Omegk + Q(:,i));`
*Equation Mapping:* $\mathcal{X}_{k\|k-1}^{(i)} = \mathcal{X}_{k-1}^{(i)} \text{Exp}(\Omega^{(i)} \Delta t + w^{(i)})$.
*Manifold Geometry:* For each of the 67 points, the script applies the group exponential map to perturb the state, computes nonlinear dynamics $\Omega$, and maps the integration back to the Lie group via right-multiplication.

**Script B2 (`inslib/prediction_EKF_Lie.m` - Brossard IEKF):**
> `7: hx=hx0*exp_multiSE23T6(omegk);`
> `15: F=Ad_G(exp_multiSE23T6(-omegk))+Phi*C;`
> `19: P=F*P0*F' + Phi*Qk*Phi';`
*Equation Mapping:* $\bar{X}_{k\|k-1} = \bar{X}_{k-1} \text{Exp}(\Omega \Delta t)$ and $P_{k\|k-1} = \Phi_n P_{k-1} \Phi_n^T + Q_n$.
*Manifold Geometry:* Brossard's invariant analytical covariance propagation natively uses the Adjoint matrix `Ad_G` on the inverse group increment to map uncertainty forward in time.

### 2.3 Fréchet Mean Iteration vs. Deterministic Mean

**Script A (`prediction_UKF_Lie.m`):**
> `49: g=media_nula_g(Wm,G_t,alpha,L);`
> `56: epsg(:,k)=log_multiSE23T6(g\G_t(:,:,k));`
> `58: Pt=epsg*diag(Wc)*epsg'+Pqq;`
*Equation Mapping:* $\bar{X}^{(j+1)} = \bar{X}^{(j)} \text{Exp} \left( \sum W_m^{(i)} \text{Log}\left( (\bar{X}^{(j)})^{-1} \mathcal{X}^{(i)} \right) \right)$.
*Manifold Geometry:* Reconstructing the mean requires the `media_nula_g` iterative solver mapping coordinates to the tangent space via `log_multiSE23T6` (`g\G_t` is the group inverse $X^{-1}Y$).

**Script B2 (`update_SPUKF_Lie.m` - Measurement Update):**
> `50: hx_i = hx_pred * exp_multiSE23T6(xi(:, i));`
> `71: y_bar = y_bar + Wm(i) * Y(:, i);`
*Equation Mapping:* $\mathcal{Y}_k^{(i)} = h(\mathcal{X}_{k\|k-1}^{(i)})$.
*Manifold Geometry:* Since Script B bypasses sigma point generation during the time update, it only runs 31 points (instead of 67) natively inside the measurement update. Since the output is a Euclidean vector (`Y(:,i) \in R^3`), a standard weighted sum (`y_bar`) replaces the complex Fréchet solver.

### 2.4 Covariance Assembly & Measurement Update

**Script B2 (`update_SPUKF_Lie.m`):**
> `87: P_hh = P_hh + Wc(i) * (dy * dy');`
> `90: P_gh = P_gh + Wc(i) * (xi(:, i) * dy');`
> `97: K = P_gh / P_hh;`
> `109: delta_x = K * innovation;`
> `110: hx_upd = hx_pred * exp_multiSE23T6(delta_x);`
*Equation Mapping:* $K_k = P_{xy} P_{yy}^{-1}$ and $\hat{X}_{k\|k} = \bar{X}_{k\|k-1} \text{Exp}(K_k(y - \hat{y}))$.
*Manifold Geometry:* The cross-covariance elegantly couples Lie algebra errors `xi(:, i)` directly to Euclidean residuals `dy`. The right-divide `P_gh / P_hh` efficiently yields the Kalman gain. The update seamlessly applies the Euclidean innovation correction back onto the manifold via right-multiplication of the `exp_multiSE23T6` operator.
