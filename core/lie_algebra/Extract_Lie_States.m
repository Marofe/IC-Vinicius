function [pos, vel, ori, acc_bias, gyro_bias] = Extract_Lie_States(hx)
% EXTRACT_LIE_STATES Extracts physical kinematic and sensor bias states
% from the SE_2(3) x R^6 homogeneous matrix state representation.
% Eliminates repeated squeeze indexing across runners, plots, and metrics.
%
% Inputs:
%   hx - 13x13 state matrix OR 13x13xN trajectory tensor
%
% Outputs:
%   pos       - 3xN position in ECEF frame (m)
%   vel       - 3xN velocity in ECEF frame (m/s)
%   ori       - 3x3xN DCM rotation matrix C_eb (Body to ECEF)
%   acc_bias  - 3xN accelerometer bias estimates (m/s^2)
%   gyro_bias - 3xN gyroscope bias estimates (rad/s)
%
% If called with 1 output argument (or 0), returns a struct:
%   s.pos, s.vel, s.ori, s.acc_bias, s.gyro_bias

if ndims(hx) == 2 || size(hx, 3) == 1
    pos       = hx(1:3, 5);
    vel       = hx(1:3, 4);
    ori       = hx(1:3, 1:3);
    acc_bias  = hx(6:8, 9);
    gyro_bias = hx(10:12, 13);
else
    pos       = squeeze(hx(1:3, 5, :));
    vel       = squeeze(hx(1:3, 4, :));
    ori       = hx(1:3, 1:3, :);
    acc_bias  = squeeze(hx(6:8, 9, :));
    gyro_bias = squeeze(hx(10:12, 13, :));
end

if nargout <= 1
    s.pos       = pos;
    s.vel       = vel;
    s.ori       = ori;
    s.acc_bias  = acc_bias;
    s.gyro_bias = gyro_bias;
    pos = s;
end
end
