function [g_pred, S_pred, xi_state, Chi_R, Wm, Wc] = Prediction_SPSRUKF_Lie(g_prev, S_prev, S_qq, S_rr, u, alpha, beta, kappa, L, dt, has_meas) %#codegen
%% PREDICTION_SPSRUKF_Lie Time update (prediction) step on Lie Groups
% Reference: Giorgio M. Magalhaes et al. (CBA 2018), Eqs. (40), ..., (44)
% Reference: Rudolph van der Merwe & Eric A. Wan (ICASSP 2001), Eqs. (17), ..., (21)
% Reference: Sanat K. Biswas et al. (IEEE TAC 2017), Eqs. (20), ..., (28), (57)

if nargin < 11
    has_meas = true;
end

n2L1 = 2 * L + 1;

%% 1. Single Propagation of Central State on Lie Group G (Biswas et al. 2017, Eqs. 15-16)
% Because the mapped perturbations are antisymmetric in the tangent space
% of g_pred_0, the Frechet mean on G is directly g_pred = g_pred_0.
[omeg, gn, Cen] = Omega_SE23T6(g_prev, u);
omegk           = omeg * dt;
g_pred          = g_prev * Exp_Multi_SE23T6(omegk);

%% 2. Discrete-Time Lie Algebra Transition Matrices (Biswas et al. 2017, Eqs. 21-22)
Phi = Phi_SE23T6(omegk);
C   = Matrix_C_SE23T6(g_pred, u, gn, Cen, dt);
F   = Ad_G(Exp_Multi_SE23T6(-omegk)) + Phi * C; % Lie algebra mapped non-linear function Phi

%% 3. Selective Sigma-Point Instantiation & Square-Root Propagation (ICASSP 2001, Eq. 20; Biswas Eq. 57)
% Generate and map the 2L + 1 sigma points only at measurement epochs (has_meas == true).
% Because sqrt(Wc(2)) * eta = 1 / sqrt(2) and the positive and negative sigma-point
% blocks [eta * Sk, -eta * Sk] contribute identically to the Gram matrix, the QR factor of
% sqrt(Wc(2)) * xi_state(:, 2:end)' (66 x 15) is algebraically identical to the QR factor
% of [F * S_prev, Phi * S_qq]' (30 x 15). On the 199 non-GNSS IMU steps where xi_state and
% Chi_R are not consumed by Update_SPSRUKF_Lie, computing the 30 x 15 QR directly avoids
% assembling the 33 x 67 sigma-point matrix and 15 x 67 products (Biswas et al. 2017, Eq. 57).
if has_meas
    % Measurement epoch: instantiate augmented sigma points and map to Lie algebra for Update_SPSRUKF_Lie
    lambda = (alpha^2) * (L + kappa) - L;
    eta    = sqrt(L + lambda);

    W0m = lambda / (L + lambda);
    W0c = lambda / (L + lambda) + (1 - alpha^2 + beta);
    Wi  = 1 / (2 * (L + lambda));

    Wm = [W0m; repmat(Wi, 2 * L, 1)];
    Wc = [W0c; repmat(Wi, 2 * L, 1)];

    Sk  = blkdiag(S_prev, S_qq, S_rr);            % 33 x 33 lower-triangular
    Chi = [zeros(L, 1), eta * Sk, -eta * Sk];     % 33 x (2L + 1)

    Chi_E = Chi(1:15, :);   % State error perturbation points (15 x 2L+1)
    Chi_Q = Chi(16:30, :);  % Process noise points (15 x 2L+1)
    Chi_R = Chi(31:33, :);  % Measurement noise points (3 x 2L+1)

    xi_state = F * Chi_E + Phi * Chi_Q;           % 15 x (2L + 1)

    % Eq. 20: QR of weighted sigma point residuals (2:2L+1)
    compound_state = sqrt(Wc(2)) * xi_state(:, 2:end); % 15 x 2L
    [~, R_qr] = qr(compound_state', 0);
    R_pred = R_qr(1:15, 1:15);                         % 15 x 15 upper-triangular

    % Note: xi_state(:, 1) == 0, so the 0-th sigma point rank-1 update is zero.
    S_pred = R_pred'; % 15 x 15 lower-triangular (P_pred = S_pred * S_pred')
else
    % Pure dead-reckoning IMU step: direct 30 x 15 QR of [F * S_prev, Phi * S_qq]'
    [~, R_qr] = qr([F * S_prev, Phi * S_qq]', 0);
    S_pred    = R_qr(1:15, 1:15)';
    xi_state  = zeros(15, n2L1);
    Chi_R     = zeros(3, n2L1);
    Wm        = zeros(n2L1, 1);
    Wc        = zeros(n2L1, 1);
end
end
