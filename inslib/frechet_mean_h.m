function h = frechet_mean_h(W, H, alpha, L)
%% FRECHET_MEAN_H Fréchet mean of measurement sigma points on Lie Group H = T(3)
% Reference: Giorgio M. Magalhães et al. (CBA 2018), Eq. 32 & 46
%
% Inputs:
%   W     - (2L+1)x1 weight vector (Wm)
%   H     - 4x4x(2L+1) array of transformed measurement sigma points
%   alpha - Scaling parameter for unscented transform
%   L     - Augmented state dimension (L = 33)
%
% Outputs:
%   h     - 4x4 Fréchet mean on measurement Lie group H

h = H(:, :, 1);
N_max = 30;
n2L1 = 2 * L + 1;
alpha2 = alpha^2;

for k = 1:N_max
    soma = zeros(3, 1);
    for i = 1:n2L1
        soma = soma + alpha2 * W(i) * (H(1:3, 4, i) - h(1:3, 4));
    end
    h = [eye(3), h(1:3, 4) + soma; zeros(1, 3), 1];
    if norm(soma) < 1e-3
        break;
    end
end

end
