function dOmega=bracketUp_SE_23(Omega)
%objetivo: fazer [Omega]^ 
%Omega=[w(3x1), t1(3,1), t2(3,1)] 9x1

dOmega=[skew(Omega(1:3)) Omega(4:6) Omega(7:9);zeros(2,3) zeros(2,2)]; 

end