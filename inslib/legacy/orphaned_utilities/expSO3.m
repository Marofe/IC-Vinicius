function C = expSO3(Phi)
%EXPSO3 Summary of this function goes here
%   Detailed explanation goes here
if size(Phi,1)~=3 && size(Phi,2)==3
    Phi=Phi';
end
phi=norm(Phi);
if phi>0
         a=Phi/phi;
     C=cos(phi)*eye(3)+(1-cos(phi))*a*a'+sin(phi)*cross2matrix(a);
%         X=cross2matrix(Phi);
%     C=eye(3) + ((sin(phi)/phi)+ ((1-cos(phi))/(phi^2))*X )*X;
else
    C=eye(3);
end
end

