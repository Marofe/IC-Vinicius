function [hx, P] = Prediction_EKF_Lie(hx0, P0, u, Q, dt) %#codegen
% PREDICTION_EKF_LIE State and covariance propagation for EKF on Lie Groups.
[omeg, gn, Cen] = Omega_SE23T6(hx0, u);
omegk = omeg * dt;
hx = hx0 * Exp_Multi_SE23T6(omegk);

Phi = Phi_SE23T6(omegk);
C   = Matrix_C_SE23T6(hx, u, gn, Cen, dt);
F   = Ad_G(Exp_Multi_SE23T6(-omegk)) + Phi * C;
Qk  = Q;
P   = F * P0 * F' + Phi * Qk * Phi';
P   = (P + P') / 2;
end