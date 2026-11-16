function [g_upd, P_upd] = Update_SPUKF_Lie(g_pred, P_pred, y, xi_state, Chi_R, Wm, Wc, alpha, leverarm, L) %#codegen
%% Update_SPUKF_Lie Measurement update (correction) step on Lie Groups
% Reference: Giorgio M. Magalhaes et al. (CBA 2018), Eqs. (45), ..., (51)
% Reference: Sanat K. Biswas et al. (IEEE TAC 2017), Eqs. (31), ..., (38)
% Reference: Guillaume Bourmaud et al. (EUSIPCO 2013), Eq. (20)
% "The steps for measurement prediction, Kalman gain computation, the mean
% state vector and the error covariance calculation is same as the UKF."
% Biswas et al. on the SPUKF algorithm

n2L1 = 2 * L + 1;

%% 1. Retract Sigma Points to G and Instantiate Measurements on H = T(3) (Eq. 45)
H_pred = zeros(4, 4, n2L1);
for i = 1:n2L1
    G_pred_i = g_pred * Exp_Multi_SE23T6(xi_state(:, i));
    Ceb      = G_pred_i(1:3, 1:3);
    peb      = G_pred_i(1:3, 5);
    H_pred(:, :, i) = [eye(3), peb + Ceb * leverarm + Chi_R(:, i); zeros(1, 3), 1];
end

%% 2. Measurement Mean on Lie Group H (Eq. 46)
h_pred = Frechet_Mean_H(Wm, H_pred, alpha, L);

%% 3. Innovation Covariance Phh and Cross-Covariance Pgh (Eqs. 47 & 48)
xi_meas = reshape(H_pred(1:3, 4, :), 3, n2L1) - h_pred(1:3, 4);

Wc_row = reshape(Wc, 1, n2L1);
Phh    = (xi_meas .* Wc_row) * xi_meas';
Pgh    = (xi_state .* Wc_row) * xi_meas';

%% 4. Tangent Innovation in Lie Algebra of H (Eq. 49)
innov_y = y - h_pred(1:3, 4);

%% 5. Kalman Gain and Error State Update in Lie Algebra of G (Eq. 49)
K      = (Phh \ Pgh')';
xi_upd = K * innov_y;

%% 6. Covariance Update and Tangent-Space Reset (Eq. 50; Bourmaud et al. 2013, Eq. 20)
P_upd = P_pred - K * Pgh';

% Bourmaud et al. (2013) covariance reset with the right Jacobian J_r(xi_upd) = Phi_SE23T6(xi_upd).
% P_upd = P_pred - K * Pgh' is the covariance of the error around the prior mean g_pred.
% After the retraction g_upd = g_pred * Exp(xi_upd), the first-order identity
% g_pred * Exp(xi_upd + d) ~= g_upd * Exp(J_r(xi_upd) * d) maps that error into the
% tangent space of the posterior mean g_upd, so P_upd <- J_r * P_upd * J_r'.
Phi_upd = Phi_SE23T6(xi_upd);
P_upd   = Phi_upd * P_upd * Phi_upd';
P_upd   = 0.5 * (P_upd + P_upd');

%% 7. State Update via Lie Retraction (Eq. 51)
g_upd = g_pred * Exp_Multi_SE23T6(xi_upd);
end
