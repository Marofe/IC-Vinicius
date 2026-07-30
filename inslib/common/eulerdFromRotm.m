function eul = eulerdFromRotm(C,varargin)
% input -> Cba (from a-frame to b-frame)
% return the euler angles [roll,pitch,yaw] (deg) from a given rotation matrix Cba=C(Psi_ab);
%  
N=size(C,3);
eul=zeros(N,3);
if nargin==1
    seq='ZYX';
else
    seq=varargin{end};
end
for i=1:N
    C0=C(:,:,i);
    switch seq
        case 'ZYX'
            roll=atan2(C0(2,3),C0(3,3));
            pitch=-asin(C0(1,3));
            yaw=atan2(C0(1,2),C0(1,1));
            eul(i,:)=rad2deg([roll pitch yaw]);
        case 'ZXY'
            roll=-atan2(C0(1,3),C0(3,3));
            pitch=asin(C0(2,3));
            yaw=atan2(C0(2,1),C0(2,2)); %heading positive clockwise
            eul(i,:)=rad2deg([yaw pitch roll]);
    end
end
end

