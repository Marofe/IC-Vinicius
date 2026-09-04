% Variable-dimension build script for run_EKF_Lie MEX compilation

clear functions; % Release compiled MEX from memory before rebuilding

% -------------------------------------------------------------------------
% 1. Load sample dataset to infer structure fields for 'ref'
% -------------------------------------------------------------------------



% -------------------------------------------------------------------------
% 2. Define Coder configuration options
% -------------------------------------------------------------------------
cfg = coder.config('mex');
cfg.GenerateReport = true;
cfg.IntegrityChecks = true;
cfg.GlobalDataSyncMethod = 'SyncAlways';

% -------------------------------------------------------------------------
% 3. Define Argument Types (coder.typeof)
% -------------------------------------------------------------------------

t_double = coder.typeof(0); 
t_time     = coder.typeof(0, [Inf, 1], [true, false]); 
t_gps_time = coder.typeof(0, [Inf, 1], [true, false]); 
t_trP   = coder.typeof(0, [1, Inf], [false, true]); 
t_u     = coder.typeof(0, [6, Inf], [false, true]); 
t_y     = coder.typeof(0, [3, Inf], [false, true]); 
t_euler = coder.typeof(0, [3, Inf], [false, true]); 
t_Pqq      = coder.typeof(0, [15, 15]);
t_Prr      = coder.typeof(0, [3, 3]);
t_Cen      = coder.typeof(0, [3, 3]);
t_leverarm = coder.typeof(0, [3, 1]);
t_hx = coder.typeof(0, [13, 13, Inf], [false, false, true]); 
t_P  = coder.typeof(0, [15, 15, Inf], [false, false, true]); 


args = { t_double, t_time, t_gps_time, t_hx, t_trP, t_P, t_Pqq, t_Prr, t_u, t_Cen, t_y, t_leverarm, t_double, t_euler }

% -------------------------------------------------------------------------
% 5. Execute Code Generation
% -------------------------------------------------------------------------
disp('Compiling run_EKF_Lie to MEX (Variable Length Support)...');
codegen -config cfg run_EKF_Lie -args args;
disp('MEX compilation completed!');
