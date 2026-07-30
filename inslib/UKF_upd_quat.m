function [hx,P] = UKF_upd_quat(hx0,P0,R,y,alpha,beta,kappa,lb,Cen)
        inv_hq=[-hx0(1:3);hx0(4)];
        n=size(P0,1); %n=15, mas são 16 estados
        m=size(R,1);  %m=3 tamanho da saida 
        if size(hx0,1)==1
            hx0=hx0';
        end
        lambda=alpha^2*(n+kappa)-(n);
        X=sigmaPoints_quat(hx0,P0,lambda); %15X31
        Y=zeros(m,2*n+1); %3X31
        for i=1:2*n+1
            Ceb=Cen*rotmFromQuat(X(1:4,i));
            Y(:,i)=X(8:10,i)+Ceb*lb;  % hY= hq + lever-arm
        end
        Wm=[lambda/(lambda+n) ones(1,2*n)*(1/(2*(lambda+n)))]'; %19x1
        Wc=[lambda/(lambda+n)+(1-alpha^2+beta) ones(1,2*n)*(1/(2*(lambda+n)))]'; %19x1
        hy=Y*Wm; % (3x31)x(31x1)=3x1 % media ponderada de Y por Wm
        epsy=Y-hy; %(3x31)-(3x1)=(3x31)
        epsx=zeros(n,2*n+1); %(15x31);
        %% calculo de epsx = [del_phi del_veb del_peb del_ba del_bg] = 15x31
        for i=1:2*n+1
            %para o quaternion
            del_q=mult_quat(X(1:4,i),inv_hq);
            del_q=del_q/norm(del_q);
            epsx(1:3,i)=2*del_q(1:3);   %epsx(1:3)=del_phi
            %para veb e peb
            epsx(4:15,i)=X(5:16,i)-hx0(5:16);
        end
        %% calculo das covariancias estimadas de medida e cruzada
        S=epsy*diag(Wc)*epsy'+R; %(3x31)x(31x31)x(31x3) + (3x3) = (3x3)
        C=epsx*diag(Wc)*epsy';   %(15x31)x(31x31)x(31x3) = (15x3)
        %% ganho de kalman
        K=C/S; %(15x3)x(3x3)=(15x3)
        %% update do estado
        del_phi_X=K*(y-hy); % [del_phi del_X]15x1 = K*(y-hy)
        % update do quaternion
        hx(1:4)=hx0(1:4) + 0.5*Xi(hx0(1:4))*del_phi_X(1:3);%  Xquat = del_ q(x)hq => eq (41)
        hx(1:4)=hx(1:4)/norm(hx(1:4));
        % update da veb e peb
        hx(5:16)=hx0(5:16)+del_phi_X(4:15);
        %% update da covariancia
        P=P0-K*S*K'; %covariance update 9x9 - (9x3)*(3x3)*(3x9)
        P=0.5*(P+P');
end
