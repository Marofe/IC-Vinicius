    close all
    clear all
    clc

    %adicionando biblioteca
    addpath('inslib')
    %carregando dados
    load('data_sim_circular.mat');

    p0=gps_pe(1,:)'; %condição inicial da posição
    lla0=SingleLlaFromEcef(p0); %local ref position (lat,lon,alt)
    Cen=DCM_en(lla0(1),lla0(2)); %from NED to ECEF
    gn=gravityModel(lla0(1));

    %% analise simbólica
    syms ep1 ep2 ep3 ep4 ep5 ep6 ep7 ep8 ep9 fib1 fib2 fib3 wib1 wib2 wib3 real
    syms C11 C12 C13 C21 C22 C23 C31 C32 C33 v1 v2 v3 p1 p2 p3 dt real
    
     %% variaveis simbolicas 
    %epslon
    eps=[ep1;ep2;ep3;ep4;ep5;ep6;ep7;ep8;ep9];
    %estados
    C=[C11 C12 C13;C21 C22 C23;C31 C32 C33];
    v=[v1;v2;v3];
    p=[p1;p2;p3];
    % Grupo de Lie do estado
    x=[C v p;zeros(2,3) eye(2)]; % x=[C v p; zeros(2,3) I(2)]
    %matriz de entrada
    u=[fib1;fib2;fib3;wib1;wib2;wib3];

    %%
    eps_up=bracketUp_SE_23(eps);
    X=x*exp_SO_2_3(eps_up); % x(k|k)*exp([eps]}^
    omegk=Omega(X,u)*dt;
    derivative=jacobian(omegk,eps);
    jac_C=subs(derivative,eps,zeros(9,1))

    
