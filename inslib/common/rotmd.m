function C=rotmd(eul,varargin)
% input -> euler angle (yaw,pitch,roll) (deg)
% output -> Cbn (from navigation to body)
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
    case 'ZYX' %NED<->FRD
        C11=cosd(pitch)*cosd(yaw);
        C12=cosd(pitch)*sind(yaw);
        C13=-sind(pitch);
        C21=-cosd(roll)*sind(yaw)+sind(roll)*sind(pitch)*cosd(yaw);
        C22=cosd(roll)*cosd(yaw)+sind(roll)*sind(pitch)*sind(yaw);
        C23=sind(roll)*cosd(pitch);
        C31=sind(roll)*sind(yaw)+cosd(roll)*sind(pitch)*cosd(yaw);
        C32=-sind(roll)*cosd(yaw)+cosd(roll)*sind(pitch)*sind(yaw);
        C33=cosd(roll)*cosd(pitch);
    case 'ZXY' %ENU<->RFU
        yaw=-yaw; %consider positive clockwise heading
        C11=cosd(roll)*cosd(yaw)-sind(roll)*sind(pitch)*sind(yaw);
        C12=cosd(roll)*sind(yaw)+sind(roll)*sind(pitch)*cosd(yaw);
        C13=-sind(roll)*cosd(pitch);
        C21=-cosd(pitch)*sind(yaw);
        C22=cosd(pitch)*cosd(yaw);
        C23=sind(pitch);
        C31=sind(roll)*cosd(yaw)+cosd(roll)*sind(pitch)*sind(yaw);
        C32=sind(roll)*sind(yaw)-cosd(roll)*sind(pitch)*cosd(yaw);
        C33=cosd(roll)*cosd(pitch);
    case 'XYZ'
%         C11=cos(pitch)*cos(yaw);
%         C12=cos(pitch)*sin(yaw);
%         C13=-sin(pitch);
%         C21=-cos(roll)*sin(yaw)+sin(roll)*sin(pitch)*cos(yaw);
%         C22=cos(roll)*cos(yaw)+sin(roll)*sin(pitch)*sin(yaw);
%         C23=sin(roll)*cos(pitch);
%         C31=sin(roll)*sin(yaw)+cos(roll)*sin(pitch)*cos(yaw);
%         C32=-sin(roll)*cos(yaw)+cos(roll)*sin(pitch)*sin(yaw);
%         C33=cos(roll)*cos(pitch);
end
C=[C11 C12 C13;...
    C21 C22 C23;...
    C31 C32 C33];
end
