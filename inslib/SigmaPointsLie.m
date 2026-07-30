function [Xi,Wm,Wc]=SigmaPointsLie(Eta,alpha,beta,kappa,P_t,Pqq,Prr,L)
%% 
% Eta=[eps q r]
%                               [ P_t-1|t-1
% Matriz de Covariancia P =                Pqq                  
%                                               Prr ]   dimensão =  2*p+q
%
% Sigma Points Xi(i) = [E(i) Q(i) R(i)] dimensão = (2*p+q)x1 = 21x1
%% matriz de covariancia eta ~N(0 , blkdiag(Pt,Pqq,Prr) )
% Build block-diagonal P without calling blkdiag (saves allocation overhead)
p15 = size(P_t,1);  % 15
pqq = size(Pqq,1);  % 15
prr = size(Prr,1);  % 3
P   = zeros(L,L);
P(1:p15,         1:p15        ) = P_t;
P(p15+1:p15+pqq, p15+1:p15+pqq) = Pqq;
P(p15+pqq+1:end, p15+pqq+1:end) = Prr;
P   = 0.5*(P+P.');  % force symmetry

%% Replace eig() check with faster chol() attempt
[sqrP, flag] = chol(P);
if flag ~= 0
    % Not PD: regularise with smallest diagonal dominance shift
    minEig = min(eig(P));  % only called if chol fails (rare)
    P = P + eye(L)*abs(minEig*2 + 1e-14);
    sqrP = chol(P)';
else
    sqrP = sqrP';  % chol returns upper-tri; we need lower-tri
end

%%
lambda=(alpha^2)*(L+kappa)-L; 
%% pesos
Wm=[lambda/(lambda+L) ones(1,2*L)*(1/(2*(lambda+L)))]';
Wc=[lambda/(lambda+L)+(1-alpha^2+beta) ones(1,2*L)*(1/(2*(lambda+L)))]';
%% raiz de P e L+lambda
t=sqrt(L+lambda);
Xi=[Eta Eta+t*sqrP Eta-t*sqrP]; % (2*p+q , 2*L+1)


end