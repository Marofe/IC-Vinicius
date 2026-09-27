function [g_upd, P_upd] = Update_UKF_Lie(g_pred, P_pred, y, G_pred, Chi_R, Wm, Wc, alpha, leverarm, L) %#codegen
%% Update_UKF_Lie Measurement update (correction) step on Lie Groups
% Reference: Giorgio M. Magalhaes et al. (CBA 2018), Eqs. (45), ..., (51)
% Reference: Guillaume Bourmaud et al. (EUSIPCO 2013), Eq. (20)

p    = 15;
n2L1 = 2 * L + 1;

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
xi_meas = reshape(H_pred(1:3, 4, :), 3, n2L1) - h_pred(1:3, 4);

xi_state = zeros(p, n2L1);
[Lg, Ug, Pg] = lu(g_pred);
for k = 1:n2L1
    xi_state(:, k) = Log_Multi_SE23T6(Ug \ (Lg \ (Pg * G_pred(:, :, k))));
end

Wc_row = reshape(Wc, 1, n2L1);
Phh    = (xi_meas .* Wc_row) * xi_meas';
Pgh    = (xi_state .* Wc_row) * xi_meas';

%% 5. Tangent Innovation in Lie Algebra of H (Eq. 49)
innov_y = y - h_pred(1:3, 4);

%% 6. Kalman Gain and Error State Update in Lie Algebra of G (Eq. 49)
K      = (Phh \ Pgh')';
xi_upd = K * innov_y;

%% 7. Covariance Update and Tangent-Space Reset (Eq. 50; Bourmaud et al. 2013, Eq. 20)
P_upd = P_pred - K * Pgh';

% Apply the Bourmaud (2013) left-Jacobian covariance reset Phi_SE23T6(xi_upd).
% After retracting the state via g_upd = g_pred * Exp(xi_upd), the updated
% error covariance P_upd = P_pred - K * Pgh' is still expressed in the tangent space
% of the prior mean g_pred. Sandwiching P_upd with Phi_SE23T6(xi_upd) parallel-transports
% the covariance into the tangent space of the new posterior mean g_upd.
Phi_upd = Phi_SE23T6(xi_upd);
P_upd   = Phi_upd * P_upd * Phi_upd';
P_upd   = 0.5 * (P_upd + P_upd');

%% 8. State Update via Lie Retraction (Eq. 51)
g_upd = g_pred * Exp_Multi_SE23T6(xi_upd);
end