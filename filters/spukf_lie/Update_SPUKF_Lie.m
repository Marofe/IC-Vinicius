function [hx_upd, P_upd] = Update_SPUKF_Lie(hx_pred, P_pred, Prr, y_meas, alpha, beta, kappa, leverarm, p) %#codegen
% UPDATE_SPUKF_LIE Measurement Update Step for SPUKF on Lie Groups
%
% Generates 2p+1 sigma points in the tangent space around the predicted mean,
% instantiates GNSS position observations, computes Kalman gain, and retracts
% the correction onto the Lie group SE_2(3) x T(6).

if nargin < 9
    p = 15;
end

%% 1. Unscented Transform Parameters & Weights
lambda = alpha^2 * (p + kappa) - p;
W0m = lambda / (p + lambda);
W0c = lambda / (p + lambda) + (1 - alpha^2 + beta);
Wim = 1 / (2 * (p + lambda));
Wic = 1 / (2 * (p + lambda));

Wm = [W0m; repmat(Wim, 2*p, 1)]; % (2p+1) x 1
Wc = [W0c; repmat(Wic, 2*p, 1)]; % (2p+1) x 1

%% 2. Sigma Point Generation from P_pred in Tangent Space
P_sym = 0.5 * (P_pred + P_pred');
P_scaled = (p + lambda) * P_sym;
[S, flag] = chol(P_scaled, 'lower');
if flag ~= 0
    % Regularization if non-positive-definite
    P_reg = P_scaled + eye(p) * 1e-9;
    [S, flag2] = chol(P_reg, 'lower');
    if flag2 ~= 0
        minEig = min(eig(P_scaled));
        P_reg = P_scaled + eye(p) * (abs(minEig) * 2 + 1e-9);
        S = chol(P_reg, 'lower');
    end
end

xi = [zeros(p, 1), S, -S]; % 15 x 31

%% 3. Observation Instantiation
num_sigma = 2 * p + 1;
Y = zeros(3, num_sigma);
for i = 1:num_sigma
    hx_i = hx_pred * Exp_Multi_SE23T6(xi(:, i));
    Ceb_i = hx_i(1:3, 1:3);
    peb_i = hx_i(1:3, 5);
    Y(:, i) = peb_i + Ceb_i * leverarm; % 3x1 GNSS position observation
end

%% 4. Predicted Measurement Mean
y_bar = Y * Wm; % 3x1

%% 5. Innovation and Cross-Covariances
dy = Y - y_bar; % 3 x 31
Phh = dy * diag(Wc) * dy' + Prr; % 3x3 innovation covariance
Pgh = xi * diag(Wc) * dy';       % 15x3 state-measurement cross-covariance

%% 6. Kalman Gain, Tangent Innovation, and Lie Retraction
K = (Phh \ Pgh')'; % 15x3 Kalman gain
innovation = y_meas - y_bar; % 3x1 measurement residual
delta_x = K * innovation; % 15x1 correction in tangent space

hx_upd = hx_pred * Exp_Multi_SE23T6(delta_x);

%% 7. Symmetric Biswas (2017) A Posteriori Covariance Update
P_upd = P_pred - K * Phh * K';
P_upd = 0.5 * (P_upd + P_upd'); % Force numerical symmetry

% Positive definiteness safeguard
minEig = min(real(eig(P_upd)));
if minEig < 1e-12
    P_upd = P_upd + eye(p) * (abs(minEig) + 1e-12);
    P_upd = 0.5 * (P_upd + P_upd');
end

end