function chi = exp_multiSE3_sym(xi)
% xi=[eC eP eV];
E=[cross2matrix(xi(1:3)) xi(4:6) xi(7:9) xi(10:12) xi(13:15);...
    zeros(4,7)];
chi=eye(7)+E+0.5*E*E;
end

