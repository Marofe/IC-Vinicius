function [rmse, angles, pos, vel] = Evaluate_State_RMSE(euler, pe, ve, ref, varargin)
% EVALUATE_STATE_RMSE Compute RMSE for attitude, position, and velocity.
%
% Inputs:
%   euler    - Estimated Euler angles [roll; pitch; yaw] in NED frame (deg, 3xN)
%   pe       - Estimated ECEF position [px; py; pz] (m, 3xN)
%   ve       - Estimated ECEF velocity [vx; vy; vz] (m/s, 3xN)
%   ref      - Reference structure with fields: euler (ENU, deg), pe (m), ve (m/s)
%   varargin - Optional legacy 5th argument (Cen), ignored
%
% Outputs:
%   rmse   - Combined scalar RMSE across angles, position, and velocity
%   angles - RMSE per Euler angle [roll, pitch, yaw] (deg, 1x3)
%   pos    - RMSE per position axis [x, y, z] (m, 1x3)
%   vel    - RMSE per velocity axis [vx, vy, vz] (m/s, 1x3)

eulerRef = Euler_ENU_To_NED(ref.euler); % NED frame (Nx3)

% Per-angle RMSE between reference and estimated Euler angles in [-180, 180)
att_err = mod(eulerRef - euler' + 180, 360) - 180;
pos_err = ref.pe - pe';
vel_err = ref.ve - ve';

angles = sqrt(mean(att_err.^2));
pos    = sqrt(mean(pos_err.^2));
vel    = sqrt(mean(vel_err.^2));

% Combined RMSE over all concatenated error components (preserved per user spec)
rmse = sqrt(sum(mean([att_err, pos_err, vel_err].^2)));
end
