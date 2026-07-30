function w_en=nedRotation(L,h,vn)
% Compute the local frame (North-East-Down) angular velocity in rad/s wrt ECEF
% for a given latitude and altitude (L,h)
R0=6.378137e6;
e=0.0818191908425;
RN=R0*(1-e^2)/((1-e^2*sind(L)^2)^(3/2));
RE=R0/sqrt(1-e^2*sind(L)^2);
R=[0 1/(RE+h) 0;-1/(RN+h) 0 0;0 -tand(L)/(RE+h) 0];
w_en=R*vn; %rad/s
end