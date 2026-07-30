function plotPositionNED(pe,gnss,ref,time,gps_time,lb,euler)
% PLOTPOSITIONNED - Plot positions in local NED frame and height profiles
%
% Input arguments:
% pe       - estimated ECEF positions (3 x N)
% gnss     - GNSS ECEF positions (3 x N)
% ref      - reference struct with .pe (ECEF) for ground truth
%   - euler: roll,pitch,yaw in FRD->NED 
% time     - time vector for estimates/ground truth (GPST)
% gps_time - time vector for GNSS measurements (GPST)
p0=gnss(:,1);
lla0=SingleLlaFromEcef(p0); %local ref position (lat,lon,alt)
wgs84 = wgs84Ellipsoid('meter');
Cned=[0 1 0;1 0 0;0 0 -1];
%% compensate leverarm for the solution
N=numel(time);
for k=1:N
    Cnb=rotmd(flip(euler(:,k)),'ZYX')'; %FRD->NED
    lla=SingleLlaFromEcef(pe(:,k));
    Cen=DCM_en(lla(1),lla(2));
    pe(:,k)=pe(:,k)+Cen*Cnb*lb; %ECEF-frame
end
%% compensate leverarm for the ground-truth
N=numel(ref.time);
ref_euler=eulerdENU2NED(ref.euler);
for k=1:N
    Cnb=rotmd(ref_euler(k,:),'ZYX')'; %FRD->NED
    lla=SingleLlaFromEcef(ref.pe(k,:));
    Cen=DCM_en(lla(1),lla(2));
    ref.pe(k,:)=ref.pe(k,:)+(Cen*Cnb*lb)'; %ECEF-frame
end
%%
[xn,ye,zd] = ecef2ned(ref.pe(:,1),ref.pe(:,2),ref.pe(:,3),lla0(1),lla0(2),lla0(3),wgs84);
[n,e,d] = ecef2ned(pe(1,:),pe(2,:),pe(3,:),lla0(1),lla0(2),lla0(3),wgs84);
[gps_n,gps_e,gps_d] = ecef2ned(gnss(1,:),gnss(2,:),gnss(3,:),lla0(1),lla0(2),lla0(3),wgs84);
%% plot 3D
figure
plot3(xn,ye,-zd,'.','linewidth',2,'DisplayName','Ground Truth')
hold on
plot3(n,e,-d,'.','linewidth',2,'DisplayName','EULER-KF')
plot3(gps_n,gps_e,-gps_d,'ro','linewidth',2,'DisplayName','GNSS')
grid on
title('Position in NED frame (3D)')
legend
xlabel('N')
ylabel('E')
zlabel('-D')
%% plot 2D
figure
plot(xn,ye,'.','linewidth',2,'DisplayName','Ground Truth')
hold on
plot(n,e,'.','linewidth',2,'DisplayName','EULER-KF')
plot(gps_n,gps_e,'ro','linewidth',2,'DisplayName','GNSS')
grid on
title('Position in NED frame (2D)')
legend
xlabel('N')
ylabel('E')
%%
figure
% Plot vertical (down) coordinate over time for comparison
plot(ref.time,-zd,'.','linewidth',2,DisplayName='Ground-truth')
hold on
plot(time,-d,'.','linewidth',2,DisplayName='EULER-KF')
plot(gps_time,-gps_d,'ro','linewidth',2,DisplayName='GNSS')
legend
title('Height Profile')
xlabel('time (GPST)')
ylabel('Height (m)')
grid on
end