function [g_pred, P_pred, xi_state, Chi_R, Wm, Wc] = Prediction_SPUKF_Lie(g_prev, P_prev, Pqq, Prr, u, alpha, beta, kappa, L, dt, has_meas) %#codegen
%% PREDICTION_SPUKF_LIE Time update (prediction) step on Lie Groups
% Reference: Giorgio M. Magalhaes et al. (CBA 2018), Eqs. (40), ..., (44)
% Reference: Sanat K. Biswas et al. (IEEE TAC 2017), Eqs. (20), ..., (28), (57)

if nargin < 11
    has_meas = true;
end

n2L1 = 2 * L + 1;

%% 1. Single Propagation of Central State on Lie Group G (Biswas et al. 2017, Eqs. 15-16)
% Because the mapped perturbations are antisymmetric in the tangent space
% of g_pred_0, the Frechet mean on G is directly g_pred = g_pred_0.
[omeg, gn, Cen] = Omega_SE23T6(g_prev, u);
omegk           = omeg * dt;
g_pred          = g_prev * Exp_Multi_SE23T6(omegk);

%% 2. Discrete-Time Lie Algebra Transition Matrices (Biswas et al. 2017, Eqs. 21-22)
Phi = Phi_SE23T6(omegk);
C   = Matrix_C_SE23T6(g_pred, u, gn, Cen, dt);
F   = Ad_G(Exp_Multi_SE23T6(-omegk)) + Phi * C; % Lie algebra mapped non-linear function Phi

%% 3. Selective Sigma-Point Instantiation & Covariance Propagation (Biswas et al. 2017, Eqs. 28, 57)
% Generate and linearly map the 2L + 1 sigma points only at epochs
% where a measurement update will be executed (has_meas == true).
% In SPUKF, the linear tangent mapping xi_state = F * Chi_E + Phi * Chi_Q
% yields a sample covariance sum_i Wc_i * xi_state_i * xi_state_i' that is algebraically
% identical to the analytical Lyapunov propagation F * P_prev * F' + Phi * Pqq * Phi'.
% During the 199 out of 200 IMU dead-reckoning steps where no 1 Hz GNSS measurement
% arrives, xi_state and Chi_R are unused. Evaluating P_pred analytically on non-GNSS
% steps and instantiating sigma points only at GNSS epochs matches Biswas et al. (2017)
% Eq. (57) without altering the prior covariance or sigma points at measurement updates.
if has_meas
    % Measurement epoch: generate augmented sigma points and map to tangent space for Update_SPUKF_Lie
    [Chi, Wm, Wc] = Sigma_Points_Lie(alpha, beta, kappa, P_prev, Pqq, Prr, L);

    Chi_E = Chi(1:15, :);   % State error perturbation points (15 x 2L+1)
    Chi_Q = Chi(16:30, :);  % Process noise points (15 x 2L+1)
    Chi_R = Chi(31:33, :);  % Measurement noise points (3 x 2L+1)

    xi_state = F * Chi_E + Phi * Chi_Q; % 15 x (2L + 1)

    Wc_row = reshape(Wc, 1, n2L1);
    P_pred = (xi_state .* Wc_row) * xi_state';
    P_pred = 0.5 * (P_pred + P_pred');
else
    % Pure dead-reckoning IMU step: propagate P_pred directly (exact algebraic identity)
    P_pred   = F * P_prev * F' + Phi * Pqq * Phi';
    P_pred   = 0.5 * (P_pred + P_pred');
    xi_state = zeros(15, n2L1);
    Chi_R    = zeros(3, n2L1);
    Wm       = zeros(n2L1, 1);
    Wc       = zeros(n2L1, 1);
end
end
