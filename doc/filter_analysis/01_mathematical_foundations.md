# Mathematical Foundations of UKF and SPUKF on Lie Groups

This document provides a comprehensive theoretical breakdown of three distinct state-estimation paradigms on Lie Groups, contrasting their formulations, propagation mechanics, and computational complexities.

## 1. Reference UKF on $\mathcal{G} = SE_2(3) \times T(6)$

The reference implementation defines the state $X \in \mathcal{G}$ combining the spatial navigation state on $SE_2(3)$ and sensor biases on a vector space $T(6) \cong \mathbb{R}^6$.
The state space dimension is $p=15$, and with the inclusion of process ($Q_k$) and measurement ($R_k$) noise directly into the sigma points, the augmented state vector $\eta$ has dimension $L = 2p + q = 33$.

### 1.1 Sigma Point Generation
For an augmented state dimension $L = 33$, the UKF generates $2L+1 = 67$ sigma points on the tangent space (Lie algebra $\mathfrak{g} \cong \mathbb{R}^{15}$) utilizing the prior augmented covariance $P_\eta \in \mathbb{R}^{33 \times 33}$. The scaling parameter $\lambda = \alpha^2 (L + \kappa) - L$ governs the spread:
$$ \xi^{(0)} = \mathbf{0} $$
$$ \xi^{(i)} = \left( \sqrt{(L+\lambda) P_{\eta}} \right)_i, \quad i = 1, \dots, L $$
$$ \xi^{(i+L)} = -\left( \sqrt{(L+\lambda) P_{\eta}} \right)_i, \quad i = 1, \dots, L $$
These perturbations are mapped to the Lie Group manifold via the retraction mapping (exponential map):
$$ \mathcal{X}_{k-1}^{(i)} = X_{k-1} \text{Exp}(\xi^{(i)}) $$

### 1.2 Nonlinear Kinematics Propagation
Each of the 67 sigma points is independently propagated through the nonlinear system dynamics $\Omega^{(i)} = \Omega(\mathcal{X}_{k-1}^{(i)}, u_k)$:
$$ \mathcal{X}_{k|k-1}^{(i)} = \mathcal{X}_{k-1}^{(i)} \text{Exp}(\Omega^{(i)} \Delta t + w^{(i)}) $$
where $w^{(i)}$ represents the process noise injected from the augmented state.

### 1.3 Fréchet Mean Iteration (Time Update)
Because the state evolves on a curved manifold, the standard Euclidean weighted mean cannot be used. Instead, the predicted mean $\bar{X}_{k|k-1}$ is found by minimizing the Riemannian distance iteratively using the Fréchet / Karcher mean:
$$ \bar{X}^{(j+1)} = \bar{X}^{(j)} \text{Exp} \left( \sum_{i=0}^{2L} W_m^{(i)} \text{Log}\left( (\bar{X}^{(j)})^{-1} \mathcal{X}_{k|k-1}^{(i)} \right) \right) $$
Once the mean converges, the predicted covariance is constructed from the tangent space residuals:
$$ e^{(i)} = \text{Log}\left( \bar{X}_{k|k-1}^{-1} \mathcal{X}_{k|k-1}^{(i)} \right) $$
$$ P_{k|k-1} = \sum_{i=0}^{2L} W_c^{(i)} e^{(i)} (e^{(i)})^T $$

---

## 2. SPUKF & ESPUKF Strategy (Biswas et al., 2017)

The Single Propagation UKF (SPUKF) mitigates the extreme computational burden of propagating all 67 sigma points through the nonlinear system dynamics.

### 2.1 The Single Propagation Mechanics
Instead of integrating every sigma point, only the posterior mean state $Y_0(t+\Delta t)$ is propagated via standard numerical integration (e.g., RK4):
$$ Y_0(t+\Delta t) = f(Y_0(t), u) $$

### 2.2 First-Order Taylor-Series Propagation
The remaining $2n$ sigma points are approximated at $t+\Delta t$ using a first-order Taylor series expansion involving the system Jacobian exponential:
$$ Y_i(t+\Delta t) \approx Y_0(t+\Delta t) + e^{\mathcal{J} \Delta t} \Delta Y_i(t) $$
where $\mathcal{J}$ is the Jacobian matrix of the process model, and $\Delta Y_i(t) = \left( \sqrt{(n+\lambda)P} \right)_i$.
*Note: When applied to Lie Groups, addition is replaced by the group operation and exponential map.*
$$ \mathcal{X}_{k|k-1}^{(i)} \approx \bar{X}_{k|k-1} \text{Exp} \left( e^{\mathcal{J} \Delta t} \xi^{(i)} \right) $$

### 2.3 ESPUKF: Richardson Extrapolation
To recover second-order accuracy without deriving analytical Hessians, Biswas proposes the Extrapolated SPUKF (ESPUKF), which utilizes multi-dimensional Richardson extrapolation to refine the approximated sigma points.

---

## 3. Invariant/EKF Covariance Propagation (Brossard et al., 2018)

Brossard completely bypasses the propagation of individual sigma points during the time update.

### 3.1 Mean and Covariance Decoupling
Only the mean trajectory is propagated on the Lie group:
$$ \bar{X}_{k|k-1} = \bar{X}_{k-1} \text{Exp}(\Omega(\bar{X}_{k-1}, u_k) \Delta t) $$
The covariance is propagated analytically on the Lie algebra using the discrete-time state transition matrix $\Phi_n$:
$$ P_{k|k-1} = \Phi_n P_{k-1} \Phi_n^T + Q_n $$
where $\Phi_n = \text{Ad}_{\text{Exp}(-\Omega \Delta t)} + \Phi(\Omega \Delta t) C_n$.

### 3.2 Distinctions in Strategy
- **Biswas (SPUKF):** Propagates sigma points in the tangent space using $e^{\mathcal{J}\Delta t}$ to reconstruct the covariance.
- **Brossard (IEKF/UKF-LG):** Derives an analytical group-affine formulation for $P$, rendering sigma point generation during the time update entirely obsolete. Sigma points are only sampled at the measurement update step.

---

## 4. Structural & Complexity Matrix

| Feature | Reference UKF ($SE_2(3)$) | Biswas SPUKF Strategy | Brossard Invariant Strategy |
| :--- | :--- | :--- | :--- |
| **Sigma Points (Time Update)** | $2L + 1$ (67 points) | $2n + 1$ (approximated) | 0 (Bypassed) |
| **Numerical Integrations** | $2L + 1$ full integrations | 1 (Mean only) | 1 (Mean only) |
| **Group Exp/Log Evals per Cycle** | $> 150$ (due to Fréchet iter) | $\approx 2n+2$ | 2 (1 Mean, 1 Measurement) |
| **FLOP Scaling (Time Update)** | $\mathcal{O}(L^3)$ | $\mathcal{O}(n^3)$ | $\mathcal{O}(n^3)$ |
| **Time Propagation Truncation** | Up to 3rd-order accuracy | 1st-order (2nd-order with ESPUKF)| 1st-order Jacobian linear approx |
| **Positive Definiteness Loss** | High (Fréchet recon) | Moderate (Jacobian approx) | Low (Analytic Riccati) |
| **Symmetry/Definiteness Hack** | `P = 0.5*(P+P')` required | `P = 0.5*(P+P')` required | `P = 0.5*(P+P')` required |
