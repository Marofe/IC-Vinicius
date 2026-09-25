function adj = Adj_G(a) %#codegen
% ADJ_G Lie algebra adjoint matrix on se_2(3) x R^6 (15x15).
Sw = Skew_Symmetric_3(a(1:3));
adj = [Sw,                         zeros(3, 3), zeros(3, 3); ...
       Skew_Symmetric_3(a(4:6)),   Sw,          zeros(3, 3); ...
       Skew_Symmetric_3(a(7:9)),   zeros(3, 3), Sw];

adj = blkdiag(adj, zeros(6, 6));
end
