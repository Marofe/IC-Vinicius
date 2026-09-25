function [g_pred, P_pred, G_pred, Chi_R] = Prediction_UKF_Lie(g_prev, P_prev, Pqq, Prr, u, alpha, beta, kappa, L, dt) %#codegen
%% PREDICTION_UKF_LIE Time update (prediction) step on Lie Groups
% Reference: Giorgio M. Magalhaes et al. (CBA 2018), Eq. 40 - 44

p    = 15;
n2L1 = 2 * L + 1;

%% 1. Augmented Sigma Points Generation (Eq. 5, 6, 40)
[Chi, Wm, Wc] = Sigma_Points_Lie(alpha, beta, kappa, P_prev, Pqq, Prr, L);

Chi_E = Chi(1:15, :);   % State error perturbation (15 x 2L+1)
Chi_Q = Chi(16:30, :);  % Process noise points (15 x 2L+1)
Chi_R = Chi(31:33, :);  % Measurement noise points (3 x 2L+1)

%% 2. Pre-compute Geodetic Quantities from Mean State
Cbe_0      = g_prev(1:3, 1:3)';
p0_0       = g_prev(1:3, 5);
lla0       = Single_LLA_From_ECEF(p0_0);
Cen0       = DCM_ECEF_To_NED(lla0(1), lla0(2));
gn0        = Gravity_WGS84(lla0(1));
ge0        = Cen0 * [0; 0; gn0];
fib_scaled = u(1:3) * gn0;
wib        = u(4:6);

%% 3. Sigma Points Propagation through Group Dynamics (Eq. 41 & 42)
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

%% 4. State Mean Prediction on Lie Group (Eq. 32 & 43)
g_pred = Frechet_Mean_G(Wm, G_pred, alpha, L);

%% 5. Predicted Covariance in Lie Algebra (Eq. 44)
eps_state = zeros(p, n2L1);
[Lg, Ug, Pg] = lu(g_pred);
for k = 1:n2L1
    eps_state(:, k) = Log_Multi_SE23T6(Ug \ (Lg \ (Pg * G_pred(:, :, k))));
end

Wc_row = reshape(Wc, 1, n2L1);
P_pred = (eps_state .* Wc_row) * eps_state' + Pqq;
P_pred = 0.5 * (P_pred + P_pred');
end