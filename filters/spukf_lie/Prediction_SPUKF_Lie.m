function [g_pred, P_pred, xi_state, Chi_R, Wm, Wc] = Prediction_SPUKF_Lie(g_prev, P_prev, Pqq, Prr, u, alpha, beta, kappa, L, dt) %#codegen
%% PREDICTION_SPUKF_LIE Time update (prediction) step on Lie Groups
% Reference: Giorgio M. Magalhaes et al. (CBA 2018), Eqs. (40), ..., (44)
% Reference: Sanat K. Biswas et al. (IEEE TAC 2017), Eqs. (20), ..., (28)

n2L1 = 2 * L + 1;

%% 1. Augmented Sigma Points Generation (CBA 2018, Eqs. 5, 6, 40)
[Chi, Wm, Wc] = Sigma_Points_Lie(alpha, beta, kappa, P_prev, Pqq, Prr, L);

Chi_E = Chi(1:15, :);   % State error perturbation points (15 x 2L+1)
Chi_Q = Chi(16:30, :);  % Process noise points (15 x 2L+1)
Chi_R = Chi(31:33, :);  % Measurement noise points (3 x 2L+1)

%% 2. Single Propagation of Central State on Lie Group G (Biswas et al. 2017, Eqs. 15-16)
% Because the mapped perturbations are antisymmetric in the tangent space
% of g_pred_0, the Frechet mean on G is directly g_pred = g_pred_0.
[omeg, gn, Cen] = Omega_SE23T6(g_prev, u);
omegk           = omeg * dt;
g_pred          = g_prev * Exp_Multi_SE23T6(omegk);

%% 3. First-Order Sigma Points Mapping in Lie Algebra g (Biswas et al. 2017, Eqs. 21-22)
Phi      = Phi_SE23T6(omegk);
C        = Matrix_C_SE23T6(g_pred, u, gn, Cen, dt);
F        = Ad_G(Exp_Multi_SE23T6(-omegk)) + Phi * C; % Lie algebra mapped non-linear function Phi
xi_state = F * Chi_E + Phi * Chi_Q;                  % 15 x (2L + 1)

%% 4. Predicted Covariance in Lie Algebra (CBA 2018, Eq. 44; Biswas et al. 2017, Eq. 28)
Wc_row = reshape(Wc, 1, n2L1);
P_pred = (xi_state .* Wc_row) * xi_state';
P_pred = 0.5 * (P_pred + P_pred');
end
