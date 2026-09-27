function [g_pred, S_pred, xi_state, Chi_R, Wm, Wc] = Prediction_SPSRUKF_Lie(g_prev, S_prev, S_qq, S_rr, u, alpha, beta, kappa, L, dt) %#codegen
%% PREDICTION_SPSRUKF_Lie Time update (prediction) step on Lie Groups
% Reference: Giorgio M. Magalhaes et al. (CBA 2018), Eqs. (40), ..., (44)
% Reference: Rudolph van der Merwe & Eric A. Wan (ICASSP 2001), Eqs. (17), ..., (21)
% Reference: Sanat K. Biswas et al. (IEEE TAC 2017), Eqs. (20), ..., (28)

%% 1. Augmented Sigma Points directly from Cholesky Factors (ICASSP 2001, Eq. 17)
lambda = (alpha^2) * (L + kappa) - L;
eta    = sqrt(L + lambda);

W0m = lambda / (L + lambda);
W0c = lambda / (L + lambda) + (1 - alpha^2 + beta);
Wi  = 1 / (2 * (L + lambda));

Wm = [W0m; repmat(Wi, 2 * L, 1)];
Wc = [W0c; repmat(Wi, 2 * L, 1)];

Sk = blkdiag(S_prev, S_qq, S_rr);             % 33 x 33 lower-triangular
Chi = [zeros(L, 1), eta * Sk, -eta * Sk];     % 33 x (2L + 1)

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

%% 4. Predicted Cholesky Factor in Lie Algebra (ICASSP 2001, Eqs. 20 & 21)
% Eq. 20: QR of weighted sigma point residuals (2:2L+1)
compound_state = sqrt(Wc(2)) * xi_state(:, 2:end); % 15 x 2L
[~, R_qr] = qr(compound_state', 0);
R_pred = R_qr(1:15, 1:15);                         % R_pred is 15 x 15 upper-triangular

% Note: xi_state(:, 1) == 0, so the 0-th sigma point rank-1 update is zero.
S_pred = R_pred'; % 15 x 15 lower-triangular (P_pred = S_pred * S_pred')
end
