function [dx,gn]=f(x0,u)

    p0=x0(7:9);
    lla0=SingleLlaFromEcef(p0); %local ref position (lat,lon,alt)
    Cen=DCM_en(lla0(1),lla0(2)); %from NED to ECEF
    gn=gravityModel(lla0(1));

    fib=u(1:3)*gn;
    wib=u(4:6);
    ba=x0(10:12);
    bg=x0(13:15);
    Ceb=rotm(flip(x0(1:3)),'ZYX')';
    ge=Cen*[0 0 gn]';

    dx=[Gamma(x0)*(wib-bg);... %euler angles
        Ceb*(fib-ba)+ge;...    %aeb
        x0(4:6);...       %veb
        zeros(6,1);       %biases
        ];
end