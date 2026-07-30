function imu = rotIMUData(imu,imuAngles,imuCalib)
%apply rotation from
%imu = time/acx/acy/acz/gx/gy/gz
%input: 
% -> imu data
% -> imuAngles: rotZ,rotY,rotX (seq ZYX)
%% Rotation
rotCalib=expSO3(deg2rad(imuCalib'));
bCimu=rotmd(imuAngles,'ZYX');
bCimu=bCimu*rotCalib;
imu(:,2:7)=imu(:,2:7)*blkdiag(bCimu',bCimu'*pi/180);
end

