function chi = exp_multiframeSE32(xi)
Xi=[cross2matrix(xi(1:3)) zeros(3) xi(7:9,1);...
      zeros(3) cross2matrix(xi(4:6)) xi(10:12,1);...
      zeros(1,7)];
  Xi2=Xi*Xi;
  Xi3=Xi2*Xi;
  Xi4=Xi3*Xi;
  Xi5=Xi4*Xi;
 chi=eye(7)+Xi+0.5*Xi2+1/6*Xi3+1/24*Xi4+1/120*Xi5;
end

