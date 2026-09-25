function [Phh, Pgh] = Lie_Covariances(g_pred, h_pred, G_pred, H_pred, Wc, Prr, L) %#codegen
%% LIE_COVARIANCES Compute innovation covariance Phh and cross-covariance Pgh on Lie Groups
% Reference: Giorgio M. Magalhaes et al. (CBA 2018), Eq. 47 & 48

p    = 15;
n2L1 = 2 * L + 1;

eps_meas = reshape(H_pred(1:3, 4, :), 3, n2L1) - h_pred(1:3, 4);

eps_state = zeros(p, n2L1);
[Lg, Ug, Pg] = lu(g_pred);
for k = 1:n2L1
    eps_state(:, k) = Log_Multi_SE23T6(Ug \ (Lg \ (Pg * G_pred(:, :, k))));
end

Wc_row = reshape(Wc, 1, n2L1);
Phh    = (eps_meas .* Wc_row) * eps_meas' + Prr;
Pgh    = (eps_state .* Wc_row) * eps_meas';
end