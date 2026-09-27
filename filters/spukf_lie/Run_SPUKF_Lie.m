function [hx, trP, euler] = Run_SPUKF_Lie(N, time, gps_time, hx, trP, P, Pqq, Prr, u, alpha, beta, kappa, L, Cen, y, leverarm, M, euler) %#codegen
% Run_SPUKF_Lie Executes the Single-Propagation Unscented Kalman Filter on Lie Groups (SPUKF-Lie).
% Standardized 18-input, 3-output signature.
% Maintains a single 15x15 covariance matrix in memory to eliminate 108 MB allocation bloat.
% Reference: Giorgio M. Magalhaes et al. (CBA 2018), Eqs. (40), ..., (51)
% Reference: Sanat K. Biswas et al. (IEEE TAC 2017), Eqs. (20), ..., (38), (57)

gps_idx = 2;
CenT = Cen';
log_interval = round(N / 10);

P_curr = P(:, :, 1);

for k = 1:N-1
    dt = time(k+1) - time(k);

    % Check whether a 1 Hz GNSS measurement arrives at time(k+1) before prediction.
    % Sigma points xi_state and Chi_R are only consumed when Update_SPUKF_Lie runs.
    % Passing has_meas allows Prediction_SPUKF_Lie to skip redundant 200 Hz Cholesky and
    % 67-column matrix multiplications on the 199 non-GNSS IMU steps (Biswas et al. 2017, Eq. 57).
    has_meas = (gps_idx <= M) && (abs(time(k+1) - gps_time(gps_idx)) < dt / 2);

    %% 1. Time Update (Prediction)
    [g_pred, P_pred, xi_state, Chi_R, Wm, Wc] = Prediction_SPUKF_Lie(hx(:, :, k), P_curr, Pqq, Prr, u(:, k), alpha, beta, kappa, L, dt, has_meas);
    hx(:, :, k+1) = g_pred;
    P_curr = P_pred;

    %% 2. Measurement Update (Correction)
    if has_meas
        [g_upd, P_upd] = Update_SPUKF_Lie(g_pred, P_curr, y(:, gps_idx), xi_state, Chi_R, Wm, Wc, alpha, leverarm, L);
        hx(:, :, k+1) = g_upd;
        P_curr = P_upd;
        gps_idx = gps_idx + 1;
    end

    %% 3. Post-Processing Logging
    trP(k+1) = sum(P_curr(1:16:end));
    euler(:, k+1) = Euler_Deg_From_Rotm(CenT * hx(1:3, 1:3, k+1));

    if ~mod(k, log_interval)
        fprintf('running the SPUKF-Lie... %.1f%%\n', 100 * k / N);
    end
end

end
