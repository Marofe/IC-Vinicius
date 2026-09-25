function [omeg, gn, Cen] = Omega_SE23T6(X, u) %#codegen
% OMEGA_SE23T6 Continuous-time Lie algebra velocity vector on se_2(3) x R^6 (15x1).
% X = blkdiag([Ceb veb peb; 0(2x3) eye(2)], [I(3) ba; 0(1,3) 1], [I(3) bg; 0(1,3) 1])

Cbe = X(1:3, 1:3)'; % Cbe = Ceb'
v0  = X(1:3, 4);
p0  = X(1:3, 5);
ba  = X(6:8, 9);
bg  = X(10:12, 13);

lla0 = Single_LLA_From_ECEF(p0);
Cen  = DCM_ECEF_To_NED(lla0(1), lla0(2));
gn   = Gravity_WGS84(lla0(1));

fib = u(1:3) * gn;
wib = u(4:6);
ge  = Cen * [0; 0; gn];

f1    = wib - bg;
f2    = (fib - ba) + Cbe * ge;
f3    = Cbe * v0;
fbias = zeros(6, 1);
omeg  = [f1; f2; f3; fbias];
end
