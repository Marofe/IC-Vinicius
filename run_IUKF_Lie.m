function [hx, trP, euler] = run_IUKF_Lie(N, time, gps_time, hx, trP, P, Pqq, Prr, u, alpha, beta, kappa, L, Cen, y, leverarm, M, euler) %#codegen
% RUN_IUKF_Lie
% Executes the Single Propagation Unscented Kalman Filter on Lie Groups (IUKF_Lie-Lie).
%
% Based on Biswas et al. (2016) and Brossard et al. (2018):
% 1. State Prediction: Single non-linear numerical integration of the mean state,
%    with analytical Jacobian-based covariance propagation (prediction_IUKF_Lie).
% 2. Measurement Update: Deterministic unscented transformation on the Lie group (update_IUKF_Lie),
%    generating local Lie-algebra sigma points at each measurement epoch to compute the Kalman gain.

nk = 2;
CenT = Cen';          
log_interval = round(N/10);

for k = 1:N-1
    dt = time(k+1) - time(k); 
    
    %% 1. Single State Propagation (Prediction)
    % [IUKF_Lie PAPER REF: Section III-A, Taylor series approximation (Equation 22)]
    % Variable mapping:
    % dt      -> \delta t (time step)
    % hx_pred -> Y^-(t + \delta t) (A priori predicted state)
    % P_pred  -> P_{YY}^-(t + \delta t) (A priori predicted covariance via Jacobian)
    % Propagate mean state and covariance analytically (EKF prediction)
    [hx_pred, P_pred] = prediction_IUKF_Lie(hx(:,:,k), P(:,:,k), u(:,k), Pqq, dt);
    
    % Store predictions
    hx(:,:,k+1) = hx_pred;
    P(:,:,k+1)  = P_pred;
    
    %% 2. UKF Measurement Update (Correction)
    % [IUKF_Lie PAPER REF: Section III-A, measurement update step]
    % Variable mapping:
    % y(:,nk) -> Z(k+1) (True measurement at time step k+1)
    if (abs(time(k+1) - gps_time(nk)) < dt)
        [hx(:,:,k+1), P(:,:,k+1)] = update_IUKF_Lie(hx_pred, P_pred, Prr, y(:,nk), alpha, beta, kappa, leverarm, L);
            
        if nk < M 
            nk = nk + 1;
        end
    end
    
    %% 3. Post-Processing Logging
    Pk = P(:,:,k+1);
    trP(k+1) = sum(Pk(1:16:end));   
    euler(:,k+1) = eulerdFromRotm(CenT*hx(1:3,1:3,k+1));
    
    if ~mod(k, log_interval)
        fprintf('running the IUKF_Lie-Lie... %.1f%%\n', 100*k/N);
    end
end


end
