function xi = Log_Multi_SE23T6(X) %#codegen
% LOG_MULTI_SE23T6 Logarithmic map from SE_2(3) x T(6) (13x13) to R^15.
X_se23 = X(1:5, 1:5);
ba     = X(6:8, 9);
bg     = X(10:12, 13);

xi_se23 = Log_Multi_SE3(X_se23);
xi      = [xi_se23; ba; bg];
end