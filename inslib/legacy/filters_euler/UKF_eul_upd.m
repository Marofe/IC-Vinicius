function [hx,P] = UKF_eul_upd(hx0,P0,R,y,alpha,beta,kappa,leverarm)
n=size(P0,1);
m=size(R,1);
if size(hx0,1)==1
    hx0=hx0';
end
lambda=alpha^2*(n+kappa)-n;
X=sigmaPoints(hx0,P0,lambda);
Y=zeros(m,2*n+1);
for i=1:2*n+1
    Ceb=rotm(flip(X(1:3,i)),'ZYX')';
    Y(:,i)=X(7:9,i)+Ceb*leverarm;
end
Wm=[lambda/(lambda+n) ones(1,2*n)*(1/(2*(lambda+n)))]';
Wc=[lambda/(lambda+n)+(1-alpha^2+beta) ones(1,2*n)*(1/(2*(lambda+n)))]';
hy=Y*Wm;
epsy=Y-hy; %ln(Y\hy)
epsx=X-hx0;
epsx(3,:)=wrapToPi(epsx(3,:));
S=epsy*diag(Wc)*epsy'+R;
C=epsx*diag(Wc)*epsy';
%%
K=C/S;%Kalman Gain
hx=hx0+K*(y-hy); %mean update
hx(3)=wrapToPi(hx(3));
P=P0-K*S*K'; %covariance update
P=real(0.5*(P+P'));
end

