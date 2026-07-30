function [Phh,Pgh]=covariancias(g,h,G,H,Wc,Prr,L)
p=15; %dimensao da algebra do processo
%% Eq 47 48
%% epsh e epsg
% Vectorised epsh: grab the 4th column of all pages at once
epsh=squeeze(H(1:3,4,:))-h(1:3,4);
epsg=zeros(p,2*L+1);
%% LU factorize g once for all sigma-point solves
[Lg,Ug,Pg]=lu(g);
for k=1:2*L+1
    epsg(:,k)=log_multiSE23T6(Ug\(Lg\(Pg*G(:,:,k))));
end
Phh=epsh*diag(Wc)*epsh'+Prr;     %(3x2L+1)X(2L+1X2L+1)X(2L+1X3)
Pgh=epsg*diag(Wc)*epsh';     %(9x2L+1)X(2L+1X2L+1)X(2L+1X3)
end