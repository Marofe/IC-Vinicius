function eul = Euler_Deg_From_Rotm(C, varargin) %#codegen
% EULER_DEG_FROM_ROTM Extracts Euler angles [roll, pitch, yaw] (deg) from rotation matrix C.
N = size(C, 3);
eul = zeros(N, 3);
if nargin == 1
    seq = 'ZYX';
else
    seq = varargin{end};
end
for i = 1:N
    C0 = C(:, :, i);
    switch seq
        case 'ZYX'
            roll  = atan2(C0(2, 3), C0(3, 3));
            pitch = -asin(C0(1, 3));
            yaw   = atan2(C0(1, 2), C0(1, 1));
            eul(i, :) = rad2deg([roll, pitch, yaw]);
        case 'ZXY'
            roll  = -atan2(C0(1, 3), C0(3, 3));
            pitch = asin(C0(2, 3));
            yaw   = atan2(C0(2, 1), C0(2, 2));
            eul(i, :) = rad2deg([yaw, pitch, roll]);
    end
end
end
