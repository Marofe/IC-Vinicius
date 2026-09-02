function [hx_upd, P_upd] = update_SPUKF_Lie(hx_pred, P_pred, Prr, y_meas, alpha, beta, kappa, leverarm, L) %#codegen
% UPDATE_SPUKF_LIE
% Executes the UKF measurement update step for the Single Propagation UKF on Lie Groups (SPUKF-Lie).
% As formulated in Biswas et al. (2016) and Brossard et al. (2018), local sigma points are generated 
% from the predicted covariance P_pred at each measurement epoch to compute the Kalman gain without Jacobians.

%% 1. Generate Local Sigma Points (State Only)
L = size(P_pred, 1);
lambda = alpha^2 * (L + kappa) - L;

% Compute Weights for mean and covariance
Wm = zeros(2*L+1, 1);
Wc = zeros(2*L+1, 1);
Wm(1) = lambda / (L + lambda);
Wc(1) = lambda / (L + lambda) + (1 - alpha^2 + beta);
Wm(2:end) = 1 / (2 * (L + lambda));
Wc(2:end) = 1 / (2 * (L + lambda));

% Enforce symmetry to prevent Cholesky from crashing due to float errors
P_pred = (P_pred + P_pred') / 2;

% Cholesky decomposition
S = chol((L + lambda) * P_pred, 'lower');

% Generate the Lie Algebra error sigma points
xi = zeros(L, 2*L+1);
for i = 1:L
    xi(:, i+1)   =  S(:, i);
    xi(:, i+L+1) = -S(:, i);
end

%% 2. Map to Manifold and Predict Measurements
Y = zeros(3, 2*L+1);

for i = 1:(2*L+1)
    % Wrap the flat error sigma point onto the Lie group manifold
    hx_i = hx_pred * exp_multiSE23T6(xi(:, i));

    % Extract Rotation and Position
    Ceb_i = hx_i(1:3, 1:3);
    p_i   = hx_i(1:3, 5);

    % Map to GNSS measurement space (ECEF Position with Lever Arm)
    Y(:, i) = p_i + Ceb_i * leverarm;
end

%% 3. Compute Mean Measurement & Innovation Statistics
y_bar = zeros(3, 1);
for i = 1:(2*L+1)
    y_bar = y_bar + Wm(i) * Y(:, i);
end

% Measurement Innovation Covariance (P_hh / S) and Cross-Covariance (P_gh)
P_hh = Prr; % Initialize with measurement noise covariance
P_gh = zeros(L, 3);

for i = 1:(2*L+1)
    y_diff = Y(:, i) - y_bar;
    P_hh = P_hh + Wc(i) * (y_diff * y_diff');
    P_gh = P_gh + Wc(i) * (xi(:, i) * y_diff');
end

%% 4. Kalman Gain & Correction
K = P_gh / P_hh; % (L x 3)

% Innovation vector
innovation = y_meas - y_bar;

% Update State on Lie Group Manifold
hx_upd = hx_pred * exp_multiSE23T6(K * innovation);

% Update Covariance Matrix (Joseph form approximation / standard form)
P_upd = P_pred - K * P_gh';
P_upd = (P_upd + P_upd') / 2; % Force symmetry
end
