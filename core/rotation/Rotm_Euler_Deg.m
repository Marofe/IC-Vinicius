function C = Rotm_Euler_Deg(eul, varargin) %#codegen
% ROTM_EULER_DEG Direction cosine matrix from Euler angles [yaw, pitch, roll] in degrees.
if nargin == 1
    seq = 'ZYX';
else
    seq = varargin{end};
end
roll  = eul(3);
pitch = eul(2);
yaw   = eul(1);
C11 = 0; C12 = 0; C13 = 0;
C21 = 0; C22 = 0; C23 = 0;
C31 = 0; C32 = 0; C33 = 0;
switch seq
    case 'ZYX' % NED <-> FRD
        C11 = cosd(pitch)*cosd(yaw);
        C12 = cosd(pitch)*sind(yaw);
        C13 = -sind(pitch);
        C21 = -cosd(roll)*sind(yaw) + sind(roll)*sind(pitch)*cosd(yaw);
        C22 =  cosd(roll)*cosd(yaw) + sind(roll)*sind(pitch)*sind(yaw);
        C23 =  sind(roll)*cosd(pitch);
        C31 =  sind(roll)*sind(yaw) + cosd(roll)*sind(pitch)*cosd(yaw);
        C32 = -sind(roll)*cosd(yaw) + cosd(roll)*sind(pitch)*sind(yaw);
        C33 =  cosd(roll)*cosd(pitch);
    case 'ZXY' % ENU <-> RFU
        yaw = -yaw; % positive clockwise heading
        C11 =  cosd(roll)*cosd(yaw) - sind(roll)*sind(pitch)*sind(yaw);
        C12 =  cosd(roll)*sind(yaw) + sind(roll)*sind(pitch)*cosd(yaw);
        C13 = -sind(roll)*cosd(pitch);
        C21 = -cosd(pitch)*sind(yaw);
        C22 =  cosd(pitch)*cosd(yaw);
        C23 =  sind(pitch);
        C31 =  sind(roll)*cosd(yaw) + cosd(roll)*sind(pitch)*sind(yaw);
        C32 =  sind(roll)*sind(yaw) - cosd(roll)*sind(pitch)*cosd(yaw);
        C33 =  cosd(roll)*cosd(pitch);
end
C = [C11, C12, C13; ...
     C21, C22, C23; ...
     C31, C32, C33];
end
