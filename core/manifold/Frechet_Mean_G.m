function g = Frechet_Mean_G(W, G, alpha, L) %#codegen
%% FRECHET_MEAN_G Iterative Frechet mean of state sigma points on Lie Group G = SE_2(3) x T(6)
% Reference: Giorgio M. Magalhaes et al. (CBA 2018), Eq. 32

g = G(:, :, 1);
N_max = 30;
n2L1 = 2 * L + 1;
alpha2 = alpha^2;

for k = 1:N_max
    [Lg, Ug, Pg] = lu(g);
    soma = zeros(15, 1);
    for i = 1:n2L1
        Gi_rel = Ug \ (Lg \ (Pg * G(:, :, i)));
        soma = soma + alpha2 * W(i) * Log_Multi_SE23T6(Gi_rel);
    end
    g = g * Exp_Multi_SE23T6(soma);
    
    if norm(soma) < 1e-3
        break;
    end
end
end