% build_hybrid_mex.m
% Variable-dimension build script for run_hybrid_EKF_UKF_Lie MEX compilation

clear functions; % Release compiled MEX from memory before rebuilding

% -------------------------------------------------------------------------
% 1. Load sample dataset to infer structure fields for 'ref'
% -------------------------------------------------------------------------
sampleData = load(fullfile('data', 'rectangular', 'data_sim_rectangular_bias.mat'));
refSample = sampleData.ref;

% -------------------------------------------------------------------------
% 2. Define Coder configuration options
% -------------------------------------------------------------------------
cfg = coder.config('mex');
cfg.GenerateReport = true;
cfg.IntegrityChecks = true;
cfg.GlobalDataSyncMethod = 'SyncAlways';

% -------------------------------------------------------------------------
% 3. Define Argument Types (coder.typeof)
% coder.typeof(Type, [Dimensions], [VariableDimsMask])
% -------------------------------------------------------------------------

% Scalars (Fixed doubles)
t_double = coder.typeof(0); 

% 1D time vectors (Variable length N or M along dimension 1)
t_time     = coder.typeof(0, [Inf, 1], [true, false]); % N x 1
t_gps_time = coder.typeof(0, [Inf, 1], [true, false]); % M x 1

% 2D time-series vectors (Variable length N or M along dimension 2)
t_trP   = coder.typeof(0, [1, Inf], [false, true]); % 1 x N
t_u     = coder.typeof(0, [6, Inf], [false, true]); % 6 x N
t_y     = coder.typeof(0, [3, Inf], [false, true]); % 3 x M
t_euler = coder.typeof(0, [3, Inf], [false, true]); % 3 x N

% Fixed 2D matrices
t_Pqq      = coder.typeof(0, [15, 15]);
t_Prr      = coder.typeof(0, [3, 3]);
t_Cen      = coder.typeof(0, [3, 3]);
t_leverarm = coder.typeof(0, [3, 1]);

% 3D Tensors (Fixed state/cov dimensions, variable time step dimension N)
t_hx = coder.typeof(0, [13, 13, Inf], [false, false, true]); % 13 x 13 x N
t_P  = coder.typeof(0, [15, 15, Inf], [false, false, true]); % 15 x 15 x N

% Ground-truth Struct ('ref')
% Typeof automatically inherits structure fields; mark fields variable if needed
t_ref = coder.typeof(refSample);

% -------------------------------------------------------------------------
% 4. Assemble Positional Input Arguments Cell Array
% Matches: function [...] = run_UKF_Lie(N, time, gps_time, hx, trP, P, ...
%            Pqq, Prr, u, alpha, beta, kappa, L, Cen, y, leverarm, M, euler, ref)
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
    t_double,   ... % 10. alpha
    t_double,   ... % 11. beta
    t_double,   ... % 12. kappa
    t_double,   ... % 13. L
    t_Cen,      ... % 14. Cen
    t_y,        ... % 15. y
    t_leverarm, ... % 16. leverarm
    t_double,   ... % 17. M
    t_euler,    ... % 18. euler
    t_ref       ... % 19. ref
    };

% -------------------------------------------------------------------------
% 5. Execute Code Generation
% -------------------------------------------------------------------------
disp('Compiling run_hybrid_EKF_UKF_Lie to MEX (Variable Length Support)...');
codegen -config cfg run_hybrid_EKF_UKF_Lie -args args;
disp('MEX compilation completed!');