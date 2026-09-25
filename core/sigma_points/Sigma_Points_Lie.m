function [Chi, Wm, Wc] = Sigma_Points_Lie(varargin) %#codegen
%% SIGMA_POINTS_LIE Augmented sigma points on Lie algebra using block-diagonal Cholesky
% Reference: Giorgio M. Magalhaes et al. (CBA 2018), Eq. 5, 6, 40
%
% Calling formats:
%   [Chi, Wm, Wc] = Sigma_Points_Lie(alpha, beta, kappa, P_prev, Pqq, Prr, L)       (Standard 7-arg)
%   [Chi, Wm, Wc] = Sigma_Points_Lie(Eta, alpha, beta, kappa, P_prev, Pqq, Prr, L) (Legacy 8-arg)

if nargin == 7
    alpha  = varargin{1};
    beta   = varargin{2};
    kappa  = varargin{3};
    P_prev = varargin{4};
    Pqq    = varargin{5};
    Prr    = varargin{6};
    L      = varargin{7};
elseif nargin == 8
    alpha  = varargin{2};
    beta   = varargin{3};
    kappa  = varargin{4};
    P_prev = varargin{5};
    Pqq    = varargin{6};
    Prr    = varargin{7};
    L      = varargin{8};
else
    error('Sigma_Points_Lie requires 7 or 8 arguments.');
end

p15 = size(P_prev, 1);
pqq = size(Pqq, 1);
prr = size(Prr, 1);

% Force numerical symmetry on individual diagonal blocks
P_prev_sym = 0.5 * (P_prev + P_prev.');
Pqq_sym    = 0.5 * (Pqq + Pqq.');
Prr_sym    = 0.5 * (Prr + Prr.');

% Block-diagonal Cholesky factorization (#38: avoids full 33x33 chol)
[S_prev, flag1] = chol(P_prev_sym, 'lower');
if flag1 ~= 0
    minEig = min(real(eig(P_prev_sym)));
    S_prev = chol(P_prev_sym + eye(p15) * abs(minEig * 2 + 1e-14), 'lower');
end

[S_qq, flag2] = chol(Pqq_sym, 'lower');
if flag2 ~= 0
    minEig = min(real(eig(Pqq_sym)));
    S_qq   = chol(Pqq_sym + eye(pqq) * abs(minEig * 2 + 1e-14), 'lower');
end

[S_rr, flag3] = chol(Prr_sym, 'lower');
if flag3 ~= 0
    minEig = min(real(eig(Prr_sym)));
    S_rr   = chol(Prr_sym + eye(prr) * abs(minEig * 2 + 1e-14), 'lower');
end

Sk = zeros(L, L);
Sk(1:p15, 1:p15)                 = S_prev;
Sk(p15+1:p15+pqq, p15+1:p15+pqq) = S_qq;
Sk(p15+pqq+1:end, p15+pqq+1:end) = S_rr;

%% Unscented Transform Parameters & Weights (Eq. 6)
lambda = (alpha^2) * (L + kappa) - L;
t      = sqrt(L + lambda);

W0m = lambda / (L + lambda);
W0c = lambda / (L + lambda) + (1 - alpha^2 + beta);
Wim = 1 / (2 * (L + lambda));
Wic = 1 / (2 * (L + lambda));

Wm = [W0m; repmat(Wim, 2 * L, 1)]; % (2L+1) x 1
Wc = [W0c; repmat(Wic, 2 * L, 1)]; % (2L+1) x 1

%% Sigma Points Chi: [0, +t*S, -t*S] (Eq. 5)
Chi = [zeros(L, 1), t * Sk, -t * Sk]; % L x (2*L+1)
end
