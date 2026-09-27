function [g_upd, S_upd] = Update_SPSRUKF_Lie(g_pred, S_pred, y, xi_state, Chi_R, Wm, Wc, alpha, leverarm, L) %#codegen
%% Update_SPSRUKF_Lie Measurement update (correction) step on Lie Groups
% Reference: Giorgio M. Magalhaes et al. (CBA 2018), Eqs. (45), ..., (51)
% Reference: Rudolph van der Merwe & Eric A. Wan (ICASSP 2001), Eqs. (24), ..., (29)
% Reference: Sanat K. Biswas et al. (IEEE TAC 2017), Eqs. (31), ..., (38)
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

%% 3. Tangent Residuals in Lie Algebra of H and QR Innovation Factor (Eqs. 24 & 25)
xi_meas = reshape(H_pred(1:3, 4, :), 3, n2L1) - h_pred(1:3, 4);

% Eq. 24: QR of weighted measurement residuals (2:2L+1)
compound_meas = sqrt(Wc(2)) * xi_meas(:, 2:end);   % 3 x 2L
[~, R_qr] = qr(compound_meas', 0);
R_yy = R_qr(1:3, 1:3);                                    % 3 x 3 upper-triangular

% Eq. 25: Rank-1 Cholesky update/downdate for 0-th measurement sigma point
dy0 = sqrt(abs(Wc(1))) * xi_meas(:, 1);
if Wc(1) >= 0
    R_yy = cholupdate(R_yy, dy0, '+');
else
    R_yy = cholupdate(R_yy, dy0, '-');
end
S_yy = R_yy';                                             % 3 x 3 lower-triangular

% Eq. 26: Cross-covariance Pgh (15 x 3) directly using xi_state
Wc_row = reshape(Wc, 1, n2L1);
Pgh = (xi_state .* Wc_row) * xi_meas';

%% 4. Tangent Innovation in Lie Algebra of H (Eq. 49)
innov_y = y - h_pred(1:3, 4);

%% 5. Kalman Gain (Eq. 27)
K = (Pgh / S_yy') / S_yy;
xi_upd = K * innov_y;

%% 6. Posterior Cholesky Factor Downdate (Eqs. 28 & 29)
U = K * S_yy;                                             % 15 x 3
R_upd = S_pred';                                          % 15 x 15 upper-triangular
for j = 1:size(U, 2)
    R_upd = cholupdate(R_upd, U(:, j), '-');
end
S_upd = R_upd';                                           % 15 x 15 lower-triangular

%% 7. State Update via Lie Retraction (Eq. 51)
g_upd = g_pred * Exp_Multi_SE23T6(xi_upd);
end
