function X = sigmaPoints(x0,P0,lambda)
%SIGMAPOINTS Summary of this function goes here
%   Detailed explanation goes here
if size(x0,1)==1
    x0=x0';
end
P0=0.5*(P0+P0');
minEig=min(real(eig(P0)));
if minEig < 0
    P0=P0+eye(size(P0,1))*abs(minEig*2);
end
%P=P'>0
S=chol(P0)'; %S'S=P; S=sqrtm(P)
n=size(P0,1);
t=sqrt(lambda+n);
X=[x0 x0+t*S x0-t*S]; %nx(2n+1)
X(3,:)=wrapToPi(X(3,:));
end

