function H=matriz_H_se23T6(hx,lb)
Ceb11=hx(1,1);
Ceb12=hx(1,2);
Ceb13=hx(1,3);
Ceb21=hx(2,1);
Ceb22=hx(2,2);
Ceb23=hx(2,3);
Ceb31=hx(3,1);
Ceb32=hx(3,2);
Ceb33=hx(3,3);

lb1=lb(1);
lb2=lb(2);
lb3=(3);

H=[[Ceb13*lb2 - Ceb12*lb3, Ceb11*lb3 - Ceb13*lb1, Ceb12*lb1 - Ceb11*lb2, 0, 0, 0, Ceb11, Ceb12, Ceb13, 0, 0, 0, 0, 0, 0]
[Ceb23*lb2 - Ceb22*lb3, Ceb21*lb3 - Ceb23*lb1, Ceb22*lb1 - Ceb21*lb2, 0, 0, 0, Ceb21, Ceb22, Ceb23, 0, 0, 0, 0, 0, 0]
[Ceb33*lb2 - Ceb32*lb3, Ceb31*lb3 - Ceb33*lb1, Ceb32*lb1 - Ceb31*lb2, 0, 0, 0, Ceb31, Ceb32, Ceb33, 0, 0, 0, 0, 0, 0]];
end