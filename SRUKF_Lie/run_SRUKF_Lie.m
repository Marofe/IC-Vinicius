function [hx, trP, euler] = run_SRUKF_Lie(N, time, gps_time, hx, trP, P, Pqq, Prr, u, alpha,beta,kappa,L,Cen,y,leverarm,M,euler) %#codegen
% RUN_SRUKF_LIE
% Executes the Square Root Unscented Kalman Filter on Lie Groups (SRUKF-Lie).

gps_idx=2;
CenT=Cen';          % pre-transpose once (reused N times in loop)
log_interval=round(N/10);

%% SigmaPoint and Cholesky factor (S) calculation outside main filter loop
[Chi_E, Chi_Q, Chi_R, Wm, Wc] = SRSigmaPointsLie(alpha, beta, kappa, P(:,:,1), Pqq, Prr, L);

for k=1:N-1
    dt=time(k+1)-time(k); % adaptive sampling time

    %% 2. Time Update (Prediction) -> predicted state g(t|t-1)
    [hx(:,:,k+1), P(:,:,k+1), G_pred, Chi_R] = prediction_SRUKF_Lie(hx(:,:,k), P(:,:,k), Pqq, Prr, u(:,k), alpha, beta, kappa, L, dt, Chi_E, Chi_Q, Chi_R, Wm, Wc);

    %% 3. Measurement Update (Correction) -> updated state g(t|t)
    if (gps_idx <= M) && (abs(time(k+1) - gps_time(gps_idx)) < dt/2)
        [hx(:,:,k+1), P(:,:,k+1)] = update_SRUKF_Lie(hx(:,:,k+1), P(:,:,k+1), Pqq, Prr, y(:,gps_idx), G_pred, Chi_R, alpha, beta, kappa, leverarm, L);
        gps_idx = gps_idx + 1;
    end

    %% 4. Post-Processing Logging
    Pk=P(:,:,k+1);
    trP(k+1)=sum(Pk(1:16:end));   % sum of diagonal (faster than trace())
    euler(:,k+1)=eulerdFromRotm(CenT*hx(1:3,1:3,k+1));

    if ~mod(k,log_interval)
        fprintf('running the SRUKF-Lie... %.1f%%\n',100*k/N);
    end
end


end
