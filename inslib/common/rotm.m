function C=rotm(eul,varargin)
% input -> Psi_bn (yaw,pitch,roll)
% output -> Cnb (from body to navigation)
if nargin==1
    %default sequence
    seq='ZYX';
else
    seq=varargin{end};
end
roll=eul(3);
pitch=eul(2);
yaw=eul(1);
switch seq
    case 'ZYX'
        C11=cos(pitch)*cos(yaw);
        C12=cos(pitch)*sin(yaw);
        C13=-sin(pitch);
        C21=-cos(roll)*sin(yaw)+sin(roll)*sin(pitch)*cos(yaw);
        C22=cos(roll)*cos(yaw)+sin(roll)*sin(pitch)*sin(yaw);
        C23=sin(roll)*cos(pitch);
        C31=sin(roll)*sin(yaw)+cos(roll)*sin(pitch)*cos(yaw);
        C32=-sin(roll)*cos(yaw)+cos(roll)*sin(pitch)*sin(yaw);
        C33=cos(roll)*cos(pitch);
    case 'ZXY'
        yaw=-yaw; %consider positive clockwise heading
        C11=cos(roll)*cos(yaw)-sin(roll)*sin(pitch)*sin(yaw);
        C12=cos(roll)*sin(yaw)+sin(roll)*sin(pitch)*cos(yaw);
        C13=-sin(roll)*cos(pitch);
        C21=-cos(pitch)*sin(yaw);
        C22=cos(pitch)*cos(yaw);
        C23=sin(pitch);
        C31=sin(roll)*cos(yaw)+cos(roll)*sin(pitch)*sin(yaw);
        C32=sin(roll)*sin(yaw)-cos(roll)*sin(pitch)*cos(yaw);
        C33=cos(roll)*cos(pitch);
    case 'XYZ'
        C11=cos(pitch)*cos(yaw);
        C12=cos(pitch)*sin(yaw);
        C13=-sin(pitch);
        C21=-cos(roll)*sin(yaw)+sin(roll)*sin(pitch)*cos(yaw);
        C22=cos(roll)*cos(yaw)+sin(roll)*sin(pitch)*sin(yaw);
        C23=sin(roll)*cos(pitch);
        C31=sin(roll)*sin(yaw)+cos(roll)*sin(pitch)*cos(yaw);
        C32=-sin(roll)*cos(yaw)+cos(roll)*sin(pitch)*sin(yaw);
        C33=cos(roll)*cos(pitch);
end
C=[C11 C12 C13;...
    C21 C22 C23;...
    C31 C32 C33];
end
