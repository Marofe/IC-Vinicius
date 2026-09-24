function [Chi, Wm, Wc] = SigmaPointsLie(varargin)
%% SIGMAPOINTSLIE Augmented sigma points on Lie algebra
% Reference: Giorgio M. Magalhães et al. (CBA 2018), Eq. 5, 6, 40
%
% Calling formats:
%   [Chi, Wm, Wc] = SigmaPointsLie(alpha, beta, kappa, P_prev, Pqq, Prr, L)       (Standard 7-arg)
%   [Chi, Wm, Wc] = SigmaPointsLie(Eta, alpha, beta, kappa, P_prev, Pqq, Prr, L) (Legacy 8-arg)

if nargin == 7
    alpha  = varargin{1};
    beta   = varargin{2};
    kappa  = varargin{3};
    P_prev = varargin{4};
    Pqq    = varargin{5};
    Prr    = varargin{6};
    L      = varargin{7};
elseif nargin == 8
    % Eta is ignored because the mean tangent error is zero
    alpha  = varargin{2};
    beta   = varargin{3};
    kappa  = varargin{4};
    P_prev = varargin{5};
    Pqq    = varargin{6};
    Prr    = varargin{7};
    L      = varargin{8};
else
    error('SigmaPointsLie requires 7 or 8 arguments.');
end

p15 = size(P_prev, 1);
pqq = size(Pqq, 1);
prr = size(Prr, 1);

P = zeros(L, L);
P(1:p15, 1:p15)                 = P_prev;
P(p15+1:p15+pqq, p15+1:p15+pqq) = Pqq;
P(p15+pqq+1:end, p15+pqq+1:end) = Prr;
P = 0.5 * (P + P.'); % force numerical symmetry

%% Cholesky factor (lower-triangular)
[sqrP, flag] = chol(P, 'lower');
if flag ~= 0
    % Regularize if not strictly positive-definite
    minEig = min(eig(P));
    P_reg = P + eye(L) * abs(minEig * 2 + 1e-14);
    sqrP = chol(P_reg, 'lower');
end

%% Unscented Transform Parameters & Weights
lambda = (alpha^2) * (L + kappa) - L;
t = sqrt(L + lambda);

W0m = lambda / (L + lambda);
W0c = lambda / (L + lambda) + (1 - alpha^2 + beta);
Wim = 1 / (2 * (L + lambda));
Wic = 1 / (2 * (L + lambda));

Wm = [W0m; repmat(Wim, 2 * L, 1)]; % (2L+1) x 1
Wc = [W0c; repmat(Wic, 2 * L, 1)]; % (2L+1) x 1

%% Sigma Points Chi: [0, +t*S, -t*S]
Chi = [zeros(L, 1), t * sqrP, -t * sqrP]; % L x (2*L+1)

end