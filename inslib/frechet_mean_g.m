function g = frechet_mean_g(W, G, alpha, L)
%% FRECHET_MEAN_G Iterative Fréchet mean of state sigma points on Lie Group G = SE_2(3) x T(6)
% Reference: Giorgio M. Magalhães et al. (CBA 2018), Eq. 32
%
% Inputs:
%   W     - (2L+1)x1 weight vector (Wm)
%   G     - 13x13x(2L+1) array of transformed sigma points on group G
%   alpha - Scaling parameter for unscented transform
%   L     - Augmented state dimension (L = 33)
%
% Outputs:
%   g     - 13x13 Fréchet mean on Lie group G

g = G(:, :, 1);
N_max = 30;
n2L1 = 2 * L + 1;
alpha2 = alpha^2;

for k = 1:N_max
    % Precompute LU factorization of current mean candidate once
    [Lg, Ug, Pg] = lu(g);
    soma = zeros(15, 1);
    for i = 1:n2L1
        % Solve g \ G(:,:,i) via precomputed LU factorisation
        Gi_rel = Ug \ (Lg \ (Pg * G(:, :, i)));
        soma = soma + alpha2 * W(i) * log_multiSE23T6(Gi_rel);
    end
    g = g * exp_multiSE23T6(soma);
    
    % Convergence criterion
    if norm(soma) < 1e-3
        break;
    end
end

end
