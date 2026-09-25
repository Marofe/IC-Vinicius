function [g_upd, S_upd] = Update_SRUKF_Lie(g_pred, S_pred, S_rr, y, G_pred, Chi_R, alpha, beta, kappa, leverarm, L) %#codegen
%% Update_SRUKF_Lie Measurement update (correction) step on Lie Groups
% Reference: Giorgio M. Magalhaes et al. (CBA 2018), Eqs. (45), ..., (51)
% Reference: Rudolph van der Merwe & Eric A. Wan (ICASSP 2001), Eqs. (24), ..., (29)

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

%% 4. Tangent Residuals in Lie Algebras of H and G
xi_meas = reshape(H_pred(1:3, 4, :), 3, n2L1) - h_pred(1:3, 4);

xi_state = zeros(15, n2L1);
[Lg, Ug, Pg] = lu(g_pred);
for k = 1:n2L1
    xi_state(:, k) = Log_Multi_SE23T6(Ug \ (Lg \ (Pg * G_pred(:, :, k))));
end

% Eq. 24: QR of weighted measurement residuals (2:2L+1) and meas. noise factor S_rr
compound_meas = [sqrt(Wic) * xi_meas(:, 2:end), S_rr];   % 3 x (2L + 3)
[~, R_qr] = qr(compound_meas', 0);
R_yy = R_qr(1:3, 1:3);                                    % 3 x 3 upper-triangular

% Eq. 25: Rank-1 Cholesky update/downdate for 0-th measurement sigma point
dy0 = sqrt(abs(W0c)) * xi_meas(:, 1);
if W0c >= 0
    R_yy = cholupdate(R_yy, dy0, '+');
else
    R_yy = cholupdate(R_yy, dy0, '-');
end
S_yy = R_yy';                                             % 3 x 3 lower-triangular

% Eq. 26: Cross-covariance Pgh (15 x 3)
Wc_row = reshape(Wc, 1, n2L1);
Pgh = (xi_state .* Wc_row) * xi_meas';

%% 5. Tangent Innovation in Lie Algebra of H (Eq. 49)
innov_y = y - h_pred(1:3, 4);

%% 6. Kalman Gain (Eq. 27)
K = (Pgh / S_yy') / S_yy;
xi_upd = K * innov_y;

%% 7. Posterior Cholesky Factor Downdate (Eqs. 28 & 29)
U = K * S_yy;                                             % 15 x 3
R_upd = S_pred';                                          % 15 x 15 upper-triangular
for j = 1:size(U, 2)
    R_upd = cholupdate(R_upd, U(:, j), '-');
end
S_upd = R_upd';                                           % 15 x 15 lower-triangular

%% 8. State Update via Lie Retraction (Eq. 51)
g_upd = g_pred * Exp_Multi_SE23T6(xi_upd);
end
