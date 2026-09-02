function [rmse, hx, trP, euler] = run_SPUKF_Lie(N, time, gps_time, hx, trP, P, Pqq, Prr, u, alpha, beta, kappa, L, Cen, y, leverarm, M, euler, ref) %#codegen
% RUN_SPUKF_LIE
% Executes the Single Propagation Unscented Kalman Filter on Lie Groups (SPUKF-Lie).
%
% Based on Biswas et al. (2016) and Brossard et al. (2018):
% 1. State Prediction: Single non-linear numerical integration of the mean state,
%    with analytical Jacobian-based covariance propagation (prediction_EKF_Lie).
%    This is mathematically equivalent to the linear Jacobian sigma point extrapolation
%    in Biswas et al., saving ~90% computation time in prediction.
% 2. Measurement Update: Deterministic unscented transformation on the Lie group (update_SPUKF_Lie),
%    generating local Lie-algebra sigma points at each measurement epoch to compute the Kalman gain.

nk = 2;
CenT = Cen';          
log_interval = round(N/10);

for k = 1:N-1
    dt = time(k+1) - time(k); 
    
    %% 1. Single State Propagation (Prediction)
    % Propagate mean state and covariance analytically (EKF prediction)
    [hx_pred, P_pred] = prediction_EKF_Lie(hx(:,:,k), P(:,:,k), u(:,k), Pqq, dt);
    
    % Store predictions
    hx(:,:,k+1) = hx_pred;
    P(:,:,k+1)  = P_pred;
    
    %% 2. UKF Measurement Update (Correction)
    if (abs(time(k+1) - gps_time(nk)) < dt)
        [hx(:,:,k+1), P(:,:,k+1)] = update_SPUKF_Lie(hx_pred, P_pred, Prr, y(:,nk), alpha, beta, kappa, leverarm, L);
            
        if nk < M 
            nk = nk + 1;
        end
    end
    
    %% 3. Post-Processing Logging
    Pk = P(:,:,k+1);
    trP(k+1) = sum(Pk(1:16:end));   
    euler(:,k+1) = eulerdFromRotm(CenT*hx(1:3,1:3,k+1));
    
    if ~mod(k, log_interval)
        fprintf('running the SPUKF-Lie... %.1f%%\n', 100*k/N);
    end
end

rmse = evaluateStateRMSE(euler, squeeze(hx(1:3,5,:)), squeeze(hx(1:3,4,:)), ref, Cen);
end
