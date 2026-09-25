function [hx,P] = UKF_pred_quat(hx0,P0,Q,u,alpha,beta,kappa,dt)
    n=size(P0,1); %n=15, 
    %% parametro lambda da UT
    lambda=alpha^2*(n+kappa)-n;
    %% Calculo dos SigmaPoints
    X=sigmaPoints_quat(hx0,P0,lambda); %10 x 2*n+1 = 10x19
    %% Alocação de memória 
    % propagated sigPoints
    hX=zeros(n+1,2*n+1);  %16 x 2*n+1  
    %% Propagate the Sigma-points through non-linear map
    for i=1:2*n+1
        %% Sigmapoints pela função f(SigmaPoints)
        hX(:,i)=X(:,i)+f_quat(X(:,i),u)*dt;
        hX(1:4,i)=hX(1:4,i)/norm(hX(1:4,i));
    end
    %% calculo dos pesos
    Wm=[lambda/(lambda+n) ones(1,2*n)*(1/(2*(lambda+n)))]'; % (2n+1)x1 = 31x1
    Wc=[lambda/(lambda+n)+(1-alpha^2+beta) ones(1,2*n)*(1/(2*(lambda+n)))]'; %(2n+1)x1 = 31x1
    %% cálculo da 'média ponderada' dos estados (predição dos estados)
    % calculo da média do quaternion
    m_q=media_quat(hX(1:4,:),Wm); %4x1
    % calculo da média de veb, peb, bias
    m_euc=zeros(12,1);
    for i=1:2*n+1
        m_euc=m_euc+Wm(i)*hX(5:16,i);
    end
    %media
    m=[m_q;m_euc]; % equivale a m = hX*Wm
    hx=m;
    %% calculo de epsX = hX-m = [del_phi del_veb del_peb del_ba del_bg] 15x31
    inv_mq=[-m(1:3);m(4)]; % inv da média do quat
    epsx=complex(zeros(n,2*n+1)); %15x31
    for i=1:2*n+1
        % epsx para o quaternion
        dq=mult_quat(hX(1:4,i),inv_mq); % del_q=q(x)inv_hq eq 8
        dq=dq/norm(dq);
        epsx(1:3,i)=2*dq(1:3); 
        % epsx para veb e peb
        epsx(4:15,i)=hX(5:16,i)-m(5:16);
    end
    Qk=Q; %exp(At)=I+At+(At)^2/2+...
    P=epsx*diag(Wc)*epsx'+Qk; %(15x31)*(31 x 31)*(31 x 15) + 9x9
    P=0.5*(P+P'); %compensate numeric issues

end
