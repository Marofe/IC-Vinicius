function [hx_pred, P_pred] = Prediction_SPUKF_Lie(hx0, P0, u, Pqq, dt, alpha, beta, kappa, p) %#codegen
% PREDICTION_SPUKF_LIE Single Propagation UKF Prediction Step on Lie Groups
%
% Propagates the central mean state on the Lie group SE_2(3) x T(6) and maps
% the tangent sigma points using the first-order discrete error transition matrix.

if nargin < 9
    p = 15;
end

%% 1. Central State Propagation (Single Propagation)
[omeg, gn, Cen] = Omega_SE23T6(hx0, u);
omegk = omeg * dt;
hx_pred = hx0 * Exp_Multi_SE23T6(omegk); % Only 1 group exponential map

%% 2. Discrete Transition Matrix on the Lie Group
Phi = Phi_SE23T6(omegk);
C = Matrix_C_SE23T6(hx_pred, u, gn, Cen, dt);
F = Ad_G(Exp_Multi_SE23T6(-omegk)) + Phi * C; % 15x15 discrete transition matrix

%% 3. Direct Covariance Propagation (Exact Algebraic Equivalent of Tangent Sigma Points)
P_sym = 0.5 * (P0 + P0');
P_pred = F * P_sym * F' + Pqq;
P_pred = 0.5 * (P_pred + P_pred'); % Enforce numerical symmetry

end