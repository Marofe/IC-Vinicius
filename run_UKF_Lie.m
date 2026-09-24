function [rmse,hx,trP,euler] = run_UKF_Lie(N,time,gps_time,hx,trP,P,Pqq,Prr,u,alpha,beta,kappa,L,Cen,y,leverarm,M,euler,ref)
gps_idx=2;
CenT=Cen';          % pre-transpose once (reused N times in loop)
log_interval=round(N/10);
for k=1:N-1
    dt=time(k+1)-time(k); % adaptive sampling time
    %% time update (prediction) -> predicted state g(t|t-1)
    [hx(:,:,k+1),P(:,:,k+1),G_pred,Chi_R]=prediction_UKF_Lie(hx(:,:,k),P(:,:,k),Pqq,Prr,u(:,k),alpha,beta,kappa,L,dt);
    %% measurement update (correction) -> updated state g(t|t)
    if (abs(time(k)-gps_time(gps_idx))<dt)
        [hx(:,:,k+1),P(:,:,k+1)]=Update_UKF_Lie(hx(:,:,k+1),P(:,:,k+1),Pqq,Prr,y(:,gps_idx),G_pred,Chi_R,alpha,beta,kappa,leverarm,L);
        if gps_idx<M 
            gps_idx=gps_idx+1;
        end
    end
    Pk=P(:,:,k+1);
    trP(k+1)=sum(Pk(1:16:end));   % sum of diagonal (faster than trace())
    euler(:,k+1)=eulerdFromRotm(CenT*hx(1:3,1:3,k+1));
    %%
    if ~mod(k,log_interval)
        fprintf('running the UKF-Lie... %.1f%%\n',100*k/N);
    end
end
rmse=evaluateStateRMSE(euler,squeeze(hx(1:3,5,:)),squeeze(hx(1:3,4,:)),ref,Cen);
end