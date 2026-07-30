function plotHeight(hx,gnss,ref,time,gps_time)
p0=gnss(:,1);
lla0=SingleLlaFromEcef(p0); %local ref position (lat,lon,alt)
wgs84 = wgs84Ellipsoid('meter');
[xn,ye,zd] = ecef2ned(ref.pe(:,1),ref.pe(:,2),ref.pe(:,3),lla0(1),lla0(2),lla0(3),wgs84);
[n,e,d] = ecef2ned(hx(7,:),hx(8,:),hx(9,:),lla0(1),lla0(2),lla0(3),wgs84);
[gps_n,gps_e,gps_d] = ecef2ned(gnss(1,:),gnss(2,:),gnss(3,:),lla0(1),lla0(2),lla0(3),wgs84);
figure
plot(time,-zd,'.','linewidth',2,DisplayName='Ground-truth')
hold on
plot(time,-d,'.','linewidth',2,DisplayName='EULER-KF')
plot(gps_time,-gps_d,'ro','linewidth',2,DisplayName='GNSS')
legend
grid on
title('Height Profile')
xlabel('time (GPST)')
ylabel('Height (m)')
end