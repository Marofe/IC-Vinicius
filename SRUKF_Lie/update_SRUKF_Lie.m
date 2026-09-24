function [g_upd,P_upd] = update_SRUKF_Lie(g_pred,P_pred,Pqq,Prr,y,G_pred,Chi_R,alpha,beta,kappa,leverarm,L)
%% Reference: Giorgio M. Magalhães et al. (CBA 2018), Eq. 45 - 51
% g_pred, P_pred: predicted state and covariance g(t|t-1), P(t|t-1)
% g_upd, P_upd: updated state and covariance g(t|t), P(t|t)
% y: GNSS measurement (3x1 position vector in ECEF)
% G_pred: propagated state sigma points G(t|t-1) (13x13 x 2L+1)
% Chi_R: measurement noise sigma points component (3 x 2L+1)
% leverarm: GNSS antenna lever arm in body frame
%%
lambda=(alpha^2)*(L+kappa)-L;
%% Eq. 6: UT weights
Wm=[lambda/(lambda+L) ones(1,2*L)*(1/(2*(lambda+L)))]';
Wc=[lambda/(lambda+L)+(1-alpha^2+beta) ones(1,2*L)*(1/(2*(lambda+L)))]';

%% Eq. 45: Measurement Lie group sigma points on H = T(3)
H_pred=zeros(4,4,2*L+1);
for i=1:2*L+1
    Ceb=G_pred(1:3,1:3,i);
    peb=G_pred(1:3,5,i);
    H_pred(:,:,i)=[eye(3) peb + Ceb*leverarm + Chi_R(:,i); zeros(1,3) 1];
end

%% Eq. 46: Measurement mean on group H - Zero mean condition
h_pred=media_nula_h(Wm,H_pred,alpha,L);

%% Eq. 47 & 48: Innovation covariance and cross-covariance
[Phh,Pgh]=covariancias(g_pred,h_pred,G_pred,H_pred,Wc,Prr,L);

%% Eq. 49: Innovation in Lie algebra of H
innov_y = y - h_pred(1:3,4);

%% Eq. 49: Kalman gain and state error update in Lie algebra of G
% K = Pgh / Phh  =>  K = (Phh' \ Pgh')' = (Phh \ Pgh')'
K=(Phh\Pgh')';
eps_upd=K*innov_y;

%% Eq. 50: Covariance update
P_upd=P_pred - K*Pgh';
P_upd=0.5*(P_upd+P_upd');

%% Eq. 51: State update on Lie group G
g_upd = g_pred * exp_multiSE23T6(eps_upd);
end