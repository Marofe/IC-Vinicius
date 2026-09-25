function [hx, trP, euler] = Run_EKF_Lie(N, time, gps_time, hx, trP, P, Pqq, Prr, u, Cen, y, leverarm, M, euler) %#codegen
% RUN_EKF_LIE Executes the Extended Kalman Filter on Lie Groups (EKF-Lie).
% Standardized 14-input, 3-output signature.
% Maintains a single 15x15 covariance matrix in memory to eliminate 108 MB allocation bloat.

gps_idx = 2;
CenT = Cen'; % Pre-transpose once for efficiency
log_interval = round(N / 10);

P_curr = P(:, :, 1);

for k = 1:N-1
    dt = time(k+1) - time(k);
    
    %% 1. State & Covariance Propagation (Prediction)
    [hx_pred, P_pred] = Prediction_EKF_Lie(hx(:, :, k), P_curr, u(:, k), Pqq, dt);
    hx(:, :, k+1) = hx_pred;
    P_curr = P_pred;
    
    %% 2. Measurement Update (Correction)
    if (gps_idx <= M) && (abs(time(k+1) - gps_time(gps_idx)) < dt / 2)
        [hx_upd, P_upd] = Update_EKF_Lie(hx_pred, P_curr, Prr, y(:, gps_idx), leverarm);
        hx(:, :, k+1) = hx_upd;
        P_curr = P_upd;
        gps_idx = gps_idx + 1;
    end
    
    %% 3. Post-Processing Logging
    trP(k+1) = sum(P_curr(1:16:end));
    euler(:, k+1) = Euler_Deg_From_Rotm(CenT * hx(1:3, 1:3, k+1));
    
    if ~mod(k, log_interval)
        fprintf('running the EKF-Lie... %.1f%%\n', 100 * k / N);
    end
end

end