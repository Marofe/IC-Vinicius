function [hx,P]=prediction_EKF_Lie(hx0,P0,u,Q,dt)

    %% predição do estado
    [omeg,gn,Cen]=Omega(hx0,u);               %criando a função Omega(X,u)=[f1 f2 f3]'
   % Up_omeg=bracketUp_SE_23(omeg);   %fazendo [Omega(X,u)]^ 
    omegk=omeg*dt;
    hx=hx0*exp_multiSE23T6(omegk);         %X(k+1)=X(k)exp([Omega(X,u)]^dt)
    %% predição da covariância 
    %matriz phi(Omega)
    Phi=phi(omegk);
    %Phi=eye(9);
    %matriz C_k
    C=matriz_C_se23T6(hx,u,gn,Cen,dt);  
    %matriz F
    F=Ad_G(exp_multiSE23T6(-omegk))+Phi*C; %Ad_G(exp([-Omeg]^dt))+Phi(Omeg)*C
    %matriz Q
    Qk=Q;
    % covariancia
    P=F*P0*F' + Phi*Qk*Phi';
    P=(P+P')/2; %force symmetry (compensate for numeric errors)
end