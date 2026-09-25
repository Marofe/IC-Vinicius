function [hx, P] = Update_EKF_Lie(hx0, P0, R, y, lb) %#codegen
% UPDATE_EKF_LIE Measurement update for EKF on Lie Groups.
H   = Matrix_H_SE23T6(hx0, lb);
K   = P0 * H' / (R + H * P0 * H');
Ceb = hx0(1:3, 1:3);
v   = K * (y - (hx0(1:3, 5) + Ceb * lb));

hx  = hx0 * Exp_Multi_SE23T6(v);
Phi = Phi_SE23T6(v);
P   = Phi * (eye(15) - K * H) * P0 * Phi';
P   = 0.5 * (P + P');
end