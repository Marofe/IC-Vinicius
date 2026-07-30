function euler=eulerdENU2NED(euler)
  % EULERENU2NED - Convert Euler angles from ENU to NED convention
  %
  % Input arguments:
  % euler - Nx3 array of Euler angles in degrees (ENU order: yaw, pitch, roll)
  %
  % Output arguments:
  % euler - Nx3 array of Euler angles in degrees (NED order: roll, pitch, yaw)
Cned=[0 1 0;1 0 0;0 0 -1]; %NED<->ENU
% Loop over each Euler triplet and convert via rotation matrices
for k=1:size(euler,1)
    C=rotmd(euler(k,:),'ZXY');
    euler(k,:)=eulerdFromRotm((Cned*C*Cned)','ZYX');
end
end