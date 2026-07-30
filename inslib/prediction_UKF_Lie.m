function [g,Pt,G_t,R]=prediction_UKF_Lie(g0,Pt0,Pqq,Prr,u,alpha,beta,kappa,L,dt)
%% lembretes
% Pt0= antigo P0
% Pqq= antigo Q (cov do ruido de processo)
% Prr= antigo R (cov do ruido de medida)
%%
p=15; %dimensão da algebra do processo
q=3;  %dimensão da algebra da medida
%% calculo do 'novo' estado eta = [eps q r] 
eta=zeros(L,1);
%% calculo sigma Points
[Xi,Wm,Wc]=SigmaPointsLie(eta,alpha,beta,kappa,Pt0,Pqq,Prr,L);
%% Xi é composto por:
E=squeeze(Xi(1:15,:));
Q=squeeze(Xi(16:30,:));
R=squeeze(Xi(31:33,:));

%% Pre-compute geodetic quantities from mean state (shared by all sigma pts)
% This avoids calling SingleLlaFromEcef/DCM_en/gravityModel 2*L+1 times.
ba_0   = g0(6:8,9);
bg_0   = g0(10:12,13);
Cbe_0  = g0(1:3,1:3)';        % Cbe = Ceb'
v0_0   = g0(1:3,4);
p0_0   = g0(1:3,5);
lla0   = SingleLlaFromEcef(p0_0);
Cen0   = DCM_en(lla0(1),lla0(2));
gn0    = gravityModel(lla0(1));
ge0    = Cen0*[0;0;gn0];
fib0   = u(1:3)*gn0;
wib    = u(4:6);

%% EQ 41 e 42 sigmPoint pela função dinâmica
G_t=zeros(13,13,2*L+1); %G => SE_2(3)= [Ceb v p,0 I]5X5 
for i=1:2*L+1
    G_t_1 = g0*exp_multiSE23T6(E(:,i));          % G(t-1|t-1)
    % Re-use pre-computed gn,ge,Cen — extract per-sigma Cbe,v,ba,bg
    Cbe_i = G_t_1(1:3,1:3).';
    v_i   = G_t_1(1:3,4);
    ba_i  = G_t_1(6:8,9);
    bg_i  = G_t_1(10:12,13);
    f1    = wib   - bg_i;
    f2    = (fib0 - ba_i) + Cbe_i*ge0;   % fib + Cbe*ge
    f3    = Cbe_i*v_i;
    Omegk = [f1;f2;f3;zeros(6,1)]*dt;
    G_t(:,:,i) = G_t_1*exp_multiSE23T6(Omegk + Q(:,i)); % G(t|t-1)
end

%% Predição do estado (eq 32) - Média nula
g=media_nula_g(Wm,G_t,alpha,L);

%% Predição covariancia (eq 44) - vectorised
% Batch-solve: epsg(:,i) = log( g \ G_t(:,:,i) )
% Reshape G_t pages into columns, solve once, reshape back
epsg=zeros(p,2*L+1);
for k=1:2*L+1
    epsg(:,k)=log_multiSE23T6(g\G_t(:,:,k));
end
Pt=epsg*diag(Wc)*epsg'+Pqq; %eq 44
Pt=0.5*(Pt+Pt');
end
