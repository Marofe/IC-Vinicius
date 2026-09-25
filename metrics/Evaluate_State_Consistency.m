function [nees_metrics, nis_metrics] = Evaluate_State_Consistency(hx, trP, ref, Cen, y, gps_time, time, leverarm, Prr, P)
% EVALUATE_STATE_CONSISTENCY Compute NEES and NIS filter consistency metrics.
% Evaluates Normalized Estimation Error Squared (NEES) on the Lie group
% SE_2(3) x T(6) and Normalized Innovation Squared (NIS) for GNSS updates.
%
% Inputs:
%   hx       - Estimated state trajectory (13x13xN)
%   trP      - Trace of covariance (1xN)
%   ref      - Ground truth reference structure (pe, ve, euler, ba, bg)
%   Cen      - Coordinate rotation matrix from NED to ECEF (3x3)
%   y        - GNSS position measurements in ECEF (3xM)
%   gps_time - GNSS measurement timestamps (Mx1)
%   time     - IMU timestamps (Nx1)
%   leverarm - GNSS antenna lever arm vector in body frame (3x1)
%   Prr      - GNSS measurement noise covariance matrix (3x3)
%   P        - (Optional) Full covariance tensor (15x15xN)
%
% Outputs:
%   nees_metrics - Struct containing NEES time series, means, and 95% bounds
%   nis_metrics  - Struct containing NIS time series, mean, and 95% bounds

N = length(time);
M = length(gps_time);
hasFullP = (nargin >= 10) && ~isempty(P) && (size(P, 3) >= N);

% Convert reference Euler angles from ENU to NED (degrees)
eulerRef_ned = Euler_ENU_To_NED(ref.euler);

% Pre-allocate consistency vectors over GNSS epochs
nees_total = zeros(1, M);
nees_pos   = zeros(1, M);
nees_vel   = zeros(1, M);
nees_att   = zeros(1, M);
nis        = zeros(1, M);

% 95% Chi-square theoretical single-epoch critical values
chi2_15_lower = 6.2621;
chi2_15_upper = 27.4884;
chi2_3_lower  = 0.2158;
chi2_3_upper  = 9.3484;

valid_count = 0;

for m = 1:M
    t_gps = gps_time(m);
    
    % Find corresponding IMU step k
    [min_dt, k] = min(abs(time - t_gps));
    if min_dt > 0.05
        continue;
    end
    
    valid_count = valid_count + 1;
    
    %% 1. Innovation and NIS Calculation
    hx_k = hx(:, :, k);
    Ceb_k = hx_k(1:3, 1:3);
    pos_ecef_k = hx_k(1:3, 5);
    
    y_pred = pos_ecef_k + Ceb_k * leverarm;
    y_meas = y(:, m);
    nu = y_meas - y_pred;
    
    if hasFullP
        Pk = P(:, :, k);
        lever_skew = Skew_Symmetric_3(Ceb_k * leverarm);
        H_pos = zeros(3, 15);
        H_pos(:, 1:3) = lever_skew;
        H_pos(:, 7:9) = eye(3);
        S = H_pos * Pk * H_pos' + Prr;
    else
        var_pos = max(trP(k) / 15, 1e-4);
        S = var_pos * eye(3) + Prr;
    end
    
    S = 0.5 * (S + S');
    nis(m) = nu' * (S \ nu);
    
    %% 2. Lie Group State Error and NEES Calculation
    euler_k = eulerRef_ned(k, :);
    Ceb_ref = Rotm_Euler_Rad(flip(euler_k), 'ZYX')';
    ve_ref  = ref.ve(k, :)';
    pe_ref  = ref.pe(k, :)';
    ba_ref  = ref.ba;
    bg_ref  = ref.bg;
    
    X_ref = blkdiag([Ceb_ref, ve_ref, pe_ref; zeros(2, 3), eye(2)], ...
                    [eye(3), ba_ref; zeros(1, 3), 1], ...
                    [eye(3), bg_ref; zeros(1, 3), 1]);
                    
    E_k = hx_k \ X_ref;
    xi  = Log_Multi_SE23T6(E_k);
    
    xi_att = xi(1:3);
    xi_vel = xi(4:6);
    xi_pos = xi(7:9);
    
    if hasFullP
        Pk = P(:, :, k);
        Pk_sym = 0.5 * (Pk + Pk');
        
        P_total_reg   = Pk_sym + eye(15) * 1e-10;
        nees_total(m) = xi' * (P_total_reg \ xi);
        
        P_pos_reg   = Pk_sym(7:9, 7:9) + eye(3) * 1e-10;
        nees_pos(m) = xi_pos' * (P_pos_reg \ xi_pos);
        
        P_vel_reg   = Pk_sym(4:6, 4:6) + eye(3) * 1e-10;
        nees_vel(m) = xi_vel' * (P_vel_reg \ xi_vel);
        
        P_att_reg   = Pk_sym(1:3, 1:3) + eye(3) * 1e-10;
        nees_att(m) = xi_att' * (P_att_reg \ xi_att);
    else
        scale_pos = max(trP(k) / 15, 1e-4);
        scale_vel = max(trP(k) / 15, 1e-4);
        scale_att = max(trP(k) / 15, 1e-6);
        scale_tot = max(trP(k) / 15, 1e-5);
        
        nees_pos(m)   = sum(xi_pos.^2) / scale_pos;
        nees_vel(m)   = sum(xi_vel.^2) / scale_vel;
        nees_att(m)   = sum(xi_att.^2) / scale_att;
        nees_total(m) = sum(xi.^2) / scale_tot;
    end
end

eval_idx = round(0.05 * M) : M;
eval_M   = length(eval_idx);

%% 3. Package Metrics Structs
nees_metrics = struct();
nees_metrics.nees_total      = nees_total;
nees_metrics.nees_pos        = nees_pos;
nees_metrics.nees_vel        = nees_vel;
nees_metrics.nees_att        = nees_att;
nees_metrics.mean_total      = mean(nees_total(eval_idx));
nees_metrics.mean_pos        = mean(nees_pos(eval_idx));
nees_metrics.mean_vel        = mean(nees_vel(eval_idx));
nees_metrics.mean_att        = mean(nees_att(eval_idx));
nees_metrics.bounds_total_95 = [chi2_15_lower, chi2_15_upper];
nees_metrics.bounds_sub_95   = [chi2_3_lower, chi2_3_upper];
nees_metrics.bounds_mean_95  = [15 - 1.96 * sqrt(30 / eval_M), 15 + 1.96 * sqrt(30 / eval_M)];
nees_metrics.in_bounds_pct   = 100 * sum(nees_total(eval_idx) >= chi2_15_lower & nees_total(eval_idx) <= chi2_15_upper) / eval_M;

nis_metrics = struct();
nis_metrics.nis              = nis;
nis_metrics.mean_nis         = mean(nis(eval_idx));
nis_metrics.bounds_single_95 = [chi2_3_lower, chi2_3_upper];
nis_metrics.bounds_mean_95   = [3 - 1.96 * sqrt(6 / eval_M), 3 + 1.96 * sqrt(6 / eval_M)];
nis_metrics.in_bounds_pct    = 100 * sum(nis(eval_idx) >= chi2_3_lower & nis(eval_idx) <= chi2_3_upper) / eval_M;
end
