function [hx, trP, euler] = run_EKF_Lie(N, time, gps_time, hx, trP, P, Pqq, Prr, u, Cen, y, leverarm, M, euler) %#codegen
% RUN_EKF_LIE
% Executes the Extended Kalman Filter on Lie Groups.

nk = 2;
CenT = Cen';          
log_interval = round(N/10);

for k = 1:N-1
    dt = time(k+1) - time(k); 
    
    %% 1. State Propagation (Prediction)
    [hx_pred, P_pred] = prediction_EKF_Lie(hx(:,:,k), P(:,:,k), u(:,k), Pqq, dt);
    
    % Store predictions
    hx(:,:,k+1) = hx_pred;
    P(:,:,k+1)  = P_pred;
    
    %% 2. Measurement Update (Correction)
    if (abs(time(k+1) - gps_time(nk)) < dt)
        [hx(:,:,k+1), P(:,:,k+1)] = update_EKF_Lie(hx_pred, P_pred, Prr, y(:,nk), leverarm);
            
        if nk < M 
            nk = nk + 1;
        end
    end
    
    %% 3. Post-Processing Logging
    Pk = P(:,:,k+1);
    trP(k+1) = sum(Pk(1:16:end));   
    euler(:,k+1) = eulerdFromRotm(CenT*hx(1:3,1:3,k+1));
    
    if ~mod(k, log_interval)
        fprintf('running the EKF-Lie... %.1f%%\n', 100*k/N);
    end
end


end
