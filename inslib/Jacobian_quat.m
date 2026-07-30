function A=Jacobian_quat(hx,u)
    q=hx(1:4);
    % v=hx(5:7);
    p0=hx(8:10);
    ba=hx(11:13);
    bg=hx(14:16);
    lla0=SingleLlaFromEcef(p0); %local ref position (lat,lon,alt)
    Cen=DCM_en(lla0(1),lla0(2)); %from NED to ECEF
    gn=gravityModel(lla0(1));

    wie=zeros(3,1);
    fib=u(1:3)*gn;
    wib=u(4:6);
    
    Ceb=Cen*rotmFromQuat(q);

    A=[-skew(wib-bg) zeros(3,3) zeros(3,3) zeros(3,3) -eye(3);...
        -Ceb*skew(fib-ba) -2*skew(wie) zeros(3,3) -Ceb zeros(3,3);...
        zeros(3,3) eye(3) zeros(3,3) zeros(3,3) zeros(3,3);...
        zeros(3,3) zeros(3,3) zeros(3,3) zeros(3,3) zeros(3,3);...
        zeros(3,3) zeros(3,3) zeros(3,3) zeros(3,3) zeros(3,3)];
end