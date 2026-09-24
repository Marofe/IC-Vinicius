function [Phh, Pgh] = covariancias(g_pred, h_pred, G_pred, H_pred, Wc, Prr, L)
%% COVARIANCIAS (Legacy Portuguese Alias -> lie_covariances)
% Retained for backwards compatibility with existing MEX and scripts.
[Phh, Pgh] = lie_covariances(g_pred, h_pred, G_pred, H_pred, Wc, Prr, L);
end