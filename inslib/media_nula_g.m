function g=media_nula_g(W,G,alpha,L)
%% equação 32 das notas de UKF-Lie
% Optimized: vectorised inner sum + single LU-solve for inverse.

g=G(:,:,1);
N_max=30;
n2L1=2*L+1;
alpha2=alpha^2;

for k=1:N_max
    % LU-factorize once; use to solve g\G_t(:,:,i) for all i
    [Lg,Ug,Pg] = lu(g);
    soma=zeros(15,1);
    for i=1:n2L1
        % g\G(:,:,i) via precomputed LU  (avoids extra factorisation)
        Gi_rel = Ug\(Lg\(Pg*G(:,:,i)));
        soma = soma + alpha2*W(i)*log_multiSE23T6(Gi_rel);
    end
    aux = g;
    g   = g*exp_multiSE23T6(soma);
    % Convergence: use the soma norm (already computed) as proxy
    if norm(soma) < 1e-3
        break;
    end
end

end