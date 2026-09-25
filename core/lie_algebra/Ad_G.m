function Adj = Ad_G(X) %#codegen
% AD_G Group Adjoint matrix on SE_2(3) x R^6 (15x15).
C = X(1:3, 1:3);
v = X(1:3, 4);
p = X(1:3, 5);

Adj = [C,                        zeros(3, 3), zeros(3, 3); ...
       Skew_Symmetric_3(v) * C,  C,           zeros(3, 3); ...
       Skew_Symmetric_3(p) * C,  zeros(3, 3), C];

Adj = blkdiag(Adj, eye(6));
end
