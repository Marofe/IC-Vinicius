function euler=eulerECEF2NED(euler,Cen)
% EULERECEF2NED - Convert Euler angles from ECEF/ENU convention to NED
% 
% Input arguments:
% euler - Nx3 Euler angles (degrees) in ENU/ZYX convention
% Cen   - 3x3 rotation matrix from ECEF to navigation frame
Cned=[0 1 0;1 0 0;0 0 -1]; %NED<->ENU
% Loop over each Euler triplet and convert via rotation matrices
for k=1:size(euler,1)
    % Flip ordering to match expected rotation input, apply ZYX rot, then
    % transform by Cen and extract Euler angles back in degrees
    euler(k,:)=eulerdFromRotm(Cen'*rotm(flip(euler(k,:)),'ZYX')');
end
end