function fi = Phi_SE23T6(omega) %#codegen
% PHI_SE23T6 Right Jacobian series approximation on SE_2(3) x R^6 (15x15).
% Truncated series Phi(omega) = sum_{m=0}^{10} (-1)^m / (m+1)! * ad(omega)^m, i.e. the
% right Jacobian J_r(omega): Exp(omega + delta) ~= Exp(omega) * Exp(Phi(omega) * delta)
% to first order in delta. Matches Phi in G. Bourmaud, R. Megret, A. Giremus,
% Y. Berthoumieu, "Discrete Extended Kalman Filter on Lie Groups" (EUSIPCO 2013).
ad_a = Adj_G(omega);
fi   = zeros(size(ad_a));

for m = 0:10
    x  = (((-1)^m) / factorial(m + 1)) * (ad_a^m);
    fi = fi + x;
end
end
