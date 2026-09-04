close all
clear all

%% add library
addLibrary('inslib')

%% load dataset
trajectory = 'rectangular';
%trajectory = 'circular';
%trajectory = 'helicoidal';
load(['data/' trajectory '/data_sim_' trajectory '_bias.mat']);

%% get dataset size
p = 15; % dimensão do grupo de Lie do Processo X = [x1 x2 ... x15]^
q = 3;  % dimensão do grupo de Lie da Medida   Y = [y1 y2 y3]^
r = 15;
L = 2*p + q;
N = size(time,1);     % IMU size
M = size(gps_time,1); % GNSS size
n = 13;               % dimensão da matriz de estado

%% allocate memory
P = zeros(p,p,N);  % covariance matrix (15x15)
trP = zeros(1,N);  % trace of P
hx = zeros(n,n,N); % SE_2(3) (5x5) blkdiag([Ceb veb peb;0(2x3) eye(2)],[I(6) b;0(6,1) 1])
euler = zeros(3,N);% final euler angle (NED frame)

%% Noise statistics
Na = 1e-9 * ones(3,1);       % white noise for the accelerometer
Nv = 1e-3 * ones(3,1);       % white noise for the velocity
Ng = 1e-6 * ones(3,1);       % white noise for the gyroscope
ba = 1e-9 * ones(3,1);       % white noise for the acc bias (bias instability)
bg = 1e-9 * ones(3,1);       % white noise for the gyr bias (bias instability)
sigmaGnss = 1e-2 * ones(3,1);% GNSS precision

%% Filter Covariances
Pqq = blkdiag(diag(Ng.^2), diag(Na.^2), diag(Nv.^2), diag(ba.^2), diag(bg.^2)); % process covariance
Prr = diag(sigmaGnss.^2); % measurement covariance

%% UT parameters
beta = 2;   % gaussiano
kappa = 0;  % kurtosi

%% input (IMU) & measurement (GNSS)
u = [fib wib]';
y = gps_pe';
leverarm = [0.040; -0.139; -0.439];

%% initial condition for the Kalman Filter
v0 = [0;0;0];
p0 = gps_pe(1,:)';
lla0 = SingleLlaFromEcef(p0);
Cen = DCM_en(lla0(1), lla0(2));
gn = gravityModel(lla0(1));

euler0 = eulerFromRotm(Cen', 'ZYX')';
Ceb_0 = rotm(flip(euler0), 'ZYX')';

ba0 = zeros(3,1);
bg0 = zeros(3,1);

hx(:,:,1) = blkdiag([Ceb_0 v0 p0; zeros(2,3) eye(2)], [eye(3) ba0; zeros(1,3) 1], [eye(3) bg0; zeros(1,3) 1]);
P(:,:,1) = diag([1e-6, 1e-6, 1e-6, 1e-9, 1e-9, 1e-9, 1e-6, 1e-6, 1e-6, 1e-6, 1e-6, 1e-6, 1e-9, 1e-9, 1e-9]);

%% Re-compiles run_IUKF_Lie_mex if missing or if run_IUKF_Lie.m was modified
sourceFile = which('run_IUKF_Lie.m');
mexFile = which(['run_IUKF_Lie_mex', '.', mexext]);
needsRebuild = false;

if isempty(mexFile)
    disp('MEX binary not found. Generating MEX...');
    needsRebuild = true;
else
    sourceInfo = dir(sourceFile);
    mexInfo = dir(mexFile);
    if sourceInfo.datenum > mexInfo.datenum
        disp('run_IUKF_Lie.m modified since last build. Rebuilding MEX...');
        needsRebuild = true;
    end
end

if needsRebuild
    build_IUKF_Lie_mex;
else    
    disp('MEX file is up-to-date and ready');
end

%% processing
euler(:,1) = eulerdFromRotm(Cen'*hx(1:3,1:3,1), 'ZYX');
alpha_opt = 0.0140;

% --- FILTER EXECUTION ---
profile clear;               % Clears timing data from previous runs
profile on -detail builtin;  % Starts tracking CPU time for the filter
tic;
% Use native 'run_IUKF_Lie' for line-by-line math breakdown
% Use mex version 'run_IUKF_Lie_mex' for total C execution time
[hx, trP, euler] = run_IUKF_Lie_mex(N, time, gps_time, hx, trP, P, Pqq, Prr, u, alpha_opt, beta, kappa, L, Cen, y, leverarm, M, euler);
profile off;                 % Stop tracking before plotting starts
profile viewer;              % Automatically open the profiler report window
optUkfTime = toc;

fprintf('IUKF_Lie MEX Execution Time: %.4f seconds\n', optUkfTime);

%% plot
figure
plot(trP)
title('Trace of P')

%% position ECEF
plotPositionECEF(squeeze(hx(1:3,5,:)), y, ref)

%% position NED & height profile
plotPositionNED(squeeze(hx(1:3,5,:)), y, ref, time, gps_time, leverarm, euler)

%% euler angles (NED frame)
plotEuler(euler, ref, time)

%% Biases
figure
plot(time, squeeze(hx(6:8,9,:)))
hold on
line([time(1) time(end)], [ref.ba(1) ref.ba(1)], 'LineStyle', '--', 'Color', 'black')
line([time(1) time(end)], [ref.ba(2) ref.ba(2)], 'LineStyle', '--', 'Color', 'black')
line([time(1) time(end)], [ref.ba(3) ref.ba(3)], 'LineStyle', '--', 'Color', 'black')
grid on
title('Acc bias')

figure
plot(time, squeeze(hx(10:12,13,:)))
hold on
line([time(1) time(end)], [ref.bg(1) ref.bg(1)], 'LineStyle', '--', 'Color', 'black')
line([time(1) time(end)], [ref.bg(2) ref.bg(2)], 'LineStyle', '--', 'Color', 'black')
line([time(1) time(end)], [ref.bg(3) ref.bg(3)], 'LineStyle', '--', 'Color', 'black')
title('Gyro bias')
grid on

%% RMSE
[rmse_, rmse_ang, rmse_pos, rmse_vel] = evaluateStateRMSE(euler, squeeze(hx(1:3,5,:)), squeeze(hx(1:3,4,:)), ref, Cen)

%% save
hx_IUKF_Lie = hx;
scriptFolder = fileparts(mfilename('fullpath')); 
targetFolder = fullfile(scriptFolder, 'Workspaces');

if ~exist(targetFolder, 'dir')
    mkdir(targetFolder);
end
save(['Workspaces/sol_IUKF_Lie_' trajectory '.mat'], 'hx_IUKF_Lie');
save(['Workspaces/full_IUKF_Lie_' trajectory '_workspace.mat']);
