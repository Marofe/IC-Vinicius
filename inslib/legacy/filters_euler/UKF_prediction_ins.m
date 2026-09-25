function [hx,P] = UKF_prediction_ins(hx0,P0,Q,u,alpha,beta,kappa,dt)
    %Additive-noise UKF
    %UT={alpha,beta,kappa}
    n=size(P0,1);
    lambda=alpha^2*(n+kappa)-n;
    X=sigmaPoints(hx0,P0,lambda);
    hX=zeros(n,2*n+1);
    %% Propagate the Sigma-points through non-linear map
    %arrayfun
    for i=1:2*n+1
        hX(:,i)=X(:,i)+f(X(:,i),u)*dt;
        hX(3,i)=wrapToPi(hX(3,i));
    end
    Wm=[lambda/(lambda+n) ones(1,2*n)*(1/(2*(lambda+n)))]';
    Wc=[lambda/(lambda+n)+(1-alpha^2+beta) ones(1,2*n)*(1/(2*(lambda+n)))]';
    hx=hX*Wm; %(nx2n+1)* ((2n+1)x1)
    hx(3)=wrapToPi(hx(3));
    epsx=hX-hx;
    epsx(3,:)=wrapToPi(epsx(3,:));
    P=epsx*diag(Wc)*epsx'+Q;
    P=0.5*(P+P'); %compensate numeric issues
    hx=hx';
end

