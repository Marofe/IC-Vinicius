function [rmse,angles,pos,vel]=evaluateStateRMSE(euler,pe,ve,ref,Cen)
% EVALUATESTATERMSE - Compute RMSE for attitude, position, and velocity
%
% Inputs:
% hx  - state vector(s) [roll,pitch,yaw,vx,vy,vz,px,py,pz] (9xN) in NED frame
% ref - reference structure with fields: euler (ENU), pe (position), ve (velocity)
% Cen - geodetic center needed for ECEF->NED conversion
% Outputs:
% rmse   - combined RMSE across angles, position, and velocity
% angles - RMSE per Euler angle
% pos    - RMSE for position (3D)
% vel    - RMSE for velocity (3D)

%hx=[roll,pitch,yaw,vx,vy,vz,px,py,pz] (9x1) NED-frame
eulerRef=eulerENU2NED(ref.euler); %NED frame
% Per-angle RMSE between reference and estimated Euler angles
% Wrap using modulo arithmetic
%wrapped_error = mod(raw_error + pi, 2*pi) - pi;
angles=sqrt(mean((mod(eulerRef-euler'+pi,2*pi)-pi).^2));
% Position RMSE (3 components)
pos=sqrt(mean((ref.pe-pe').^2));
% Velocity RMSE (3 components)
vel = sqrt(mean((ref.ve-ve').^2));
% Combined RMSE over all concatenated error components
rmse = sqrt(sum(mean([(mod(eulerRef-euler'+pi,2*pi)-pi) ref.pe-pe' ref.ve-ve'].^2)));
end