function [Phh, Pgh] = lie_covariances(g_pred, h_pred, G_pred, H_pred, Wc, Prr, L)
%% LIE_COVARIANCES Compute innovation covariance Phh and cross-covariance Pgh on Lie Groups
% Reference: Giorgio M. Magalhães et al. (CBA 2018), Eq. 47 & 48
%
% Inputs:
%   g_pred - 13x13 predicted state on Lie Group G
%   h_pred - 4x4 predicted measurement on Lie Group H
%   G_pred - 13x13x(2L+1) propagated state sigma points
%   H_pred - 4x4x(2L+1) measurement sigma points on group H
%   Wc     - (2L+1)x1 covariance weight vector
%   Prr    - 3x3 measurement noise covariance matrix
%   L      - Augmented state dimension (L = 33)
%
% Outputs:
%   Phh    - 3x3 innovation covariance matrix
%   Pgh    - 15x3 state-measurement cross-covariance matrix

p = 15; % Process Lie algebra dimension
n2L1 = 2 * L + 1;

% Tangent error in measurement group H (q = 3)
eps_meas = squeeze(H_pred(1:3, 4, :)) - h_pred(1:3, 4);

% Tangent error in state group G (p = 15)
eps_state = zeros(p, n2L1);
[Lg, Ug, Pg] = lu(g_pred);
for k = 1:n2L1
    eps_state(:, k) = log_multiSE23T6(Ug \ (Lg \ (Pg * G_pred(:, :, k))));
end

% Covariance evaluations
Phh = eps_meas * diag(Wc) * eps_meas' + Prr; % Eq. 47
Pgh = eps_state * diag(Wc) * eps_meas';      % Eq. 48
end
