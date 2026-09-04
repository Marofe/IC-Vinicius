function [hx_upd, P_upd] = update_IUKF_Lie(hx_pred, P_pred, Prr, y_meas, alpha, beta, kappa, leverarm, ~) %#codegen
% UPDATE_IUKF_Lie
% Executes the UKF measurement update step for the Single Propagation UKF on Lie Groups (IUKF_Lie-Lie).
% As formulated in Biswas et al. (2016) and Brossard et al. (2018), local sigma points are generated 
% from the predicted covariance P_pred at each measurement epoch to compute the Kalman gain without Jacobians.

%% 1. Generate Local Sigma Points (State Only)
% Infer the true Lie algebra dimension directly from the covariance matrix
L = size(P_pred, 1);
% We do not need Q or R here, only the state covariance P_pred.
lambda = alpha^2 * (L + kappa) - L;

% Compute Weights for mean and covariance
% [IUKF_Lie PAPER REF: Equation (5) - Weights calculation]
% Variable mapping:
% Wm -> Mean weights W_i
% Wc -> Covariance weights W_i
Wm = zeros(2*L+1, 1);
Wc = zeros(2*L+1, 1);
Wm(1) = lambda / (L + lambda);
Wc(1) = lambda / (L + lambda) + (1 - alpha^2 + beta);
Wm(2:end) = 1 / (2 * (L + lambda));
Wc(2:end) = 1 / (2 * (L + lambda));

% Enforce symmetry to prevent Cholesky from crashing due to float errors
P_pred = (P_pred + P_pred') / 2;

% Cholesky decomposition
% [IUKF_Lie PAPER REF: Equation for \Delta Y_i (term under the square root)]
% Variable mapping:
% S -> Scaled covariance square root \sqrt{(n+\kappa)P_{YY}^-}
P_scaled = (L + lambda) * P_pred;
[S, p_flag] = chol(P_scaled, 'lower');
if p_flag ~= 0
    P_scaled = P_scaled + eye(L) * 1e-7;
    S = chol(P_scaled, 'lower');
end

% Generate the Lie Algebra error sigma points
% [IUKF_Lie PAPER REF: Equation (4) - Calculation of deviations \Delta Y_i]
% Variable mapping:
% xi -> Deviations \Delta Y_i (generated from predicted covariance P_{YY}^-)
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
    Ceb_i = hx_i(1:3, 1:3);
    p_i   = hx_i(1:3, 5);

    % GNSS measurement model with lever arm
    % y = p + Ceb * leverarm
    % [IUKF_Lie PAPER REF: Equation (8) - Z_i(k+1) = h(Y_i(k+1))]
    % Variable mapping:
    % Y(:, i) -> Z_i(k+1) (Predicted measurement for the i-th sigma point at time k+1)
    Y(:, i) = p_i + Ceb_i * leverarm;
end

%% 3. Compute Statistics
% Mean predicted measurement
% [IUKF_Lie PAPER REF: Equation (9) - \hat{Z}^-(k+1)]
% Variable mapping:
% y_bar -> \hat{Z}^-(k+1) (Mean predicted measurement)
y_bar = zeros(3, 1);
for i = 1:(2*L+1)
    y_bar = y_bar + Wm(i) * Y(:, i);
end

% Covariances
% [IUKF_Lie PAPER REF: Equation (10) and Equation (11)]
% Variable mapping:
% P_hh -> S (Innovation covariance)
% P_gh -> P_{YZ} (Cross-covariance matrix)
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
% [IUKF_Lie PAPER REF: Section III-A, Kalman gain K (analogous to eq 36)]
% Variable mapping: K -> Kalman Gain K
K = P_gh / P_hh;  % MATLAB optimized alternative for P_gh * inv(P_hh)

% Innovation
% [IUKF_Lie PAPER REF: Equation (33) - \Delta Z calculation]
% Variable mapping: innovation -> \Delta Z
innovation = y_meas - y_bar;

% State Update on the Manifold
% [IUKF_Lie PAPER REF: Equation Y^+ = Y^- + K \Delta Z]
% Variable mapping:
% delta_x -> K \Delta Z (Calculated state correction)
% hx_upd  -> Y^+(k+1) (A posteriori state update on the Lie Group)
delta_x = K * innovation;
hx_upd = hx_pred * exp_multiSE23T6(delta_x);

% Covariance Update
% [IUKF_Lie PAPER REF: Equation P_{YY}^+ = P_{YY}^- - K S K^T]
% Variable mapping: P_upd -> P_{YY}^+ (A posteriori error covariance)
P_upd = P_pred - K * P_gh';

% Force symmetry to compensate for numerical rounding errors
P_upd = (P_upd + P_upd') / 2;
end
