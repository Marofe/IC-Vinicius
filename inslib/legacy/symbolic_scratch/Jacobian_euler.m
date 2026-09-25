close all
clear all
clc

%% Symbolic Jacobian Matrix
syms x1 x2 x3 vx vy vz bw1 bw2 bw3 ba1 ba2 ba3 w1 w2 w3 a1 a2 a3 Ts theta phi psi real;
syms rx ry rz g0 beta lat lon alt alpha1 alpha2 y1 y2 y3 gamma real
syms c11 c12 c13 c21 c22 c23 c31 c32 c33 d1 d2 d3 delta1 delta2 delta3 q1 q2 q3 q4 real
wib=[w1; w2; w3];
fib=[a1; a2; a3];
u=[fib;wib];
larm=[rx; ry; rz];
p=[x1; x2; x3];
lla0=[lat lon alt];
v=[vx; vy; vz];
C=[c11 c12 c13;c21 c22 c23;c31 c32 c33];
eul=[phi theta psi]'; %roll pitch yaw (ECEF to BODY)
bw=[bw1; bw2; bw3];
ba=[ba1; ba2; ba3];
gn=[0;0;g0];
Cen=DCM_en(lat,lon);
Ceb=rotm(flip(eul),'ZYX')';
%% GNSS
y=p+Ceb*larm; %h(x)
H=jacobian(y,[eul;v;p;ba;bw])
%% Omega
dx=f([eul;v;p;ba;bw],u,g0,lla0);
%A=jacobian(dx,[eul;v;p;ba;bw])
%%
function x=f(x0,u,gn,lla)
fib=u(1:3)*gn;
wib=u(4:6);
ba=x0(10:12);
bg=x0(13:15);
Cen=DCM_en(lla(1),lla(2));
Ceb=rotm(flip(x0(1:3)),'ZYX')';
ge=Cen*[0;0;gn];
Gamma=1/cos(x0(2))*[cos(x0(2)) sin(x0(1))*sin(x0(2)) cos(x0(1))*sin(x0(2));...
    0 cos(x0(1))*cos(x0(2)) -sin(x0(1))*cos(x0(2));...
    0 sin(x0(1)) cos(x0(1))];
x=[Gamma*(wib-bg);... 
    Ceb*(fib-ba)+ge;
    x0(4:6);... veb
    zeros(6,1)];
end
