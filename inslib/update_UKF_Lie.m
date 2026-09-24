function [g_upd, P_upd] = update_UKF_Lie(g_pred, P_pred, Pqq, Prr, y, G_pred, Chi_R, alpha, beta, kappa, leverarm, L)
%% UPDATE_UKF_LIE Measurement update (correction) step on Lie Groups
% Reference: Giorgio M. Magalhães et al. (CBA 2018), Eq. 45 - 51
%
% Inputs:
%   g_pred   - A priori predicted state on Lie Group SE_2(3) x T(6) (13x13)
%   P_pred   - A priori predicted error covariance in tangent space (15x15)
%   Pqq      - Process noise covariance (15x15)
%   Prr      - Measurement noise covariance (3x3)
%   y        - GNSS measurement (3x1 position vector in ECEF)
%   G_pred   - Propagated state sigma points (13x13 x 2L+1)
%   Chi_R    - Measurement noise sigma points component (3 x 2L+1)
%   alpha    - Scaling parameter for unscented transform
%   beta     - Distribution parameter (beta = 2 for Gaussian)
%   kappa    - Secondary scaling parameter (kappa = 0)
%   leverarm - GNSS antenna lever arm in body frame (3x1)
%   L        - Augmented state dimension (L = 33)
%
% Outputs:
%   g_upd    - A posteriori updated state on Lie Group (13x13)
%   P_upd    - A posteriori updated error covariance (15x15)

n2L1 = 2 * L + 1;

%% 1. Unscented Transform Weights (Eq. 6)
lambda = (alpha^2) * (L + kappa) - L;
W0m = lambda / (L + lambda);
W0c = lambda / (L + lambda) + (1 - alpha^2 + beta);
Wim = 1 / (2 * (L + lambda));
Wic = 1 / (2 * (L + lambda));

Wm = [W0m; repmat(Wim, 2 * L, 1)]; % (2L+1) x 1
Wc = [W0c; repmat(Wic, 2 * L, 1)]; % (2L+1) x 1

%% 2. Measurement Lie Group Sigma Points on H = T(3) (Eq. 45)
H_pred = zeros(4, 4, n2L1);
for i = 1:n2L1
    Ceb = G_pred(1:3, 1:3, i);
    peb = G_pred(1:3, 5, i);
    H_pred(:, :, i) = [eye(3), peb + Ceb * leverarm + Chi_R(:, i); zeros(1, 3), 1];
end

%% 3. Measurement Mean on Lie Group H (Eq. 46)
h_pred = frechet_mean_h(Wm, H_pred, alpha, L);

%% 4. Innovation Covariance Phh and Cross-Covariance Pgh (Eq. 47 & 48)
[Phh, Pgh] = lie_covariances(g_pred, h_pred, G_pred, H_pred, Wc, Prr, L);

%% 5. Tangent Innovation in Lie Algebra of H (Eq. 49)
innov_y = y - h_pred(1:3, 4);

%% 6. Kalman Gain and Error State Update in Lie Algebra of G (Eq. 49)
K = (Phh \ Pgh')'; % 15x3 Kalman gain
eps_upd = K * innov_y;

%% 7. Covariance Update (Eq. 50)
P_upd = P_pred - K * Pgh';
P_upd = 0.5 * (P_upd + P_upd'); % Enforce numerical symmetry

%% 8. State Update via Lie Retraction (Eq. 51)
g_upd = g_pred * exp_multiSE23T6(eps_upd);

end
