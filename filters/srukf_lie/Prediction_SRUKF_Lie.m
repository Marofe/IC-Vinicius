function [g_pred, S_pred, G_pred, Chi_R] = Prediction_SRUKF_Lie(g_prev, S_prev, S_qq, S_rr, u, alpha, beta, kappa, L, dt) %#codegen
%% PREDICTION_SRUKF_Lie Time update (prediction) step on Lie Groups
% Reference: Giorgio M. Magalhaes et al. (CBA 2018), Eqs. (40), ..., (44)
% Reference: Rudolph van der Merwe & Eric A. Wan (ICASSP 2001), Eqs. (17), ..., (21)

p    = 15;
n2L1 = 2 * L + 1;

%% 1. Augmented Sigma Points directly from Cholesky Factors (ICASSP 2001, Eq. 17)
lambda = (alpha^2) * (L + kappa) - L;
eta    = sqrt(L + lambda);

W0m = lambda / (L + lambda);
W0c = lambda / (L + lambda) + (1 - alpha^2 + beta);
Wim = 1 / (2 * (L + lambda));
Wic = 1 / (2 * (L + lambda));

Wm = [W0m; repmat(Wim, 2 * L, 1)];
Wc = [W0c; repmat(Wic, 2 * L, 1)];

Sk = blkdiag(S_prev, S_qq, S_rr);             % 33 x 33 lower-triangular
Chi = [zeros(L, 1), eta * Sk, -eta * Sk];     % 33 x (2L + 1)

Chi_E = Chi(1:15, :);   % State error perturbation points (15 x 2L+1)
Chi_Q = Chi(16:30, :);  % Process noise points (15 x 2L+1)
Chi_R = Chi(31:33, :);  % Measurement noise points (3 x 2L+1)

%% 2. Pre-compute Geodetic Quantities from Mean State
p0_0       = g_prev(1:3, 5);
lla0       = Single_LLA_From_ECEF(p0_0);
Cen0       = DCM_ECEF_To_NED(lla0(1), lla0(2));
gn0        = Gravity_WGS84(lla0(1));
ge0        = Cen0 * [0; 0; gn0];
fib_scaled = u(1:3) * gn0;
wib        = u(4:6);

%% 4. Sigma Points Propagation through Group Dynamics (Eq. 41 & 42)
G_pred = zeros(13, 13, n2L1);
for i = 1:n2L1
    G_prev_i = g_prev * Exp_Multi_SE23T6(Chi_E(:, i));
    
    Cbe_i    = G_prev_i(1:3, 1:3)';
    v_i      = G_prev_i(1:3, 4);
    ba_i     = G_prev_i(6:8, 9);
    bg_i     = G_prev_i(10:12, 13);
    
    omega_b  = wib - bg_i;
    acc_e    = (fib_scaled - ba_i) + Cbe_i * ge0;
    vel_e    = Cbe_i * v_i;
    Omega_dt = [omega_b; acc_e; vel_e; zeros(6, 1)] * dt;
    
    G_pred(:, :, i) = G_prev_i * Exp_Multi_SE23T6(Omega_dt + Chi_Q(:, i));
end

%% 5. State Mean Prediction on Lie Group (Eq. 32 & 43)
g_pred = Frechet_Mean_G(Wm, G_pred, alpha, L);

%% 6. Predicted Cholesky Factor in Lie Algebra (ICASSP 2001, Eqs. 20 & 21)
xi_state = zeros(p, n2L1);
[Lg, Ug, Pg] = lu(g_pred);
for k = 1:n2L1
    xi_state(:, k) = Log_Multi_SE23T6(Ug \ (Lg \ (Pg * G_pred(:, :, k))));
end

% Eq. 20: QR of weighted sigma point residuals (2:2L+1) and process noise factor S_qq
Wic = Wc(2);
compound_state = [sqrt(Wic) * xi_state(:, 2:end), S_qq]; % 15 x (2L + 15)
[~, R_qr] = qr(compound_state', 0);
R_pred = R_qr(1:15, 1:15);                                % R_pred is 15 x 15 upper-triangular

% Eq. 21: Rank-1 Cholesky update/downdate for 0-th sigma point residual (index 1)
W0c = Wc(1);
dx0 = sqrt(abs(W0c)) * xi_state(:, 1);
if W0c >= 0
    R_pred = cholupdate(R_pred, dx0, '+');
else
    R_pred = cholupdate(R_pred, dx0, '-');
end

S_pred = R_pred'; % 15 x 15 lower-triangular (P_pred = S_pred * S_pred')
end
