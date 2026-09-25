function fi = Phi_SE23T6(omega) %#codegen
% PHI_SE23T6 Left Jacobian series approximation on SE_2(3) x R^6 (15x15).
ad_a = Adj_G(omega);
fi   = zeros(size(ad_a));

for m = 0:10
    x  = (((-1)^m) / factorial(m + 1)) * (ad_a^m);
    fi = fi + x;
end
end
