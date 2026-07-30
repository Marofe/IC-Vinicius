function C=matriz_C_se23T6(hx,u,gn,Cen,dt)
%matriz de estados
Ceb11=hx(1,1);
Ceb12=hx(1,2);
Ceb13=hx(1,3);
Ceb21=hx(2,1);
Ceb22=hx(2,2);
Ceb23=hx(2,3);
Ceb31=hx(3,1);
Ceb32=hx(3,2);
Ceb33=hx(3,3);
v1=hx(1,4);
v2=hx(2,4);
v3=hx(3,4);
p1=hx(1,5);
p2=hx(2,5);
p3=hx(3,5);
ba1=hx(6,9);
ba2=hx(7,9);
ba3=hx(8,9);
bg1=hx(10,13);
bg2=hx(11,13);
bg3=hx(12,13);
%entrada
fib1=u(1);
fib2=u(2);
fib3=u(3);
wib1=u(4);
wib2=u(5);
wib3=u(6);
%% Cen
Cen11=Cen(1,1);
Cen12=Cen(1,2);
Cen13=Cen(1,3);
Cen21=Cen(2,1);
Cen22=Cen(2,2);
Cen23=Cen(2,3);
Cen31=Cen(3,1);
Cen32=Cen(3,2);
Cen33=Cen(3,3);

C=[[                                                     0,                                                      0,                                                      0,                                            0,                                            0,                                            0, 0, 0, 0,   0,   0,   0, -dt,   0,   0]
[                                                     0,                                                      0,                                                      0,                                            0,                                            0,                                            0, 0, 0, 0,   0,   0,   0,   0, -dt,   0]
[                                                     0,                                                      0,                                                      0,                                            0,                                            0,                                            0, 0, 0, 0,   0,   0,   0,   0,   0, -dt]
[                                                     0, -dt*(Ceb13*Cen13*gn + Ceb23*Cen23*gn + Ceb33*Cen33*gn),  dt*(Ceb12*Cen13*gn + Ceb22*Cen23*gn + Ceb32*Cen33*gn),                                            0,                                            0,                                            0, 0, 0, 0, -dt,   0,   0,   0,   0,   0]
[ dt*(Ceb13*Cen13*gn + Ceb23*Cen23*gn + Ceb33*Cen33*gn),                                                      0, -dt*(Ceb11*Cen13*gn + Ceb21*Cen23*gn + Ceb31*Cen33*gn),                                            0,                                            0,                                            0, 0, 0, 0,   0, -dt,   0,   0,   0,   0]
[-dt*(Ceb12*Cen13*gn + Ceb22*Cen23*gn + Ceb32*Cen33*gn),  dt*(Ceb11*Cen13*gn + Ceb21*Cen23*gn + Ceb31*Cen33*gn),                                                      0,                                            0,                                            0,                                            0, 0, 0, 0,   0,   0, -dt,   0,   0,   0]
[                                                     0,                   -dt*(Ceb13*v1 + Ceb23*v2 + Ceb33*v3),                    dt*(Ceb12*v1 + Ceb22*v2 + Ceb32*v3),             dt*(Ceb11^2 + Ceb21^2 + Ceb31^2), dt*(Ceb11*Ceb12 + Ceb21*Ceb22 + Ceb31*Ceb32), dt*(Ceb11*Ceb13 + Ceb21*Ceb23 + Ceb31*Ceb33), 0, 0, 0,   0,   0,   0,   0,   0,   0]
[                   dt*(Ceb13*v1 + Ceb23*v2 + Ceb33*v3),                                                      0,                   -dt*(Ceb11*v1 + Ceb21*v2 + Ceb31*v3), dt*(Ceb11*Ceb12 + Ceb21*Ceb22 + Ceb31*Ceb32),             dt*(Ceb12^2 + Ceb22^2 + Ceb32^2), dt*(Ceb12*Ceb13 + Ceb22*Ceb23 + Ceb32*Ceb33), 0, 0, 0,   0,   0,   0,   0,   0,   0]
[                  -dt*(Ceb12*v1 + Ceb22*v2 + Ceb32*v3),                    dt*(Ceb11*v1 + Ceb21*v2 + Ceb31*v3),                                                      0, dt*(Ceb11*Ceb13 + Ceb21*Ceb23 + Ceb31*Ceb33), dt*(Ceb12*Ceb13 + Ceb22*Ceb23 + Ceb32*Ceb33),             dt*(Ceb13^2 + Ceb23^2 + Ceb33^2), 0, 0, 0,   0,   0,   0,   0,   0,   0]
[                                                     0,                                                      0,                                                      0,                                            0,                                            0,                                            0, 0, 0, 0,   0,   0,   0,   0,   0,   0]
[                                                     0,                                                      0,                                                      0,                                            0,                                            0,                                            0, 0, 0, 0,   0,   0,   0,   0,   0,   0]
[                                                     0,                                                      0,                                                      0,                                            0,                                            0,                                            0, 0, 0, 0,   0,   0,   0,   0,   0,   0]
[                                                     0,                                                      0,                                                      0,                                            0,                                            0,                                            0, 0, 0, 0,   0,   0,   0,   0,   0,   0]
[                                                     0,                                                      0,                                                      0,                                            0,                                            0,                                            0, 0, 0, 0,   0,   0,   0,   0,   0,   0]
[                                                     0,                                                      0,                                                      0,                                            0,                                            0,                                            0, 0, 0, 0,   0,   0,   0,   0,   0,   0]];

end