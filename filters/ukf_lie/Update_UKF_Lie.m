function [g_upd, P_upd] = Update_UKF_Lie(g_pred, P_pred, Prr, y, G_pred, Chi_R, alpha, beta, kappa, leverarm, L) %#codegen
%% Update_UKF_Lie Measurement update (correction) step on Lie Groups
% Reference: Giorgio M. Magalhaes et al. (CBA 2018), Eqs. (45), ..., (51)

n2L1 = 2 * L + 1;

%% 1. Unscented Transform Weights (Eq. 6)
lambda = (alpha^2) * (L + kappa) - L;
W0m = lambda / (L + lambda);
W0c = lambda / (L + lambda) + (1 - alpha^2 + beta);
Wim = 1 / (2 * (L + lambda));
Wic = 1 / (2 * (L + lambda));

Wm = [W0m; repmat(Wim, 2 * L, 1)];
Wc = [W0c; repmat(Wic, 2 * L, 1)];

%% 2. Measurement Lie Group Sigma Points on H = T(3) (Eq. 45)
H_pred = zeros(4, 4, n2L1);
for i = 1:n2L1
    Ceb = G_pred(1:3, 1:3, i);
    peb = G_pred(1:3, 5, i);
    H_pred(:, :, i) = [eye(3), peb + Ceb * leverarm + Chi_R(:, i); zeros(1, 3), 1];
end

%% 3. Measurement Mean on Lie Group H (Eq. 46)
h_pred = Frechet_Mean_H(Wm, H_pred, alpha, L);

%% 4. Innovation Covariance Phh and Cross-Covariance Pgh (Eq. 47 & 48)
[Phh, Pgh] = Lie_Covariances(g_pred, h_pred, G_pred, H_pred, Wc, Prr, L);

%% 5. Tangent Innovation in Lie Algebra of H (Eq. 49)
innov_y = y - h_pred(1:3, 4);

%% 6. Kalman Gain and Error State Update in Lie Algebra of G (Eq. 49)
K      = (Phh \ Pgh')';
xi_upd = K * innov_y;

%% 7. Covariance Update (Eq. 50)
P_upd = P_pred - K * Pgh';
P_upd = 0.5 * (P_upd + P_upd');

%% 8. State Update via Lie Retraction (Eq. 51)
g_upd = g_pred * Exp_Multi_SE23T6(xi_upd);
end