% =========================================================================
% benchmark_filters.m
% =========================================================================
% Unified execution and benchmarking script for Lie Group Navigation Filters.
% Replaces individual main_* scripts and Run_Estimator by combining single-run
% diagnostics, workspace persistence, and multi-filter/multi-trajectory
% benchmarking into a single script.
%
% Usage:
%   1. Interactive:
%        benchmark_filters
%      Follow the command window prompts to select any filter, trajectory,
%      or combination of them (e.g. '1', '1 2', '1,3', '2 3', or '4' for all).
%
%   2. Scripted / Pre-configured (use on CLI):
%        traj_choice     = '1 2';   % 1: Rectangular, 2: Circular, 3: Helicoidal, 4: All (or cell/numeric/names)
%        filt_choice     = '1 3';   % 1: EKF_Lie, 2: SPUKF_Lie, 3: UKF_Lie, 4: All (or cell/numeric/names)
%        use_mex         = true;    % true (default): compiled MEX | false: MATLAB .m runner
%        enable_plots    = false;   % true: show diagnostic plots | false: headless/batch
%        enable_profiler = false;   % true: run MATLAB profiler | false (default)
%        force_rebuild   = false;   % true: force MEX recompile | false (default)
%        benchmark_filters

% clear all
% close all
% clc

rootDir = Setup_Paths();

%% 1. Interactive or Scripted Selection of Trajectories and Filters
disp('===================================================================');
disp('   Lie Group Filters Execution & Benchmark Suite (IC-Vinicius)     ');
disp('===================================================================');

is_interactive = ~exist('traj_choice', 'var') && ~exist('filt_choice', 'var');

% --- Step 1: Trajectory Selection ---
if ~exist('traj_choice', 'var')
    disp('Step 1: Select Trajectory (single number, combination e.g. 1 2 or 1,3, or 4 for all):');
    disp('  [1] Rectangular (Nominal test)');
    disp('  [2] Circular');
    disp('  [3] Helicoidal');
    disp('  [4] All Trajectories (Default)');
    try
        traj_choice = input('Enter your choice (1-4 or combination): ', 's');
    catch
        traj_choice = '4';
    end
end
if isempty(traj_choice), traj_choice = '4'; end

if iscell(traj_choice) || isstring(traj_choice)
    traj_str = char(strjoin(string(traj_choice(:)'), ' '));
elseif isnumeric(traj_choice)
    traj_str = num2str(traj_choice(:)');
else
    traj_str = char(traj_choice);
end
traj_str_lower = lower(traj_str);

trajectories = {};
if contains(traj_str_lower, '4') || contains(traj_str_lower, 'all')
    trajectories = {'rectangular', 'circular', 'helicoidal'};
else
    if contains(traj_str_lower, '1') || contains(traj_str_lower, 'rect')
        trajectories{end+1} = 'rectangular';
    end
    if contains(traj_str_lower, '2') || contains(traj_str_lower, 'circ')
        trajectories{end+1} = 'circular';
    end
    if contains(traj_str_lower, '3') || contains(traj_str_lower, 'heli')
        trajectories{end+1} = 'helicoidal';
    end
    if isempty(trajectories)
        trajectories = {'rectangular', 'circular', 'helicoidal'};
    end
end

% --- Step 2: Filter Selection ---
if ~exist('filt_choice', 'var')
    disp(' ');
    disp('Step 2: Select Filters (single number, combination e.g. 1 3 or 2,3, or 4 for all):');
    disp('  [1] EKF_Lie');
    disp('  [2] UKF_Lie');
    disp('  [3] SPUKF_Lie');
    disp('  [4] All Available Filters');
    try
        filt_choice = input('Enter your choice (1-4 or combination): ', 's');
    catch
        filt_choice = '4';
    end
end
if isempty(filt_choice), filt_choice = '4'; end

if iscell(filt_choice) || isstring(filt_choice)
    filt_str = char(strjoin(string(filt_choice(:)'), ' '));
elseif isnumeric(filt_choice)
    filt_str = num2str(filt_choice(:)');
else
    filt_str = char(filt_choice);
end
filt_str_upper = upper(filt_str);

all_filters = {'EKF_Lie', 'SPUKF_Lie', 'UKF_Lie'};
filters = {};
if contains(filt_str_upper, '4') || contains(filt_str_upper, 'ALL')
    filters = all_filters;
else
    filt_str_no_spukf = strrep(filt_str_upper, 'SPUKF_LIE', '');
    filt_str_no_spukf = strrep(filt_str_no_spukf, 'SPUKF', '');
    if contains(filt_str_upper, '1') || contains(filt_str_upper, 'EKF')
        filters{end+1} = 'EKF_Lie';
    end
    if contains(filt_str_no_spukf, '2') || contains(filt_str_no_spukf, 'UKF')
        filters{end+1} = 'UKF_Lie';
    end
    if contains(filt_str_upper, '3') || contains(filt_str_upper, 'SPUKF')
        filters{end+1} = 'SPUKF_Lie';
    end
    if isempty(filters)
        filters = all_filters;
    end
end

% --- Step 3: Execution & Plotting Options ---
if ~exist('use_mex', 'var') || isempty(use_mex)
    use_mex = true;
end
if ~exist('enable_profiler', 'var') || isempty(enable_profiler)
    enable_profiler = false;
end
if ~exist('force_rebuild', 'var') || isempty(force_rebuild)
    force_rebuild = false;
end
if ~exist('enable_plots', 'var') || isempty(enable_plots)
    if is_interactive
        default_plot = 'n';
        if isscalar(trajectories) && isscalar(filters)
            default_plot = 'y';
        end
        try
            plot_choice = input(sprintf('Step 3: Generate diagnostic plots? (y/n): %s', default_plot), 's');
        catch
            plot_choice = default_plot;
        end
        if isempty(plot_choice), plot_choice = default_plot; end
        enable_plots = strncmpi(strtrim(plot_choice), 'y', 1);
    else
        enable_plots = false;
    end
end

fprintf('\nSelected Trajectories : %s\n', strjoin(trajectories, ', '));
fprintf('Selected Filters      : %s\n', strjoin(filters, ', '));
fprintf('Execution Mode        : %s (Plots: %d, Profiler: %d)\n', ...
     ternary_str(use_mex, 'MEX', 'MATLAB .m'), enable_plots, enable_profiler);

%% 2. Verify or Rebuild MEX Binaries (When use_mex is Enabled)
if use_mex
    for i = 1:numel(filters)
        fName = filters{i};
        needsRebuild = Check_MEX_Dependencies(fName, force_rebuild);
        if needsRebuild
            fprintf('Building MEX binary for %s...\n', fName);
            feval(['Build_' fName '_MEX']);
        else
            fprintf('MEX binary for %s is up-to-date.\n', fName);
        end
    end
end

%% 3. Load / Initialize Safe Results Database
resultsFile = fullfile(rootDir, 'benchmark_results.mat');
if isfile(resultsFile)
    old_data = load(resultsFile);
    if isfield(old_data, 'results')
        results = old_data.results;
    else
        results = struct();
    end
else
    results = struct();
end

targetFolder = fullfile(rootDir, 'Workspaces');
if ~isfolder(targetFolder)
    mkdir(targetFolder);
end

%% 4. Unified Filter Execution Loop
cfg = Default_Filter_Config();

for t = 1:numel(trajectories)
    trajectory = trajectories{t};
    fprintf('\n****************************************************\n');
    fprintf('   TRAJECTORY: %s\n', upper(trajectory));
    fprintf('****************************************************\n');
    
    dataFile = fullfile(rootDir, 'data', trajectory, ['data_sim_' trajectory '_bias.mat']);
    if ~isfile(dataFile)
        error('Trajectory dataset not found: %s', dataFile);
    end
    data = load(dataFile);

    time     = data.time;
    gps_time = data.gps_time;
    ref      = data.ref;
    u        = [data.fib, data.wib]';
    y        = data.gps_pe';
    N        = size(time, 1);
    M        = size(gps_time, 1);

    % Precompute initial geometry and homogeneous state on SE_2(3) x R^6
    p0   = data.gps_pe(1, :)';
    v0   = [0; 0; 0];
    lla0 = Single_LLA_From_ECEF(p0);
    Cen  = DCM_ECEF_To_NED(lla0(1), lla0(2));

    euler0 = Euler_Rad_From_Rotm(Cen', 'ZYX')';
    Ceb_0  = Rotm_Euler_Rad(flip(euler0), 'ZYX')';
    ba0    = zeros(3, 1);
    bg0    = zeros(3, 1);

    hx0 = blkdiag([Ceb_0, v0, p0; zeros(2, 3), eye(2)], ...
                  [eye(3), ba0; zeros(1, 3), 1], ...
                  [eye(3), bg0; zeros(1, 3), 1]);

    % Single 15x15 covariance initialization (eliminates 108 MB allocation)
    P0       = cfg.cov.P0;
    Pqq      = cfg.cov.Pqq;
    Prr      = cfg.cov.Prr;
    leverarm = cfg.leverarm;

    if ~isfield(results, trajectory)
        results.(trajectory) = struct();
    end

    for i = 1:numel(filters)
        fName = filters{i};
        fprintf('\n========================================\n');
        fprintf('Running %s on %s...\n', fName, trajectory);
        fprintf('========================================\n');
        
        hx = zeros(cfg.dim.n, cfg.dim.n, N);
        hx(:, :, 1) = hx0;
        trP = zeros(1, N);
        trP(1) = trace(P0);
        euler = zeros(3, N);
        euler(:, 1) = Euler_Deg_From_Rotm(Cen' * hx(1:3, 1:3, 1), 'ZYX');
        
        if use_mex
            runnerFunc = str2func(['run_' fName '_mex']);
        else
            runnerFunc = str2func(['Run_' fName]);
        end
        
        if enable_profiler
            profile clear;
            profile on -detail builtin;
        end
        
        tic;
        if strcmp(fName, 'EKF_Lie')
            [hx, trP, euler] = runnerFunc(N, time, gps_time, hx, trP, P0, Pqq, Prr, u, Cen, y, leverarm, M, euler);
        else
            [hx, trP, euler] = runnerFunc(N, time, gps_time, hx, trP, P0, Pqq, Prr, u, ...
                cfg.ut.alpha_opt, cfg.ut.beta, cfg.ut.kappa, cfg.dim.L, Cen, y, leverarm, M, euler);
        end
        elapsed_time = toc;
        perStepTime  = elapsed_time / (N - 1);
        
        if enable_profiler
            profile off;
            if usejava('desktop')
                try
                    profile viewer;
                catch
                end
            end
        end
        
        % Metric & Consistency Evaluation
        [pos_out, vel_out] = Extract_Lie_States(hx);
        [rmse_calc, angles_rmse, pos_rmse, vel_rmse] = Evaluate_State_RMSE(euler, pos_out, vel_out, ref, Cen);
        [nees_metrics, nis_metrics] = Evaluate_State_Consistency(hx, trP, ref, Cen, y, gps_time, time, leverarm, Prr);
        
        % Minimal Workspace Persistence per filter/trajectory run
        targetFile = fullfile(targetFolder, sprintf('sol_%s_%s.mat', fName, trajectory));
        save(targetFile, 'hx', 'trP', 'euler', 'time', 'rmse_calc', 'elapsed_time', '-v7.3');
        fprintf('Essential solution saved to: %s\n', targetFile);
        
        % Optional Diagnostic Visualization
        if enable_plots
            Plot_Filter_Diagnostics(time, gps_time, hx, trP, euler, y, ref, Cen, leverarm, fName, trajectory);
        end
        
        % Store metrics non-destructively in benchmark database
        results.(trajectory).(fName).rmse_total         = rmse_calc;
        results.(trajectory).(fName).pos_rmse_3d        = norm(pos_rmse);
        results.(trajectory).(fName).vel_rmse_3d        = norm(vel_rmse);
        results.(trajectory).(fName).att_rmse_3d        = norm(angles_rmse);
        results.(trajectory).(fName).execTime           = elapsed_time;
        results.(trajectory).(fName).perStepTime        = perStepTime;
        results.(trajectory).(fName).nees_mean_total    = nees_metrics.mean_total;
        results.(trajectory).(fName).nees_mean_pos      = nees_metrics.mean_pos;
        results.(trajectory).(fName).nees_mean_vel      = nees_metrics.mean_vel;
        results.(trajectory).(fName).nees_mean_att      = nees_metrics.mean_att;
        results.(trajectory).(fName).nees_in_bounds_pct = nees_metrics.in_bounds_pct;
        results.(trajectory).(fName).nis_mean           = nis_metrics.mean_nis;
        results.(trajectory).(fName).nis_in_bounds_pct  = nis_metrics.in_bounds_pct;
        
        fprintf('Finished %s in %.4f seconds. Combined RMSE: %.4f\n', fName, elapsed_time, rmse_calc);
        fprintf('  Per Step Time: %.6f seconds\n', perStepTime);
        fprintf('  Consistency: Mean NEES = %.2f (95%% in-bounds: %.1f%%), Mean NIS = %.2f (95%% in-bounds: %.1f%%)\n', ...
            nees_metrics.mean_total, nees_metrics.in_bounds_pct, nis_metrics.mean_nis, nis_metrics.in_bounds_pct);
        
        % Save incrementally so partial runs are preserved
        save(resultsFile, 'results');
    end
end

disp('Benchmark completed and saved safely to benchmark_results.mat');

%% 5. Print Final Summary Table
for t = 1:numel(trajectories)
    trajectory = trajectories{t};
    if ~isfield(results, trajectory) || isempty(fieldnames(results.(trajectory)))
        continue;
    end
    fprintf('\n\n==================== BENCHMARK RESULTS: %s ====================\n', upper(trajectory));
    fprintf('%-10s | %-10s | %-10s | %-10s | %-10s | %-9s | %-9s | %-8s | %-10s\n', ...
        'Filter', 'Tot RMSE', 'Pos(m)', 'Vel(m/s)', 'Att(deg)', 'Mean NEES', 'Mean NIS', 'Time(s)', 'Step(us)');
    fprintf('-------------------------------------------------------------------------------------------------------\n');
    
    fields = fieldnames(results.(trajectory));
    for i = 1:numel(fields)
        fName = fields{i};
        res = results.(trajectory).(fName);
        nees_str = 'N/A'; nis_str = 'N/A';
        if isfield(res, 'nees_mean_total'), nees_str = sprintf('%9.2f', res.nees_mean_total); end
        if isfield(res, 'nis_mean'), nis_str = sprintf('%9.2f', res.nis_mean); end
        
        fprintf('%-10s | %10.4f | %10.4f | %10.4f | %10.4f | %s | %s | %8.3f | %10.2f\n', ...
            fName, res.rmse_total, res.pos_rmse_3d, res.vel_rmse_3d, res.att_rmse_3d, ...
            nees_str, nis_str, res.execTime, res.perStepTime * 1e6);
    end
    fprintf('=======================================================================================================\n');
end

% Clean up temporary selection variables from workspace so subsequent runs prompt cleanly
clear traj_choice filt_choice plot_choice is_interactive;

function out = ternary_str(cond, strTrue, strFalse)
    if cond
        out = strTrue;
    else
        out = strFalse;
    end
end
