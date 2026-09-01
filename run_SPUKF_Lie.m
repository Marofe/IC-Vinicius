function [rmse, hx, trP, euler] = run_SPUKF_Lie(N, time, gps_time, hx, trP, P, Pqq, Prr, u, alpha, beta, kappa, L, Cen, y, leverarm, M, euler, ref) %#codegen
% RUN_SPUKF_LIE
% Executes the Single Propagation UKF on Lie Groups (SPUKF-Lie).
% Calculates sigma points only once at initialization (k=1) to construct an ensemble,
% then propagates each ensemble member over time using prediction_EKF_Lie and updates
% both the state statistics and the ensemble using update_SPUKF_Lie.

nk = 2;
CenT = Cen';          % pre-transpose once (reused N times in loop)
log_interval = round(N/10);
p = 15;
n2L1 = 2*L + 1;

%% 1. Initialize Sigma Points and Ensemble (Once at k=1)
eta = zeros(L, 1);
[Xi, Wm, Wc] = SigmaPointsLie(eta, alpha, beta, kappa, P(:,:,1), Pqq, Prr, L);
E = squeeze(Xi(1:15, :)); % (15 x 2L+1)

% Build initial ensemble on the Lie group
G_ensemble = zeros(13, 13, n2L1);
for i = 1:n2L1
    G_ensemble(:,:,i) = hx(:,:,1) * exp_multiSE23T6(E(:, i));
end

%% 2. Main Filtering Loop
for k = 1:N-1
    dt = time(k+1) - time(k); % adaptive sampling time
    
    %% Time Update (Prediction)
    % Propagate each ensemble member individually using prediction_EKF_Lie
    for i = 1:n2L1
        [G_ensemble(:,:,i), ~] = prediction_EKF_Lie(G_ensemble(:,:,i), zeros(15), u(:,k), zeros(15), dt);
    end
    
    % Reconstruct predicted mean state via intrinsic group average
    hx_pred = media_nula_g(Wm, G_ensemble, alpha, L);
    hx(:,:,k+1) = hx_pred;
    
    % Reconstruct predicted covariance from ensemble spread + process noise
    epsg = zeros(p, n2L1);
    for i = 1:n2L1
        epsg(:, i) = log_multiSE23T6(hx_pred \ G_ensemble(:,:,i));
    end
    P_pred = epsg * diag(Wc) * epsg' + Pqq;
    P_pred = 0.5 * (P_pred + P_pred'); % force symmetry
    P(:,:,k+1) = P_pred;
    
    %% Measurement Update (Correction)
    if (abs(time(k+1) - gps_time(nk)) < dt)
        [hx_upd, P_upd, G_ensemble] = update_SPUKF_Lie(hx_pred, P_pred, G_ensemble, Wm, Wc, Prr, y(:,nk), leverarm, L);
        hx(:,:,k+1) = hx_upd;
        P(:,:,k+1)  = P_upd;
        if nk < M
            nk = nk + 1;
        end
    end
    
    %% Logging
    Pk = P(:,:,k+1);
    trP(k+1) = sum(Pk(1:16:end));   % sum of diagonal
    euler(:,k+1) = eulerdFromRotm(CenT*hx(1:3,1:3,k+1));
    
    if ~mod(k, log_interval)
        fprintf('running the SPUKF-Lie... %.1f%%\n', 100*k/N);
    end
end

rmse = evaluateStateRMSE(euler, squeeze(hx(1:3,5,:)), squeeze(hx(1:3,4,:)), ref, Cen);
end
