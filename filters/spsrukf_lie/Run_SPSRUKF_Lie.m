function [hx, trP, euler] = Run_SPSRUKF_Lie(N, time, gps_time, hx, trP, P, Pqq, Prr, u, alpha, beta, kappa, L, Cen, y, leverarm, M, euler) %#codegen
% Run_SPSRUKF_Lie Executes the Single-Propagation Square-Root Unscented Kalman Filter on Lie Groups (SPSRUKF-Lie).
% Standardized 18-input, 3-output signature.
% Propagates lower-triangular Cholesky factor S (P = S * S') directly.
% Reference: Giorgio M. Magalhaes et al. (CBA 2018), Eqs. (40), ..., (51)
% Reference: Rudolph van der Merwe & Eric A. Wan (ICASSP 2001), Eqs. (16), ..., (29)
% Reference: Sanat K. Biswas et al. (IEEE TAC 2017), Eqs. (20), ..., (38)

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
    [g_pred, S_pred, xi_state, Chi_R, Wm, Wc] = Prediction_SPSRUKF_Lie(hx(:, :, k), S_curr, S_qq, S_rr, u(:, k), alpha, beta, kappa, L, dt);
    hx(:, :, k+1) = g_pred;
    S_curr = S_pred;

    %% 2. Measurement Update (Correction) - Eqs. (22) - (29)
    if (gps_idx <= M) && (abs(time(k+1) - gps_time(gps_idx)) < dt / 2)
        [g_upd, S_upd] = Update_SPSRUKF_Lie(g_pred, S_curr, y(:, gps_idx), xi_state, Chi_R, Wm, Wc, alpha, leverarm, L);
        hx(:, :, k+1) = g_upd;
        S_curr = S_upd;
        gps_idx = gps_idx + 1;
    end

    %% 3. Post-Processing Logging
    % tr(P) = tr(S * S') = sum of squared entries of S
    trP(k+1) = sum(S_curr(:).^2);
    euler(:, k+1) = Euler_Deg_From_Rotm(CenT * hx(1:3, 1:3, k+1));

    if ~mod(k, log_interval)
        fprintf('running the SPSRUKF-Lie... %.1f%%\n', 100 * k / N);
    end
end

end
