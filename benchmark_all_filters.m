% benchmark_all_filters.m
% Runs each filter variant (UKF_Lie, SPUKF_Lie, EuKF_Lie, EnKF_Lie) using MEX,
% records their execution times and detailed RMSE metrics, and outputs a formatted table.

close all;
clear all;

addLibrary('inslib');

%% 1. Build MEX binaries if needed
filters = {'UKF_Lie', 'SPUKF_Lie', 'EuKF_Lie', 'EnKF_Lie'};
for i = 1:numel(filters)
    fName = filters{i};
    sourceFile = which(['run_' fName '.m']);
    mexFile = which(['run_' fName '_mex.' mexext]);
    needsRebuild = false;
    if isempty(mexFile)
        needsRebuild = true;
    else
        sInfo = dir(sourceFile);
        mInfo = dir(mexFile);
        if sInfo.datenum > mInfo.datenum
            needsRebuild = true;
        end
    end
    if needsRebuild
        fprintf('Building MEX for %s...\n', fName);
        eval(['build_' fName '_mex;']);
    else
        fprintf('MEX for %s is up-to-date.\n', fName);
    end
end

%% 2. Load dataset
trajectory = 'rectangular';
load(['data/' trajectory '/data_sim_' trajectory '_bias.mat']);

p = 15;
q = 3;
r = 15;
L = 2*p + q;
N = size(time,1);
M = size(gps_time,1);
n = 13;

%% 3. Noise statistics & covariances
Na = 1e-9 * ones(3,1);
Nv = 1e-3 * ones(3,1);
Ng = 1e-6 * ones(3,1);
ba = 1e-9 * ones(3,1);
bg = 1e-9 * ones(3,1);
sigmaGnss = 1e-2 * ones(3,1);

Pqq = blkdiag(diag(Ng.^2), diag(Na.^2), diag(Nv.^2), diag(ba.^2), diag(bg.^2));
Prr = diag(sigmaGnss.^2);

beta = 2;
kappa = 0;
alpha_opt = 0.0140;

u = [fib wib]';
y = gps_pe';
leverarm = [0.040; -0.139; -0.439];

v0 = [0;0;0];
p0 = gps_pe(1,:)';
lla0 = SingleLlaFromEcef(p0);
Cen = DCM_en(lla0(1), lla0(2));
gn = gravityModel(lla0(1));

euler0 = eulerFromRotm(Cen', 'ZYX')';
Ceb_0 = rotm(flip(euler0), 'ZYX')';
ba0 = zeros(3,1);
bg0 = zeros(3,1);

hx0 = blkdiag([Ceb_0 v0 p0; zeros(2,3) eye(2)], [eye(3) ba0; zeros(1,3) 1], [eye(3) bg0; zeros(1,3) 1]);
P0 = diag([1e-6, 1e-6, 1e-6, 1e-9, 1e-9, 1e-9, 1e-6, 1e-6, 1e-6, 1e-6, 1e-6, 1e-6, 1e-9, 1e-9, 1e-9]);

%% 4. Run Benchmarks
results = struct();

for i = 1:numel(filters)
    fName = filters{i};
    fprintf('\n========================================\n');
    fprintf('Running %s (MEX)...\n', fName);
    fprintf('========================================\n');
    
    % Allocate fresh state arrays
    P_k = zeros(p,p,N);
    P_k(:,:,1) = P0;
    trP_k = zeros(1,N);
    hx_k = zeros(n,n,N);
    hx_k(:,:,1) = hx0;
    euler_k = zeros(3,N);
    euler_k(:,1) = eulerdFromRotm(Cen'*hx_k(1:3,1:3,1), 'ZYX');
    
    mexFunc = str2func(['run_' fName '_mex']);
    
    tic;
    [rmse_total, hx_out, trP_out, euler_out] = mexFunc(N, time, gps_time, hx_k, trP_k, P_k, Pqq, Prr, u, alpha_opt, beta, kappa, L, Cen, y, leverarm, M, euler_k, ref);
    execTime = toc;
    
    [rmse_calc, angles_rmse, pos_rmse, vel_rmse] = evaluateStateRMSE(euler_out, squeeze(hx_out(1:3,5,:)), squeeze(hx_out(1:3,4,:)), ref, Cen);
    
    results.(fName).rmse_total = rmse_total;
    results.(fName).pos_rmse_3d = norm(pos_rmse);
    results.(fName).vel_rmse_3d = norm(vel_rmse);
    results.(fName).att_rmse_3d = norm(angles_rmse);
    results.(fName).pos_rmse = pos_rmse;
    results.(fName).vel_rmse = vel_rmse;
    results.(fName).att_rmse = angles_rmse;
    results.(fName).execTime = execTime;
    
    fprintf('Finished %s in %.4f seconds. Combined RMSE: %.4f\n', fName, execTime, rmse_total);
    fprintf('  Position RMSE: %.4f m (3D norm)\n', norm(pos_rmse));
    fprintf('  Velocity RMSE: %.4f m/s (3D norm)\n', norm(vel_rmse));
    fprintf('  Attitude RMSE: %.4f deg (3D norm)\n', norm(angles_rmse));
end

%% 5. Print Final Summary Table
fprintf('\n\n==================== BENCHMARK RESULTS ====================\n');
fprintf('%-12s | %-10s | %-12s | %-12s | %-12s | %-10s\n', ...
    'Filter', 'Total RMSE', 'Pos RMSE (m)', 'Vel RMSE(m/s)', 'Att RMSE(deg)', 'Time (s)');
fprintf('---------------------------------------------------------------------------------\n');
for i = 1:numel(filters)
    fName = filters{i};
    fprintf('%-12s | %10.4f | %12.4f | %12.4f | %12.4f | %10.4f\n', ...
        fName, results.(fName).rmse_total, results.(fName).pos_rmse_3d, ...
        results.(fName).vel_rmse_3d, results.(fName).att_rmse_3d, results.(fName).execTime);
end
fprintf('===========================================================\n');

% Save benchmark results to file
save('benchmark_results.mat', 'results');
disp('Benchmark completed and saved to benchmark_results.mat');
