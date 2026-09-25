function f=f_quat(x,u)
%% x=[q veb peb ba bg]'
    q=x(1:4); %q=[qx qy qz qw]
    veb=x(5:7);
    p0=x(8:10);
    ba=x(11:13);
    bg=x(14:16);
    lla0=SingleLlaFromEcef(p0); %local ref position (lat,lon,alt)
    Cen=DCM_en(lla0(1),lla0(2)); %from NED to ECEF
    gn=gravityModel(lla0(1));
    %% u
    fib=u(1:3)*gn;
    wib=u(4:6);
    %% f(x,u)=[f1 f2 f3]'

    %% f1  qdot=f1
    T=Xi(q);
    f1=0.5*T*(wib-bg); %dot_q= f1
    %f1=0.5*[-skew(wib) wib;...
    %        -wib' 0]*q;

    %% f2  veb_dot=f2
    ge=Cen*[0 0 gn]';
    Ceb=Cen*rotmFromQuat(q);
    f2 = Ceb*(fib-ba) + ge;

    %% f3   peb_dot=f3
    f3=veb;
    %% f4,f5
    f_45=zeros(6,1);

    %%
    f=[f1;f2;f3;f_45];
end