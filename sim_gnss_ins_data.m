close all
clear all
clc
%%
rng(123)
load('data/rectangular/rectangular.mat');
time=ref.time;
dt=mean(diff(time));
Fs=floor(1/dt);
%%
sigmaR=1e-2; %precisao do gps;
sigmaW=1e-6; %precisao do giroscopio;
sigmaA=1e-9; %precisa do acelerometro;
%% simula GNSS+leverarm
p0=ref.pe(1,:);
lla0=SingleLlaFromEcef(p0); %local ref position (lat,lon,alt)
Cen=DCM_en(lla0(1),lla0(2)); %from NED to ECEF
leverarm=[0.040;-0.139;-0.439];
euler=ref.euler(1:Fs:end,:); %ENU<->RFU
euler=eulerdENU2NED(euler); %NED<->FRD
gps_time=ref.time(1:Fs:end);
gps_pe=ref.pe(1:Fs:end,:);
for k=1:size(euler,1)
    Cbn=rotmd(euler(k,:),'ZYX');
    gps_pe(k,:)=gps_pe(k,:)+(Cen*Cbn'*leverarm)';
end
%% simulando ruido+bias
ba=1e-6*randn(3,1);
bg=1e-6*randn(3,1);
gps_pe=gps_pe+sigmaR*randn(size(gps_pe));
wib=ref.wib+sigmaW*randn(size(ref.wib))+bg';
fib=ref.fib+sigmaA*randn(size(ref.fib))+ba';
ref.ba=ba;
ref.bg=bg;
ref.leverarm=leverarm;
%% save
save data_sim_rectangular_bias fib wib gps_pe gps_time time Fs ref
%% vetor de estados
%x=[roll pitch yaw vx vy vz px py pz]' 9x1
