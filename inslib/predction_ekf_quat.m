function [hx,P]=predction_ekf_quat(hx0,P0,u,Q,dt,n)

    % Predição do estado, resolvendo dot_hx=f(x,u)
    hx=hx0+f_quat(hx0,u)*dt;
    hx(1:4)=hx(1:4)/norm(hx(1:4)); %normalização forçada

    A=Jacobian_quat(hx,u); % A = Jacob(u,Ceb) e Ceb= função do quaternion 

    Phi=eye(n-1)+A*dt+0.5*A*A*dt^2; %a matriz Phi(ou A) tem tamanho (n-1)x(n-1)

    %Predição da matriz de Covariância
    Qk=Q;
    P=Phi*P0*Phi'+Qk;
    P=(P+P')/2; %force symmetry (compensate for numeric errors)
end