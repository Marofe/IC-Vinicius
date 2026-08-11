close all
clear all
clc
%% add library
addLibrary('inslib')
%% load dataset
trajectory='rectangular'
%trajectory='circular'
%trajectory='helicoidal'
load(['data/' trajectory '/data_sim_' trajectory '_bias.mat']);
%% get dataset size
p=15; %dimensão do grupo de Lie do Processo X = [x1 x2 ... x15]^
q=3; %dimensão do grupo de Lie da Medida   Y = [y1 y2 y2]^
r=15;
L=2*p+q;
N=size(time,1); %IMU size
M=size(gps_time,1); %GNSS size
n=13; %dimensão da matriz de estado
%% allocate memory
P=zeros(p,p,N);  %covariance matrix (15x15)
trP=zeros(1,N);  %trace of P
hx=zeros(n,n,N); % SE_2(3) (5X5) blkdiag([Ceb veb peb;0(2x3) eye(2)],[I(6) b;0(6,1) 1])
euler=zeros(3,N);%final euler angle (NED frame)
%% allocate memory Eta =[Eps Q R]
% G=zeros(n,n,2*L+1,N-1);  % feito para levar o sigPoint predição para correção 
% R=zeros(3,2*L+1,N-1);  % feito para levar o sigPoint predição para correção   
%% Noise statistics
Na=1e-9*ones(3,1); %white noise for the accelerometer
Nv=1e-3*ones(3,1); %white noise for the velocity
Ng=1e-6*ones(3,1); %white noise for the gyroscope
ba=1e-9*ones(3,1); %white noise for the acc bias (bias instability)
bg=1e-9*ones(3,1); %white noise for the gyr bias (bias instability)
sigmaGnss=1e-2*ones(3,1); %GNSS precision
%% Filter Covariances
Pqq=blkdiag(diag(Ng.^2),diag(Na.^2),diag(Nv.^2),diag(ba.^2),diag(bg.^2)); %process covariance (model and IMU precision)
Prr=diag(sigmaGnss.^2); % measurement covariance (GNSS precision)
%% UT parameters
beta=2; %gaussiano
kappa=0; %kurtosi
%% input (IMU)
u=[fib wib]'; %u is 6x1 vector with fib=accel=(ax,ay,az) and wib=gyro=(gx,gy,gz)
%% measurement (GNSS)
y=gps_pe';
leverarm=[0.040;-0.139;-0.439];
%% initial condition for the Kalman Filter
v0=[0;0;0];%condição inicial da velocidade
p0=gps_pe(1,:)'; %condição inicial da posição

lla0=SingleLlaFromEcef(p0); %local ref position (lat,lon,alt)
Cen=DCM_en(lla0(1),lla0(2)); %from NED to ECEF
gn=gravityModel(lla0(1));

% atit_0=zeros(3,1);
% Ceb_0=rotmd(atit_0)'; %condição inicial da matriz de rotação

euler0=eulerFromRotm(Cen','ZYX')'; %Cbe
Ceb_0=rotm(flip(euler0),'ZYX')';

%condição inicial dos bias
ba0=zeros(3,1);
bg0=zeros(3,1);

% estado inicial
hx(:,:,1)=blkdiag([Ceb_0 v0 p0;zeros(2,3) eye(2)],[eye(3) ba0;zeros(1,3) 1],[eye(3) bg0;zeros(1,3) 1]); %hx ==>SE_2(3)xT(6)
P(:,:,1)=diag([1e-6,1e-6,1e-6,...%roll/pitch/yaw
    1e-9,1e-9,1e-9,... %ve1/ve2/ve3
    1e-6,1e-6,1e-6,... %xe/ye/ze
    1e-6,1e-6,1e-6,... %ba1/ba2/ba3
    1e-9,1e-9,1e-9     %bg1/bg2/bg3
    ]);
%% processing
euler(:,1)=eulerdFromRotm(Cen'*hx(1:3,1:3,1),'ZYX');
% alpha_range=linspace(1e-4,5e-2,10);
% rmse=zeros(numel(alpha_range),1);
% parfor j=1:numel(alpha_range)
%     alpha=alpha_range(j)
%     rmse(j) = run_UKF_Lie(N,time,gps_time,hx,trP,P,Pqq,Prr,u,alpha,beta,kappa,L,Cen,y,leverarm,M,euler,ref);
% end
% [~,opt_j]=min(rmse);
%opt_j=4;
%alpha_opt=alpha_range(opt_j)
alpha_opt=0.0140

% Re-compiles run_UKF_Lie_mex if missing or if run_UKF_Lie.m was modified
sourceFile = which('run_UKF_Lie.m');
mexFile = which(['run_UKF_Lie_mex', '.', mexext]);

needsRebuild = false;

if isempty(mexFile)
    disp('MEX binary not found. Generating MEX...');
    needsRebuild = true;
else
    sourceInfo = dir(sourceFile);
    mexInfo = dir(mexFile);
    if sourceInfo.datenum > mexInfo.datenum
        disp('run_UKF_Lie.m modified since last build. Rebuilding MEX...');
        needsRebuild = true;
    end
end

if needsRebuild
    build_mex;
end

[rmse_opt,hx,trP,euler] = run_UKF_Lie_mex(N,time,gps_time,hx,trP,P,Pqq,Prr,u,alpha_opt,beta,kappa,L,Cen,y,leverarm,M,euler,ref);
%% plot
figure
plot(trP)
%ylim([0,max(trP(end-1000:end))*2])
title('Trace of P')
%% position ECEF
plotPositionECEF(squeeze(hx(1:3,5,:)),y,ref)
%% position NED & height profile
plotPositionNED(squeeze(hx(1:3,5,:)),y,ref,time,gps_time,leverarm,euler)
%% euler angles (NED frame)
plotEuler(euler,ref,time)
%%
figure
plot(time,squeeze(hx(6:8,9,:)))
hold on
line([time(1) time(end)],[ref.ba(1) ref.ba(1)],'LineStyle','--',Color='black')
line([time(1) time(end)],[ref.ba(2) ref.ba(2)],'LineStyle','--',Color='black')
line([time(1) time(end)],[ref.ba(3) ref.ba(3)],'LineStyle','--',Color='black')
grid on
title('Acc bias')
figure
plot(time,squeeze(hx(10:12,13,:)))
hold on
line([time(1) time(end)],[ref.bg(1) ref.bg(1)],'LineStyle','--',Color='black')
line([time(1) time(end)],[ref.bg(2) ref.bg(2)],'LineStyle','--',Color='black')
line([time(1) time(end)],[ref.bg(3) ref.bg(3)],'LineStyle','--',Color='black')
title('Gyro bias')
grid on
%% RMSE
[rmse_,rmse_ang,rmse_pos,rmse_vel]=evaluateStateRMSE(euler,squeeze(hx(1:3,5,:)),squeeze(hx(1:3,4,:)),ref,Cen)
%% save
hx_ukf_lie = hx;
save(['Workspaces/sol_ukf_lie_' trajectory '.mat'], 'hx_ukf_lie');
save(['Workspaces/ukf_full_' trajectory '_workspace.mat']);