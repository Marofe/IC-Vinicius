% Build_EKF_Lie_MEX  MEX build script for Run_EKF_Lie
% Compiles Run_EKF_Lie.m (14 inputs, 3 outputs) into build/mex/run_EKF_Lie_mex
% using MATLAB Coder with variable-size array support.

clear functions; % Release compiled MEX from memory before rebuilding
rootDir = Setup_Paths(); % Ensure all project directories are on the MATLAB path

% -------------------------------------------------------------------------
% 1. Coder Configuration
% -------------------------------------------------------------------------
cfg = coder.config('mex');
cfg.GenerateReport = true;
cfg.IntegrityChecks = true;
cfg.GlobalDataSyncMethod = 'SyncAlways';

% -------------------------------------------------------------------------
% 2. Argument Types (coder.typeof)
% -------------------------------------------------------------------------
t_double   = coder.typeof(0);
t_time     = coder.typeof(0, [Inf, 1], [true, false]); % N x 1
t_gps_time = coder.typeof(0, [Inf, 1], [true, false]); % M x 1
t_trP      = coder.typeof(0, [1, Inf], [false, true]); % 1 x N
t_u        = coder.typeof(0, [6, Inf], [false, true]); % 6 x N
t_y        = coder.typeof(0, [3, Inf], [false, true]); % 3 x M
t_euler    = coder.typeof(0, [3, Inf], [false, true]); % 3 x N
t_Pqq      = coder.typeof(0, [15, 15]);
t_Prr      = coder.typeof(0, [3, 3]);
t_Cen      = coder.typeof(0, [3, 3]);
t_leverarm = coder.typeof(0, [3, 1]);
t_hx       = coder.typeof(0, [13, 13, Inf], [false, false, true]); % 13 x 13 x N
t_P        = coder.typeof(0, [15, 15, Inf], [false, false, true]); % 15 x 15 (or 15 x 15 x N)

% -------------------------------------------------------------------------
% 3. Input Arguments (14 args, matches Run_EKF_Lie signature)
% -------------------------------------------------------------------------
args = { ...
    t_double,   ... % 1.  N
    t_time,     ... % 2.  time
    t_gps_time, ... % 3.  gps_time
    t_hx,       ... % 4.  hx
    t_trP,      ... % 5.  trP
    t_P,        ... % 6.  P
    t_Pqq,      ... % 7.  Pqq
    t_Prr,      ... % 8.  Prr
    t_u,        ... % 9.  u
    t_Cen,      ... % 10. Cen
    t_y,        ... % 11. y
    t_leverarm, ... % 12. leverarm
    t_double,   ... % 13. M
    t_euler     ... % 14. euler
};

% -------------------------------------------------------------------------
% 4. Code Generation
% -------------------------------------------------------------------------
disp('Compiling Run_EKF_Lie to MEX (Variable Length Support)...');
mexOutDir = fullfile(rootDir, 'build', 'mex');
if ~exist(mexOutDir, 'dir')
    mkdir(mexOutDir);
end
addpath(mexOutDir);
outMex = fullfile(mexOutDir, 'run_EKF_Lie_mex');
codegenDir = fullfile(rootDir, 'codegen', 'mex', 'run_EKF_Lie_mex');
codegen('-config', cfg, 'Run_EKF_Lie', '-args', args, '-o', outMex, '-d', codegenDir);
disp('MEX compilation completed!');
