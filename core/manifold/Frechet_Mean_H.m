function h = Frechet_Mean_H(W, H, alpha, L) %#codegen
%% FRECHET_MEAN_H Frechet mean of measurement sigma points on Lie Group H = T(3)
% Reference: Giorgio M. Magalhaes et al. (CBA 2018), Eq. 32 & 46

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