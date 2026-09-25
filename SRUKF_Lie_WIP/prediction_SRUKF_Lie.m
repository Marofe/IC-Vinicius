function [g_pred,P_pred,G_pred]=prediction_SRUKF_Lie(g_prev,P_prev,Pqq,Prr,u,alpha,beta,kappa,L,dt,Chi_E,Chi_R,Chi_Q,Wm,Wc)
%% Reference: Giorgio M. Magalhães et al. (CBA 2018), Eq. 40 - 44
% g_prev, P_prev: previous state and covariance g(t-1|t-1), P(t-1|t-1)
% g_pred, P_pred: predicted state and covariance g(t|t-1), P(t|t-1)
% G_pred: propagated state sigma points G(t|t-1) (13x13 x 2L+1)
% Chi_R: measurement noise sigma points component (3 x 2L+1)
%%
p=15; % process Lie algebra dimension
% q=3;  % measurement Lie algebra dimension

%% Pre-compute geodetic quantities from mean state (shared by all sigma pts)
% This avoids calling SingleLlaFromEcef/DCM_en/gravityModel 2*L+1 times.
p0_0   = g_prev(1:3,5);
lla0   = SingleLlaFromEcef(p0_0);
Cen0   = DCM_en(lla0(1),lla0(2));
gn0    = gravityModel(lla0(1));
ge0    = Cen0*[0;0;gn0];
fib_scaled = u(1:3)*gn0;
wib    = u(4:6);

%% Eq. 41 & 42: Sigma points propagation through group dynamics
G_pred=zeros(13,13,2*L+1); % G => SE_2(3) = [Ceb v p; 0 I]
for i=1:2*L+1
    G_prev_i = g_prev*exp_multiSE23T6(Chi_E(:,i));          % G(t-1|t-1) (Eq. 41)
    % Re-use pre-computed gn,ge,Cen — extract per-sigma Cbe,v,ba,bg
    Cbe_i = G_prev_i(1:3,1:3).';
    v_i   = G_prev_i(1:3,4);
    ba_i  = G_prev_i(6:8,9);
    bg_i  = G_prev_i(10:12,13);
    omega_b  = wib - bg_i;
    acc_e    = (fib_scaled - ba_i) + Cbe_i*ge0;   % specific force + gravity in ECEF
    vel_e    = Cbe_i*v_i;                         % velocity in body frame
    Omega_dt = [omega_b; acc_e; vel_e; zeros(6,1)]*dt;
    G_pred(:,:,i) = G_prev_i*exp_multiSE23T6(Omega_dt + Chi_Q(:,i)); % G(t|t-1) (Eq. 42)
end

%% State mean prediction on Lie group (Eq. 32 & 43) - Zero mean condition
g_pred=media_nula_g(Wm,G_pred,alpha,L);

%% Predicted covariance in Lie algebra (Eq. 44) - vectorised
eps_state=zeros(p,2*L+1);
for k=1:2*L+1
    eps_state(:,k)=log_multiSE23T6(g_pred\G_pred(:,:,k));
end
% Note: In Giorgio et al. (Eq. 44), process noise Q is already sampled into
% G_pred (Eq. 42), so Eq. 44 does not add "+ Pqq".
P_pred=eps_state*diag(Wc)*eps_state'+Pqq; % Eq. 44 with additive Pqq
P_pred=0.5*(P_pred+P_pred');
end
