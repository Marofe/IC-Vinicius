function [hx, trP, euler] = run_UKF_Lie(N, time, gps_time, hx, trP, P, Pqq, Prr, u, alpha,beta,kappa,L,Cen,y,leverarm,M,euler) %#codegen
% RUN_UKF_LIE
% Executes the Unscented Kalman Filter on Lie Groups (UKF-Lie).

nk=2;
CenT=Cen';          % pre-transpose once (reused N times in loop)
log_interval=round(N/10);

for k=1:N-1
    dt=time(k+1)-time(k); % adaptive sampling time
    
    %% 1. Time Update (Prediction)
    [hx(:,:,k+1),P(:,:,k+1),G,R] = prediction_UKF_Lie(hx(:,:,k),P(:,:,k),Pqq,Prr,u(:,k),alpha,beta,kappa,L,dt);
    
    %% 2. Measurement Update (Correction)
    if (abs(time(k)-gps_time(nk))<dt)
        [hx(:,:,k+1),P(:,:,k+1)] = update_UKF_Lie(hx(:,:,k+1),P(:,:,k+1),Pqq,Prr,y(:,nk),G,R,alpha,beta,kappa,leverarm,L);
        if nk<M 
            nk=nk+1;
        end
    end
    
    %% 3. Post-Processing Logging
    Pk=P(:,:,k+1);
    trP(k+1)=sum(Pk(1:16:end));   % sum of diagonal (faster than trace())
    euler(:,k+1)=eulerdFromRotm(CenT*hx(1:3,1:3,k+1));
    
    if ~mod(k,log_interval)
        fprintf('running the UKF-Lie... %.1f%%\n',100*k/N);
    end
end


end
