function euler = Euler_ENU_To_NED(euler) %#codegen
% EULER_ENU_TO_NED Convert Euler angles from ENU (ZXY, deg) to NED (ZYX, deg) convention.
% Vectorized across all N rows.
yaw   = -euler(:, 1);
pitch =  euler(:, 2);
roll  =  euler(:, 3);

cr = cosd(roll);  sr = sind(roll);
cp = cosd(pitch); sp = sind(pitch);
cy = cosd(yaw);   sy = sind(yaw);

% Relevant elements of C = Rotm_Euler_Deg(euler, 'ZXY')
C12 = cr .* sy + sr .* sp .* cy;
C22 = cp .* cy;
C31 = sr .* cy + cr .* sp .* sy;
C32 = sr .* sy - cr .* sp .* cy;
C33 = cr .* cp;

% C0 = (Cned * C * Cned)' where Cned = [0 1 0; 1 0 0; 0 0 -1]
roll_ned  = rad2deg(atan2(-C31, C33));
pitch_ned = rad2deg(asin(C32));
yaw_ned   = rad2deg(atan2(C12, C22));

euler = [roll_ned, pitch_ned, yaw_ned];
end
