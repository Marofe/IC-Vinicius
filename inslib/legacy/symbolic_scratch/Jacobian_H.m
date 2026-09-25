close all 
clear all
clc
syms ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9 real
syms C11 C12 C13 C21 C22 C23 C31 C32 C33 v1 v2 v3 p1 p2 p3 rx ry rz real

    lb=[rx ry rz]';

    %epslon
    eps=[ep1;ep2;ep3;ep4;ep5;ep6;ep7;ep8;ep9];
    %estados
    C=[C11 C12 C13;C21 C22 C23;C31 C32 C33];
    v=[v1;v2;v3];
    p=[p1;p2;p3];
    % Grupo de Lie do estado
    x=[C v p;zeros(2,3) eye(2)]; % x=[C v p; zeros(2,3) I(2)]  x===>SE_2(3)
    
    eps_up=bracketUp_SE_23(eps); %[eps]^

     
    Y1=h_Lie(x); % h(hx(k+1|k))
    Y2=h_Lie(x*exp_SO_2_3(eps_up)); % h(hx(k+1|k)*exp([eps]^))

    inv_Y1=inv(Y1);  % h(hx(k+1|k))^-1

    log=inv_Y1*Y2;   %log(invY1*Y2)v 
    log=log(1:3,4);

    derivate= jacobian(log,eps);
    H=subs(derivate,eps,zeros(9,1))
