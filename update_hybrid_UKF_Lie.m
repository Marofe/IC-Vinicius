function [hx_upd, P_upd] = update_hybrid_UKF_Lie(hx_pred, P_pred, Prr, y_meas, alpha, beta, kappa, leverarm, L)
% Update_Hybrid_UKF_Lie
% Executes the UKF measurement update step for the Hybrid EKF/UKF-Lie filter.
% It numerically infers the Jacobian using the Unscented Transform.

%% 1. Generate Local Sigma Points (State Only)
% OVERRIDE: Infer the true Lie algebra dimension directly from the covariance matrix
L = size(P_pred, 1);
% We do not need Q or R here, only the state covariance P_pred[cite: 1].
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
% Preallocate space for the predicted GNSS measurements (3x1 ECEF)
Y = zeros(3, 2*L+1);

for i = 1:(2*L+1)
    % Wrap the flat error sigma point onto the Lie group manifold
    hx_i = hx_pred * exp_multiSE23T6(xi(:, i));

    % Extract rotation matrix and position from the perturbed state
    Cbe_i = hx_i(1:3, 1:3);
    p_i   = hx_i(1:3, 5);

    % GNSS measurement model with lever arm
    % y = p + Cbe * leverarm
    Y(:, i) = p_i + Cbe_i * leverarm;
end

%% 3. Compute Statistics
% Mean predicted measurement
y_bar = zeros(3, 1);
for i = 1:(2*L+1)
    y_bar = y_bar + Wm(i) * Y(:, i);
end

% Covariances
P_hh = Prr; % Initialize innovation covariance with GNSS noise Prr
P_gh = zeros(L, 3);

for i = 1:(2*L+1)
    % Measurement deviation
    dy = Y(:, i) - y_bar;

    % Innovation covariance
    P_hh = P_hh + Wc(i) * (dy * dy');

    % Cross-covariance between Lie algebra error and measurement error
    P_gh = P_gh + Wc(i) * (xi(:, i) * dy');
end

%% 4. Compute Kalman Gain and Update State
% Kalman Gain
K = P_gh / P_hh;  % MATLAB optimized alternative for P_gh * inv(P_hh)

% Innovation
innovation = y_meas - y_bar;

% State Update on the Manifold
delta_x = K * innovation;
hx_upd = hx_pred * exp_multiSE23T6(delta_x);

% Covariance Update
P_upd = P_pred - K * P_gh';

% Force symmetry to compensate for numerical rounding errors
P_upd = (P_upd + P_upd') / 2;
end