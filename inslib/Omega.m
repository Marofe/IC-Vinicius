function [omeg,gn,Cen]=Omega(X,u)
% para construir a jaco colocar os arg como (X,u,gn,Cen) e saida [omeg]
% Omega(15x1)
% X=blkdiag([Ceb veb peb;0(2x3) eye(2)],[I(3) ba;0(1,3) 1],[I(3) bg;0(1,3) 1])

    Cbe=X(1:3,1:3)'; %Cbe=Ceb'
    v0=X(1:3,4);
    p0=X(1:3,5);
    ba=X(6:8,9);
    bg=X(10:12,13);

    lla0=SingleLlaFromEcef(p0); %local ref position (lat,lon,alt)
    Cen=DCM_en(lla0(1),lla0(2)); %from NED to ECEF
    gn=gravityModel(lla0(1));

    fib=u(1:3)*gn;
    wib=u(4:6);
    ge=Cen*[0 0 gn]';
    

    f1=wib-bg;          %wib
    f2=(fib-ba) + Cbe*ge; %fib +gb , com gb=Cbe*ge
    f3=Cbe*v0; %Cbe*veb
    fbias=zeros(6,1);%dot_bias=0
    omeg=[f1;f2;f3;fbias];
end