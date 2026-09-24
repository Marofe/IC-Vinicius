function [Phh,Pgh]=covariancias(g_pred,h_pred,G_pred,H_pred,Wc,Prr,L)
%% Reference: Giorgio M. Magalhães et al. (CBA 2018), Eq. 47 & 48
p=15; % process Lie algebra dimension
%% Measurement Lie algebra error (eps_meas) and state error (eps_state)
eps_meas=squeeze(H_pred(1:3,4,:))-h_pred(1:3,4);
eps_state=zeros(p,2*L+1);
%% LU factorize g_pred once for all sigma-point solves
[Lg,Ug,Pg]=lu(g_pred);
for k=1:2*L+1
    eps_state(:,k)=log_multiSE23T6(Ug\(Lg\(Pg*G_pred(:,:,k))));
end
% Note: In Giorgio et al. (Eq. 47), measurement noise R is already sampled into
% H_pred, so Eq. 47 does not add "+ Prr".
Phh=eps_meas*diag(Wc)*eps_meas'+Prr;     % Eq. 47 with additive Prr
Pgh=eps_state*diag(Wc)*eps_meas';        % Eq. 48: Cross-covariance Pgh
end