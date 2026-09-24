function [g_pred, P_pred, G_pred, Chi_R] = prediction_UKF_Lie(g_prev, P_prev, Pqq, Prr, u, alpha, beta, kappa, L, dt)
%% PREDICTION_UKF_LIE Time update (prediction) step on Lie Groups
% Reference: Giorgio M. Magalhães et al. (CBA 2018), Eq. 40 - 44
%
% Inputs:
%   g_prev - Previous state on Lie Group SE_2(3) x T(6) (13x13)
%   P_prev - Previous error covariance in tangent space (15x15)
%   Pqq    - Process noise covariance (15x15)
%   Prr    - Measurement noise covariance (3x3)
%   u      - IMU input [fib; wib] (6x1)
%   alpha  - Scaling parameter for unscented transform
%   beta   - Distribution parameter (beta = 2 for Gaussian)
%   kappa  - Secondary scaling parameter (kappa = 0)
%   L      - Augmented state dimension (L = 33)
%   dt     - Time step (scalar)
%
% Outputs:
%   g_pred - A priori predicted state on Lie Group (13x13)
%   P_pred - A priori predicted error covariance (15x15)
%   G_pred - Propagated state sigma points (13x13 x 2L+1)
%   Chi_R  - Measurement noise sigma points component (3 x 2L+1)

p = 15; % Process Lie algebra dimension
n2L1 = 2 * L + 1;

%% 1. Augmented Sigma Points Generation (Eq. 5, 6, 40)
[Chi, Wm, Wc] = SigmaPointsLie(alpha, beta, kappa, P_prev, Pqq, Prr, L);

Chi_E = squeeze(Chi(1:15, :));   % State error perturbation (15 x 2L+1)
Chi_Q = squeeze(Chi(16:30, :));  % Process noise points (15 x 2L+1)
Chi_R = squeeze(Chi(31:33, :));  % Measurement noise points (3 x 2L+1)

%% 2. Pre-compute Geodetic Quantities from Mean State
ba_0       = g_prev(6:8, 9);
bg_0       = g_prev(10:12, 13);
Cbe_0      = g_prev(1:3, 1:3)';  % Cbe = Ceb'
v0_0       = g_prev(1:3, 4);
p0_0       = g_prev(1:3, 5);
lla0       = SingleLlaFromEcef(p0_0);
Cen0       = DCM_en(lla0(1), lla0(2));
gn0        = gravityModel(lla0(1));
ge0        = Cen0 * [0; 0; gn0];
fib_scaled = u(1:3) * gn0;
wib        = u(4:6);

%% 3. Sigma Points Propagation through Group Dynamics (Eq. 41 & 42)
G_pred = zeros(13, 13, n2L1);
for i = 1:n2L1
    G_prev_i = g_prev * exp_multiSE23T6(Chi_E(:, i)); % G(t-1|t-1) (Eq. 41)
    
    Cbe_i    = G_prev_i(1:3, 1:3)';
    v_i      = G_prev_i(1:3, 4);
    ba_i     = G_prev_i(6:8, 9);
    bg_i     = G_prev_i(10:12, 13);
    
    omega_b  = wib - bg_i;
    acc_e    = (fib_scaled - ba_i) + Cbe_i * ge0;
    vel_e    = Cbe_i * v_i;
    Omega_dt = [omega_b; acc_e; vel_e; zeros(6, 1)] * dt;
    
    G_pred(:, :, i) = G_prev_i * exp_multiSE23T6(Omega_dt + Chi_Q(:, i)); % G(t|t-1) (Eq. 42)
end

%% 4. State Mean Prediction on Lie Group (Eq. 32 & 43)
g_pred = frechet_mean_g(Wm, G_pred, alpha, L);

%% 5. Predicted Covariance in Lie Algebra (Eq. 44)
eps_state = zeros(p, n2L1);
[Lg, Ug, Pg] = lu(g_pred);
for k = 1:n2L1
    eps_state(:, k) = log_multiSE23T6(Ug \ (Lg \ (Pg * G_pred(:, :, k))));
end

P_pred = eps_state * diag(Wc) * eps_state' + Pqq; % Eq. 44
P_pred = 0.5 * (P_pred + P_pred'); % Enforce numerical symmetry

end
