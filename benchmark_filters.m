% benchmark_all_filters.m
% Interactive benchmarking tool for Lie Group state estimators.
% Prompts user for trajectory and filter selection, compiles missing MEX files,
% runs benchmarks, calculates RMSE/Execution times, and manages non-destructive
% saving to the workspace.

close all
clear all

addLibrary('inslib');

%% 1. Interactive Prompt Interface
disp('================================================');
disp('   Lie Group State Estimation Benchmarking');
disp('================================================');
disp('Step 1: Select Trajectory:');
disp('  [1] Rectangular');
disp('  [2] Circular');
disp('  [3] Helicoidal');
disp('  [4] All 3 Trajectories');

try; traj_choice = input('Enter your choice (1-4) [default: 4]: ', 's'); catch; traj_choice = '4'; end
if isempty(traj_choice), traj_choice = '4'; end

trajectories = {};
if contains(traj_choice, '1'), trajectories{end+1} = 'rectangular'; end
if contains(traj_choice, '2'), trajectories{end+1} = 'circular'; end
if contains(traj_choice, '3'), trajectories{end+1} = 'helicoidal'; end
if contains(traj_choice, '4') || isempty(trajectories)
    trajectories = {'rectangular', 'circular', 'helicoidal'}; 
end

disp(' ');
disp('Step 2: Select Filters:');
disp('  [1] EKF_Lie');
disp('  [2] IUKF_Lie');
disp('  [3] SPUKF_Lie');
disp('  [4] UKF_Lie');

disp('  [6] All Available Filters');

try; filt_choice = input('Enter your choice (e.g. 1, 3) [default: 6]: ', 's'); catch; filt_choice = '6'; end
if isempty(filt_choice), filt_choice = '6'; end

all_filters = {'EKF_Lie', 'IUKF_Lie', 'SPUKF_Lie', 'UKF_Lie'};
filters = {};
if contains(filt_choice, '1'), filters{end+1} = 'EKF_Lie'; end
if contains(filt_choice, '2'), filters{end+1} = 'IUKF_Lie'; end
if contains(filt_choice, '3'), filters{end+1} = 'SPUKF_Lie'; end
if contains(filt_choice, '4'), filters{end+1} = 'UKF_Lie'; end

if contains(filt_choice, '6') || isempty(filters)
    filters = all_filters;
end

%% 2. Build MEX binaries if needed
for i = 1:numel(filters)
    fName = filters{i};
    sourceFile = fullfile(pwd, ['run_' fName '.m']);
    mexFile = fullfile(pwd, ['run_' fName '_mex.' mexext]);
    needsRebuild = false;
    
    if ~isfile(mexFile)
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

%% 3. Load / Initialize safe results workspace
if isfile('benchmark_results.mat')
    old_data = load('benchmark_results.mat');
    results = old_data.results;
else
    results = struct();
end

%% 4. Execution Loop
for t = 1:numel(trajectories)
    trajectory = trajectories{t};
    fprintf('\n****************************************\n');
    fprintf('   Loading Trajectory: %s\n', trajectory);
    fprintf('****************************************\n');
    
    load(['data/' trajectory '/data_sim_' trajectory '_bias.mat']);

    p = 15; q = 3; r = 15; L = 2*p + q;
    N = size(time,1); M = size(gps_time,1); n = 13;

    % Noise statistics
    Na = 1e-9 * ones(3,1); Nv = 1e-3 * ones(3,1); Ng = 1e-6 * ones(3,1);
    ba = 1e-9 * ones(3,1); bg = 1e-9 * ones(3,1); sigmaGnss = 1e-2 * ones(3,1);

    Pqq = blkdiag(diag(Ng.^2), diag(Na.^2), diag(Nv.^2), diag(ba.^2), diag(bg.^2));
    Prr = diag(sigmaGnss.^2);

    beta = 2; kappa = 0; alpha_opt = 0.0140;

    u = [fib wib]';
    y = gps_pe';
    leverarm = [0.040; -0.139; -0.439];

    v0 = [0;0;0]; p0 = gps_pe(1,:)';
    lla0 = SingleLlaFromEcef(p0); Cen = DCM_en(lla0(1), lla0(2));
    gn = gravityModel(lla0(1));

    euler0 = eulerFromRotm(Cen', 'ZYX')'; Ceb_0 = rotm(flip(euler0), 'ZYX')';
    ba0 = zeros(3,1); bg0 = zeros(3,1);

    hx0 = blkdiag([Ceb_0 v0 p0; zeros(2,3) eye(2)], [eye(3) ba0; zeros(1,3) 1], [eye(3) bg0; zeros(1,3) 1]);
    P0 = diag([1e-6, 1e-6, 1e-6, 1e-9, 1e-9, 1e-9, 1e-6, 1e-6, 1e-6, 1e-6, 1e-6, 1e-6, 1e-9, 1e-9, 1e-9]);

    if ~isfield(results, trajectory)
        results.(trajectory) = struct();
    end

    for i = 1:numel(filters)
        fName = filters{i};
        fprintf('\n========================================\n');
        fprintf('Running %s on %s...\n', fName, trajectory);
        fprintf('========================================\n');
        
        P_k = zeros(p,p,N); P_k(:,:,1) = P0;
        trP_k = zeros(1,N); hx_k = zeros(n,n,N); hx_k(:,:,1) = hx0;
        euler_k = zeros(3,N); euler_k(:,1) = eulerdFromRotm(Cen'*hx_k(1:3,1:3,1), 'ZYX');
        
        mexFunc = str2func(['run_' fName '_mex']);
        
        tic;
        if strcmp(fName, 'EKF_Lie')
            % EKF doesn't require Unscented Transform sampling params
            [hx_out, trP_out, euler_out] = mexFunc(N, time, gps_time, hx_k, trP_k, P_k, Pqq, Prr, u, Cen, y, leverarm, M, euler_k);
        else
            [hx_out, trP_out, euler_out] = mexFunc(N, time, gps_time, hx_k, trP_k, P_k, Pqq, Prr, u, alpha_opt, beta, kappa, L, Cen, y, leverarm, M, euler_k);
        end
        execTime = toc;
        perStepTime = execTime / (N - 1);
        
        [rmse_calc, angles_rmse, pos_rmse, vel_rmse] = evaluateStateRMSE(euler_out, squeeze(hx_out(1:3,5,:)), squeeze(hx_out(1:3,4,:)), ref, Cen);
        
        % Overlaps old metrics with new ones non-destructively
        results.(trajectory).(fName).rmse_total = rmse_calc;
        results.(trajectory).(fName).pos_rmse_3d = norm(pos_rmse);
        results.(trajectory).(fName).vel_rmse_3d = norm(vel_rmse);
        results.(trajectory).(fName).att_rmse_3d = norm(angles_rmse);
        results.(trajectory).(fName).execTime = execTime;
        results.(trajectory).(fName).perStepTime = perStepTime;
        
        fprintf('Finished %s in %.4f seconds. Combined RMSE: %.4f\n', fName, execTime, rmse_calc);
        fprintf('  Per Step Time: %.6f seconds\n', perStepTime);
    end
end

% Save safely without wiping un-benchmarked filters
save('benchmark_results.mat', 'results');
disp('Benchmark completed and saved safely to benchmark_results.mat');

%% 5. Print Final Summary Table & Plotting
for t = 1:numel(trajectories)
    trajectory = trajectories{t};
    fprintf('\n\n==================== BENCHMARK RESULTS: %s ====================\n', upper(trajectory));
    fprintf('%-12s | %-10s | %-12s | %-12s | %-12s | %-10s | %-12s\n', ...
        'Filter', 'Total RMSE', 'Pos RMSE (m)', 'Vel RMSE(m/s)', 'Att RMSE(deg)', 'Time (s)', 'Per Step (s)');
    fprintf('------------------------------------------------------------------------------------------------\n');
    
    fields = fieldnames(results.(trajectory));
    rmse_totals = [];
    exec_times = [];
    labels = {};
    
    for i = 1:numel(fields)
        fName = fields{i};
        res = results.(trajectory).(fName);
        fprintf('%-12s | %10.4f | %12.4f | %12.4f | %12.4f | %10.4f | %12.6f\n', ...
            fName, res.rmse_total, res.pos_rmse_3d, res.vel_rmse_3d, res.att_rmse_3d, res.execTime, res.perStepTime);
            
        rmse_totals(end+1) = res.rmse_total;
        exec_times(end+1) = res.execTime;
        labels{end+1} = fName;
    end
    fprintf('================================================================================================\n');
    
    % Summary Plotting
    fig = figure('Name', sprintf('Benchmark Summary - %s', trajectory), 'NumberTitle', 'off');
    
    subplot(1,2,1);
    bar(rmse_totals);
    set(gca, 'xticklabel', labels);
    title(sprintf('Combined RMSE (%s)', trajectory));
    ylabel('RMSE');
    grid on;
    xtickangle(45);
    
    subplot(1,2,2);
    bar(exec_times);
    set(gca, 'xticklabel', labels);
    title('Total Execution Time (s)');
    ylabel('Seconds');
    grid on;
    xtickangle(45);
end
