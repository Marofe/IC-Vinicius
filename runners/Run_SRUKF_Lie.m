function [hx, trP, euler] = Run_SRUKF_Lie(N, time, gps_time, hx, trP, P, Pqq, Prr, u, alpha, beta, kappa, L, Cen, y, leverarm, M, euler) %#codegen
% Run_SRUKF_Lie Executes the Square-Root Unscented Kalman Filter on Lie Groups (SRUKF-Lie).
% Standardized 18-input, 3-output signature.
% Propagates lower-triangular Cholesky factor S (P = S * S') directly.
% Reference: Giorgio M. Magalhaes et al. (CBA 2018), Eqs. (40), ..., (51)
% Reference: Rudolph van der Merwe & Eric A. Wan (ICASSP 2001), Eqs. (16), ..., (29)

gps_idx = 2;
CenT = Cen';
log_interval = round(N / 10);

%% 0. Initialization: Cholesky Factors (ICASSP 2001, Eq. 16)
P0_sym  = 0.5 * (P(:, :, 1) + P(:, :, 1)');
Pqq_sym = 0.5 * (Pqq + Pqq');
Prr_sym = 0.5 * (Prr + Prr');

S_curr = chol(P0_sym, 'lower');   % 15 x 15 state Cholesky factor S_0
S_qq   = chol(Pqq_sym, 'lower');  % 15 x 15 process noise Cholesky factor sqrt(R^v)
S_rr   = chol(Prr_sym, 'lower');  % 3 x 3 measurement noise Cholesky factor sqrt(R^n)

for k = 1:N-1
    dt = time(k+1) - time(k);

    %% 1. Time Update (Prediction) - Eqs. (17) - (21)
    [g_pred, S_pred, G_pred, Chi_R] = Prediction_SRUKF_Lie(hx(:, :, k), S_curr, S_qq, S_rr, u(:, k), alpha, beta, kappa, L, dt);
    hx(:, :, k+1) = g_pred;
    S_curr = S_pred;

    %% 2. Measurement Update (Correction) - Eqs. (22) - (29)
    if (gps_idx <= M) && (abs(time(k+1) - gps_time(gps_idx)) < dt / 2)
        [g_upd, S_upd] = Update_SRUKF_Lie(g_pred, S_curr, S_rr, y(:, gps_idx), G_pred, Chi_R, alpha, beta, kappa, leverarm, L);
        hx(:, :, k+1) = g_upd;
        S_curr = S_upd;
        gps_idx = gps_idx + 1;
    end

    %% 3. Post-Processing Logging
    % tr(P) = tr(S * S') = sum of squared entries of S
    trP(k+1) = sum(S_curr(:).^2);
    euler(:, k+1) = Euler_Deg_From_Rotm(CenT * hx(1:3, 1:3, k+1));

    if ~mod(k, log_interval)
        fprintf('running the SRUKF-Lie... %.1f%%\n', 100 * k / N);
    end
end

end
