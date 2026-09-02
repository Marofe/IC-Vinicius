function [hx_upd, P_upd, G_upd] = update_EnKF_Lie(hx_pred, P_pred, G_ensemble, Wm, Wc, Prr, y_meas, leverarm, L) %#codegen
% UPDATE_ENKF_LIE
% Executes the measurement update for the Ensemble Kalman Filter on Lie Groups (EnKF-Lie).
% Uses the propagated ensemble G_ensemble directly to compute measurement statistics
% and updates both the mean/covariance and each ensemble member via Kalman Gain.

%% 1. Map Ensemble to Measurement Space
n_pts = 2*L + 1;
Y = zeros(3, n_pts);

for i = 1:n_pts
    % Extract rotation matrix and position from each ensemble member
    Ceb_i = G_ensemble(1:3, 1:3, i);
    peb_i = G_ensemble(1:3, 5, i);
    
    % GNSS measurement model with lever arm: y = p + Ceb * leverarm
    Y(:, i) = peb_i + Ceb_i * leverarm;
end

%% 2. Compute Measurement Statistics
% Mean predicted measurement
y_bar = zeros(3, 1);
for i = 1:n_pts
    y_bar = y_bar + Wm(i) * Y(:, i);
end

% Compute Lie algebra error for each member relative to the predicted mean state
p_dim = 15;
xi = zeros(p_dim, n_pts);
[Lg, Ug, Pg] = lu(hx_pred);
for i = 1:n_pts
    xi(:, i) = log_multiSE23T6(Ug\(Lg\(Pg*G_ensemble(:,:,i))));
end

% Innovation covariance and cross-covariance
P_hh = Prr;
P_gh = zeros(p_dim, 3);
for i = 1:n_pts
    dy = Y(:, i) - y_bar;
    P_hh = P_hh + Wc(i) * (dy * dy');
    P_gh = P_gh + Wc(i) * (xi(:, i) * dy');
end

%% 3. Compute Kalman Gain and Update Mean State & Covariance
K = P_gh / P_hh; % (15x3)

% Innovation for the mean
innovation = y_meas - y_bar;

% Update mean state on the Lie group manifold
delta_x = K * innovation;
hx_upd = hx_pred * exp_multiSE23T6(delta_x);

% Update covariance
P_upd = P_pred - K * P_gh';
P_upd = (P_upd + P_upd') / 2;

%% 4. Update Ensemble Members
G_upd = zeros(13, 13, n_pts);
for i = 1:n_pts
    inn_i = y_meas - Y(:, i);
    delta_i = K * inn_i;
    G_upd(:,:,i) = G_ensemble(:,:,i) * exp_multiSE23T6(delta_i);
end

end
