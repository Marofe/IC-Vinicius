function [g_pred, P_pred, xi_state, Chi_R, Wm, Wc] = Prediction_ESPUKF_Lie(g_prev, P_prev, Pqq, Prr, u, alpha, beta, kappa, L, dt, has_meas) %#codegen
%% PREDICTION_ESPUKF_LIE Extrapolated Single-Propagation UKF time update on Lie Groups
% Hand-derived adaptation of the multi-dimensional Richardson extrapolation of Biswas et al.
% (IEEE TAC 2017) Section III-B, Eqs. (39)-(43), to the matrix Lie group G = SE_2(3) x T(6).
% It is not a direct transcription of those equations.
%
% Reference: Giorgio M. Magalhaes et al. (CBA 2018), Eqs. (40), ..., (44)
% Reference: Sanat K. Biswas et al. (IEEE TAC 2017), Eqs. (39), ..., (43), (57)

if nargin < 11
    has_meas = true;
end

n2L1 = 2 * L + 1;

%% 1. Single Propagation of Central State on Lie Group G (Biswas et al. 2017, Eqs. 15-16)
[omeg, gn, Cen] = Omega_SE23T6(g_prev, u);
omegk           = omeg * dt;
g_pred_0        = g_prev * Exp_Multi_SE23T6(omegk);

%% 2. Discrete-Time Lie Algebra Transition Matrices (Biswas et al. 2017, Eqs. 21-22)
Ad_neg_omegk = Ad_G(Exp_Multi_SE23T6(-omegk));
Phi          = Phi_SE23T6(omegk);
C_pred       = Matrix_C_SE23T6(g_pred_0, u, gn, Cen, dt);
F            = Ad_neg_omegk + Phi * C_pred;

%% 3. Richardson-Style 2nd-Order Correction & 2nd-Order BCH (adapted from Biswas et al. 2017, Eqs. 39-43)
% Approximates 2nd-order terms of the sigma-point propagation without a Hessian tensor.
% For each state-perturbation sigma point Chi_E(:, i):
%   - N_1(Chi_E) uses the base Jacobian C_0 = Matrix_C_SE23T6(g_prev, u, gn, Cen, dt).
%   - N_2(Chi_E / 2) evaluates the midpoint Jacobian C_mid at g_mid = g_prev * Exp(0.5 * Chi_E)
%     together with a 2nd-order velocity-position coupling term -0.5 * (phi x rho_v * dt).
%   - The correction (C_mid - C_0) * Chi_E - 0.5 * (phi x rho_v * dt) is added to the 1st-order
%     mapping, together with the 2nd-order Baker-Campbell-Hausdorff (BCH) term 0.5 * Adj_G(A_i) * B_i.
%
% Measured accuracy (tests/Test_ESPUKF_Propagation.m, rectangular trajectory, one measurement
% step; max abs error over sigma points vs the full UKF-Lie propagation re-expressed at g_pred_0):
%   - after 30 GNSS updates: attitude 8.7e-15 rad (SPUKF, 1st order) -> 1.6e-19 rad (ESPUKF);
%     velocity 1.4e-11 -> 1.0e-11 m/s; position 5.1e-12 -> 3.2e-11 m (larger than SPUKF).
%   - first IMU step (P0): identical to SPUKF in every block (attitude 4.1e-20 rad,
%     velocity 7.6e-12 m/s, position 5.2e-10 m).
% The correction therefore removes the attitude error but not the velocity/position error.
%
% On steps without a GNSS fix, xi_state and Chi_R are not consumed by Update_ESPUKF_Lie, so
% P_pred is propagated analytically as F * P_prev * F' + Phi * Pqq * Phi' (the 1st-order form,
% as in SPUKF; Biswas et al. Eq. 57). The same test measures the relative Frobenius difference
% between this analytical P_pred and the ESPUKF sigma-point P_pred as 1.8e-11 (first step)
% and 4.9e-13 (after 30 GNSS updates).
if has_meas
    [Chi, Wm, Wc] = Sigma_Points_Lie(alpha, beta, kappa, P_prev, Pqq, Prr, L);

    Chi_E = Chi(1:15, :);   % State error perturbation points (15 x 2L+1)
    Chi_Q = Chi(16:30, :);  % Process noise points (15 x 2L+1)
    Chi_R = Chi(31:33, :);  % Measurement noise points (3 x 2L+1)

    % 1st-order baseline mapping
    xi_state = F * Chi_E + Phi * Chi_Q;

    % Base-point Jacobian for Richardson extrapolation N_1(Chi_E)
    C_0 = Matrix_C_SE23T6(g_prev, u, gn, Cen, dt);

    % Apply Richardson extrapolation + 2nd-order BCH on the 2p non-zero Chi_E columns
    % (columns 2:1+p correspond to +eta * S_prev; columns L+2:L+1+p correspond to -eta * S_prev)
    p = 15;
    state_cols = [2:1+p, L+2:L+1+p];
    for idx = 1:numel(state_cols)
        i = state_cols(idx);
        chi_e = Chi_E(:, i);

        % Midpoint state on G for N_2(Chi_E / 2) (Biswas et al. Eq. 39)
        g_mid = g_prev * Exp_Multi_SE23T6(0.5 * chi_e);
        C_mid = Matrix_C_SE23T6(g_mid, u, gn, Cen, dt);

        % 2nd-order SE_2(3) right-Jacobian coupling on position: -0.5 * (phi x (rho_v * dt))
        d2_pos = -0.5 * cross(chi_e(1:3), chi_e(4:6) * dt);

        % Richardson-extrapolated 2nd-order kinematic correction: 2 * N_2(chi_e / 2) - N_1(chi_e)
        dOmega_2nd = (C_mid - C_0) * chi_e;
        dOmega_2nd(7:9) = dOmega_2nd(7:9) + d2_pos;

        % 2nd-order BCH commutator 0.5 * [A_i, B_i] on se_2(3) x R^6
        A_i = Ad_neg_omegk * chi_e;
        B_i = Phi * (C_0 * chi_e + dOmega_2nd);
        bch_2nd = 0.5 * (Adj_G(A_i) * B_i);

        xi_state(:, i) = xi_state(:, i) + Phi * dOmega_2nd + bch_2nd;
    end

    % Extrapolated mean correction and covariance on G (Biswas et al. Eqs. 41-43)
    xi_mean     = xi_state * Wm;
    g_pred      = g_pred_0 * Exp_Multi_SE23T6(xi_mean);
    xi_centered = xi_state - xi_mean;
    xi_state    = xi_centered;

    Wc_row = reshape(Wc, 1, n2L1);
    P_pred = (xi_centered .* Wc_row) * xi_centered';
    P_pred = 0.5 * (P_pred + P_pred');
else
    g_pred   = g_pred_0;
    P_pred   = F * P_prev * F' + Phi * Pqq * Phi';
    P_pred   = 0.5 * (P_pred + P_pred');
    xi_state = zeros(15, n2L1);
    Chi_R    = zeros(3, n2L1);
    Wm       = zeros(n2L1, 1);
    Wc       = zeros(n2L1, 1);
end
end
