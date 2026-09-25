function [Chi_E,Chi_Q,Chi_R,Wm,Wc]=SRSigmaPointsLie(alpha,beta,kappa,P_prev,Pqq,Prr,L)
%% Reference: Giorgio M. Magalhães et al. (CBA 2018), Eq. 5, 6, 40
% Augmented Covariance Matrix P = blkdiag(P_prev, Pqq, Prr)
%   - P_prev: P(t-1|t-1) (dimension p x p = 15x15)
%   - Pqq: process noise covariance (dimension p x p = 15x15)
%   - Prr: measurement noise covariance (dimension q x q = 3x3)
%
% Chi = [Chi(:,1) ... Chi(:,2*L+1)], dimension L x (2*L+1) = 33x67
% Partitioned into [Chi_E; Chi_Q; Chi_R]
%% Augmented covariance matrix on Lie algebra: xi ~ N(0, blkdiag(P_prev, Pqq, Prr))
p15 = size(P_prev,1);  % 15
pqq = size(Pqq,1);     % 15
% prr = size(Prr,1);     % 3
P   = zeros(L,L);
P(1:p15,         1:p15        ) = P_prev;
P(p15+1:p15+pqq, p15+1:p15+pqq) = Pqq;
P(p15+pqq+1:end, p15+pqq+1:end) = Prr;

%% 1. Unscented Transform Parameters & Weights
lambda=(alpha^2)*(L+kappa)-L;
t=sqrt(L+lambda);
W0m = lambda / (p + lambda);
W0c = lambda / (p + lambda) + (1 - alpha^2 + beta);
Wim = 1 / (2 * (p + lambda));
Wic = 1 / (2 * (p + lambda));

Wm = [W0m; repmat(Wim, 2*p, 1)]; % (2p+1) x 1
Wc = [W0c; repmat(Wic, 2*p, 1)]; % (2p+1) x 1

%% 2. Sigma Point Generation
[S, flag] = chol(P, 'lower');
if flag ~= 0
    % Not PD: regularise with smallest diagonal dominance shift
    minEig = min(eig(P));  % only called if chol fails (rare)
    P = P + eye(L)*abs(minEig*2 + 1e-14);
    S = chol(P,"lower");
end

Chi = [zeros(L,1), t*S, -t*S]; % (2*p+q , 2*L+1)
Chi_E = squeeze(Chi(1:15,:));
Chi_Q = squeeze(Chi(16:30,:));
Chi_R = squeeze(Chi(31:33,:));
end