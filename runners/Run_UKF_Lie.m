function [hx, trP, euler] = Run_UKF_Lie(N, time, gps_time, hx, trP, P, Pqq, Prr, u, alpha, beta, kappa, L, Cen, y, leverarm, M, euler) %#codegen
% RUN_UKF_LIE Executes the Unscented Kalman Filter on Lie Groups (UKF-Lie).
% Standardized 18-input, 3-output signature.
% Maintains a single 15x15 covariance matrix in memory to eliminate 108 MB allocation bloat.

gps_idx = 2;
CenT = Cen';
log_interval = round(N / 10);

P_curr = P(:, :, 1);

for k = 1:N-1
    dt = time(k+1) - time(k);
    
    %% 1. Time Update (Prediction)
    [g_pred, P_pred, G_pred, Chi_R] = Prediction_UKF_Lie(hx(:, :, k), P_curr, Pqq, Prr, u(:, k), alpha, beta, kappa, L, dt);
    hx(:, :, k+1) = g_pred;
    P_curr = P_pred;
    
    %% 2. Measurement Update (Correction)
    if (gps_idx <= M) && (abs(time(k+1) - gps_time(gps_idx)) < dt / 2)
        [g_upd, P_upd] = Update_UKF_Lie(g_pred, P_curr, Pqq, Prr, y(:, gps_idx), G_pred, Chi_R, alpha, beta, kappa, leverarm, L);
        hx(:, :, k+1) = g_upd;
        P_curr = P_upd;
        gps_idx = gps_idx + 1;
    end
    
    %% 3. Post-Processing Logging
    trP(k+1) = sum(P_curr(1:16:end));
    euler(:, k+1) = Euler_Deg_From_Rotm(CenT * hx(1:3, 1:3, k+1));
    
    if ~mod(k, log_interval)
        fprintf('running the UKF-Lie... %.1f%%\n', 100 * k / N);
    end
end

end