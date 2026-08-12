function [rmse,hx,trP,euler] = run_EuKF_Lie(N,time,gps_time,hx,trP,P,Pqq,Prr,u,alpha,beta,kappa,L,Cen,y,leverarm,M,euler,ref)
nk=2;
CenT=Cen';          
log_interval=round(N/10);

for k=1:N-1
    dt=time(k+1)-time(k); 
    
    %% 1. EKF Time Update (Prediction)
    % Predict from step k to k+1 using standard analytical Jacobians
    [hx_pred, P_pred] = prediction_EKF_Lie(hx(:,:,k), P(:,:,k), u(:,k), Pqq, dt);
    
    % Temporarily store predictions (these become the final state if no GNSS arrives)
    hx(:,:,k+1) = hx_pred;
    P(:,:,k+1)  = P_pred;
    
    %% 2. UKF Measurement Update (Correction)
    % Check if a GNSS measurement has arrived
    if (abs(time(k+1)-gps_time(nk)) < dt)
        
        % Call the new hybrid update function.
        % CRITICAL: We pass hx_pred and P_pred. We NO LONGER pass G, R, or Pqq!
        [hx(:,:,k+1), P(:,:,k+1)] = update_hybrid_UKF_Lie(hx_pred, P_pred, Prr, y(:,nk), alpha, beta, kappa, leverarm, L);
            
        if nk<M 
            nk=nk+1;
        end
    end
    
    %% 3. Post-Processing Logging
    Pk=P(:,:,k+1);
    trP(k+1)=sum(Pk(1:16:end));   
    euler(:,k+1)=eulerdFromRotm(CenT*hx(1:3,1:3,k+1));
    
    if ~mod(k,log_interval)
        fprintf('running the Hybrid EKF/UKF-Lie... %.1f%%\n', 100*k/N);
    end
end
rmse=evaluateStateRMSE(euler,squeeze(hx(1:3,5,:)),squeeze(hx(1:3,4,:)),ref,Cen);
end