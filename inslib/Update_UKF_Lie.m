function [g,Pt]=Update_UKF_Lie(g0,Pt0,Pqq,Prr,y,G,R,alpha,beta,kappa,lb,L)
%% lembretes
% a medida é Y=h(X)EXP(ruido)  com Y=[I p_gps;0 1] Y é do tipo T(3)

% fazer log_v(inv(Y1)*Y2) = p2 - p1

% Se Y1=[I p1;0 1] e Y2=[I p2;0 1] ==> Y1*Y2 = [I (p1+p2);0 1];

% H=h(G)*exp^(R); Se G=[Ceb v p,0 I] ==> h(G)=[I p+Ceb*lb;0 1]; expH^(R)=[I R,0 1] 

% h(G)*expH^(R)= [I p+Ceb*lb + R;0 1]=[I p+Ceb*lb;0 1]*[I R;0 1]
%% 
lambda=(alpha^2)*(L+kappa)-L;
%% pesos
Wm=[lambda/(lambda+L) ones(1,2*L)*(1/(2*(lambda+L)))]';
Wc=[lambda/(lambda+L)+(1-alpha^2+beta) ones(1,2*L)*(1/(2*(lambda+L)))]';
%%  calculo dos sigma points do Grupo para o Update (Eq 45-artigo)
% G_t=zeros(5,5,2*L+1); 
Y=zeros(4,4,2*L+1);
for i=1:2*L+1
    Ceb=G(1:3,1:3,i);
    peb=G(1:3,5,i);
    Y(:,:,i)=[eye(3) peb+Ceb*lb + R(:,i);zeros(1,3) 1];
end
%% MEDIA NULA 
ht=media_nula_h(Wm,Y,alpha,L);
%% covariancias de medida e cruzada
[Phh,Pgh]=covariancias(g0,ht,G,Y,Wc,Prr,L);
%% del_t = logv(inv(ht)*Ygps)= y_gps - ht(1:3,4)
del_t=y - ht(1:3,4);
%% Update do eps (eq 49) - Kalman gain via 3x3 solve (Phh is 3x3)
% K = Pgh / Phh  =>  K = (Phh' \ Pgh')' = (Phh \ Pgh')'
% Phh is symmetric so Phh'=Phh; use Cholesky-based solve
K=(Phh\Pgh')';
eps=K*del_t;
%% Update Pt
Pt=Pt0 - K*Pgh';
Pt=0.5*(Pt+Pt');
%% Update do estado
g = g0 * exp_multiSE23T6(eps);
end