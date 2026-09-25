function C = Rotm_From_Euler_Deg(eul, varargin) %#codegen
% ROTM_FROM_EULER_DEG Convert Euler angles [roll, pitch, yaw] in degrees to rotation matrix.
% Inverse of Euler_Deg_From_Rotm.
%
% Inputs:
%   eul - 1x3 or Nx3 Euler angles [roll, pitch, yaw] in degrees
%   seq - 'ZYX' (default) or 'ZXY'
%
% Output:
%   C - 3x3 (or 3x3xN) direction cosine / rotation matrix

if nargin == 1
    seq = 'ZYX';
else
    seq = varargin{end};
end

N = size(eul, 1);
C = zeros(3, 3, N);

for i = 1:N
    euli = eul(i, :);
    switch seq
        case 'ZYX'
            % Rotm_Euler_Deg expects [yaw, pitch, roll] for ZYX
            C(:, :, i) = Rotm_Euler_Deg(flip(euli), 'ZYX');
        case 'ZXY'
            C(:, :, i) = Rotm_Euler_Deg(euli, 'ZXY');
    end
end
end
