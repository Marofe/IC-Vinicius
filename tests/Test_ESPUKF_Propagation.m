% =========================================================================
% Test_ESPUKF_Propagation.m
% =========================================================================
% Measures how closely the SPUKF (1st-order) and ESPUKF (Richardson + 2nd-order BCH)
% tangent-space sigma points match the full UKF-Lie propagation for one prediction step.
%
% Reference (full UKF-Lie propagation, re-expressed at the single-propagated mean g_pred_0):
%   xi_ref(:, i) = Log( g_pred_0 \ G_pred(:, :, i) ),
%   G_pred(:, :, i) = g_prev * Exp(Chi_E(:, i)) * Exp(Omega_dt_i + Chi_Q(:, i))
% where G_pred comes directly from Prediction_UKF_Lie (same Sigma_Points_Lie call, same Chi).
%
% Compared against:
%   - SPUKF  xi_state = F * Chi_E + Phi * Chi_Q (Prediction_SPUKF_Lie, uncentered)
%   - ESPUKF xi_state before centering (Prediction_ESPUKF_Lie output + its xi_mean)
%
% Also compares the ESPUKF P_pred on a measurement step (extrapolated sigma points) with the
% analytical F * P * F' + Phi * Pqq * Phi' used on non-measurement steps.
%
% Cases: (1) first IMU step with the configured P0; (2) a later GNSS epoch, after running
% the ESPUKF-Lie filter loop on real data up to that epoch.
%
% Usage: run from anywhere; set traj / n_gnss_warmup below to change the case.

clear; clc;
rootDir = fileparts(fileparts(mfilename('fullpath')));
Setup_Paths(false, rootDir);

traj          = 'rectangular';
n_gnss_warmup = 30;  % case 2: number of GNSS updates before the tested prediction step

%% Data and initial state (same setup as benchmark_filters)
data = load(fullfile(rootDir, 'data', traj, ['data_sim_' traj '_bias.mat']));
cfg  = Default_Filter_Config();
time = data.time; gps_time = data.gps_time;
u = [data.fib, data.wib]'; y = data.gps_pe';
M = size(gps_time, 1);
alpha = cfg.ut.alpha_opt; beta = cfg.ut.beta; kappa = cfg.ut.kappa; L = cfg.dim.L;
Pqq = cfg.cov.Pqq; Prr = cfg.cov.Prr;

p0   = data.gps_pe(1, :)';
lla0 = Single_LLA_From_ECEF(p0);
Cen  = DCM_ECEF_To_NED(lla0(1), lla0(2));
euler0 = Euler_Rad_From_Rotm(Cen', 'ZYX')';
Ceb_0  = Rotm_Euler_Rad(flip(euler0), 'ZYX')';
g0 = blkdiag([Ceb_0, zeros(3, 1), p0; zeros(2, 3), eye(2)], eye(4), eye(4));

%% Case 1: first IMU step, P0
cases(1) = struct('name', 'k = 1, P0', 'g', g0, 'P', cfg.cov.P0, 'k', 1);

%% Case 2: run ESPUKF-Lie up to the GNSS epoch after n_gnss_warmup updates
g = g0; P = cfg.cov.P0; gps_idx = 2; k = 1;
while gps_idx <= n_gnss_warmup + 1
    dt = time(k+1) - time(k);
    has_meas = (gps_idx <= M) && (abs(time(k+1) - gps_time(gps_idx)) < dt / 2);
    [g, P, xi_s, Chi_R, Wm, Wc] = Prediction_ESPUKF_Lie(g, P, Pqq, Prr, u(:, k), alpha, beta, kappa, L, dt, has_meas);
    if has_meas
        [g, P] = Update_ESPUKF_Lie(g, P, y(:, gps_idx), xi_s, Chi_R, Wm, Wc, alpha, cfg.leverarm, L);
        gps_idx = gps_idx + 1;
    end
    k = k + 1;
end
% advance to the step right before the next GNSS epoch, so the tested step is a measurement step
while ~(abs(time(k+1) - gps_time(gps_idx)) < (time(k+1) - time(k)) / 2)
    dt = time(k+1) - time(k);
    [g, P] = Prediction_ESPUKF_Lie(g, P, Pqq, Prr, u(:, k), alpha, beta, kappa, L, dt, false);
    k = k + 1;
end
cases(2) = struct('name', sprintf('k = %d, after %d GNSS updates', k, n_gnss_warmup), 'g', g, 'P', P, 'k', k);

%% Run the comparison
blocks = {'att (rad)', 1:3; 'vel (m/s)', 4:6; 'pos (m)', 7:9; 'b_a', 10:12; 'b_g', 13:15};
n2L1 = 2 * L + 1;

for c = 1:numel(cases)
    g_prev = cases(c).g; P_prev = cases(c).P; kk = cases(c).k;
    dt = time(kk+1) - time(kk);
    uk = u(:, kk);

    % Single-propagated mean (identical to the one inside SPUKF / ESPUKF)
    omeg     = Omega_SE23T6(g_prev, uk);
    g_pred_0 = g_prev * Exp_Multi_SE23T6(omeg * dt);

    % Reference: full UKF-Lie sigma-point propagation, re-expressed at g_pred_0.
    % g_pred_0 \ G_i = Exp(-Omega_0) * Exp(Chi_E(:, i)) * Exp(Omega_dt_i + Chi_Q(:, i)) exactly
    % (g_prev cancels). Evaluating it in this form avoids subtracting two ECEF positions of
    % ~6.4e6 m, whose rounding (~1e-9 m) would otherwise swamp the position-block errors.
    % Omega_dt_i is computed as in Prediction_UKF_Lie, step 3.
    [Chi, Wm, Wc] = Sigma_Points_Lie(alpha, beta, kappa, P_prev, Pqq, Prr, L);
    Chi_E = Chi(1:15, :);
    Chi_Q = Chi(16:30, :);
    lla_m = Single_LLA_From_ECEF(g_prev(1:3, 5));
    gn_m  = Gravity_WGS84(lla_m(1));
    ge_m  = DCM_ECEF_To_NED(lla_m(1), lla_m(2)) * [0; 0; gn_m];
    E_neg_omega0 = Exp_Multi_SE23T6(-omeg * dt);
    xi_ref = zeros(15, n2L1);
    for i = 1:n2L1
        G_prev_i = g_prev * Exp_Multi_SE23T6(Chi_E(:, i));   % only R, v, biases are used below
        Cbe_i = G_prev_i(1:3, 1:3)';
        Omega_dt_i = [uk(4:6) - G_prev_i(10:12, 13); ...
                      (uk(1:3) * gn_m - G_prev_i(6:8, 9)) + Cbe_i * ge_m; ...
                      Cbe_i * G_prev_i(1:3, 4); zeros(6, 1)] * dt;
        xi_ref(:, i) = Log_Multi_SE23T6(E_neg_omega0 * Exp_Multi_SE23T6(Chi_E(:, i)) ...
                                        * Exp_Multi_SE23T6(Omega_dt_i + Chi_Q(:, i)));
    end

    % Cross-check: g_pred_0 * Exp(xi_ref) reproduces Prediction_UKF_Lie's G_pred
    [~, ~, G_pred] = Prediction_UKF_Lie(g_prev, P_prev, Pqq, Prr, uk, alpha, beta, kappa, L, dt);
    ukf_diff = 0;
    for i = 1:n2L1
        ukf_diff = max(ukf_diff, max(abs(g_pred_0 * Exp_Multi_SE23T6(xi_ref(:, i)) - G_pred(:, :, i)), [], 'all'));
    end

    % SPUKF (1st order, uncentered)
    [g_sp, ~, xi_sp] = Prediction_SPUKF_Lie(g_prev, P_prev, Pqq, Prr, uk, alpha, beta, kappa, L, dt, true);

    % ESPUKF: output is centered at its own mean. Column 1 (central point) is exactly zero
    % before centering, so the centered column 1 equals -xi_mean exactly.
    [g_esp, P_esp_meas, xi_esp_c] = Prediction_ESPUKF_Lie(g_prev, P_prev, Pqq, Prr, uk, alpha, beta, kappa, L, dt, true);
    xi_esp = xi_esp_c - xi_esp_c(:, 1);

    % ESPUKF analytical covariance on a non-measurement step
    [~, P_esp_anal] = Prediction_ESPUKF_Lie(g_prev, P_prev, Pqq, Prr, uk, alpha, beta, kappa, L, dt, false);

    % Reference covariance from xi_ref, with the same (Wm, Wc) centering ESPUKF uses
    xr_c  = xi_ref - xi_ref * Wm;
    P_ref = (xr_c .* reshape(Wc, 1, n2L1)) * xr_c';
    P_ref = 0.5 * (P_ref + P_ref');

    fprintf('\n=== Case %d: %s (%s) ===\n', c, cases(c).name, traj);
    fprintf('  ||xi_ref(:,1)|| (central point vs g_pred_0) = %.3e\n', norm(xi_ref(:, 1)));
    fprintf('  max |g_pred_0 * Exp(xi_ref) - G_pred(UKF-Lie)| = %.3e  (ECEF |p| = %.3e m, eps(|p|) = %.1e)\n', ...
        ukf_diff, norm(g_prev(1:3, 5)), eps(norm(g_prev(1:3, 5))));
    fprintf('  g_spukf == g_pred_0: %d,  ||Log(g_pred_0 \\ g_espukf)|| = %.3e\n', ...
        isequal(g_sp, g_pred_0), norm(Log_Multi_SE23T6(g_pred_0 \ g_esp)));
    fprintf('  %-10s | %-12s | %-12s | %-12s | %-9s\n', 'block', 'max|xi_ref|', 'SPUKF err', 'ESPUKF err', 'ratio');
    for b = 1:size(blocks, 1)
        r = blocks{b, 2};
        ref_mag = max(abs(xi_ref(r, :)), [], 'all');
        e_sp    = max(abs(xi_sp(r, :)  - xi_ref(r, :)), [], 'all');
        e_esp   = max(abs(xi_esp(r, :) - xi_ref(r, :)), [], 'all');
        fprintf('  %-10s | %12.3e | %12.3e | %12.3e | %9.2e\n', blocks{b, 1}, ref_mag, e_sp, e_esp, e_esp / max(e_sp, realmin));
    end
    relF = @(A, B) norm(A - B, 'fro') / norm(B, 'fro');
    P_sp = (xi_sp - xi_sp * Wm) .* reshape(Wc, 1, n2L1) * (xi_sp - xi_sp * Wm)';
    fprintf('  Covariance (relative Frobenius error vs P_ref):\n');
    fprintf('    SPUKF sigma-point P          : %.3e\n', relF(0.5 * (P_sp + P_sp'), P_ref));
    fprintf('    ESPUKF P (measurement step)  : %.3e\n', relF(P_esp_meas, P_ref));
    fprintf('    ESPUKF P (analytical F P F'') : %.3e\n', relF(P_esp_anal, P_ref));
    fprintf('    ESPUKF meas vs analytical    : %.3e\n', relF(P_esp_meas, P_esp_anal));
end
