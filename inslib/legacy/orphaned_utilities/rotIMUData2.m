function imu = rotIMUData2(imu,bCimu,imuCalib)
%apply rotation from
%imu = time/acx/acy/acz/gx/gy/gz
%input: 
% -> imu data
% -> imuAngles: rotZ,rotY,rotX (seq ZYX)
%% Rotation
rotCalib=rotmd(imuCalib,'ZYX');
bCimu=rotCalib*bCimu;
imu(:,2:7)=imu(:,2:7)*blkdiag(bCimu',bCimu'*pi/180);
end

