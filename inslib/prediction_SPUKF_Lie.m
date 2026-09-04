function [hx_pred, P_pred] = prediction_SPUKF_Lie(hx0, P0, u, Q, dt, alpha, beta, kappa, ~) %#codegen
    L = size(P0, 1);
    lambda = alpha^2 * (L + kappa) - L;
    
    % 1. Single Mean Propagation
    [omeg, gn, Cen] = Omega(hx0, u);
    omegk = omeg * dt;
    hx_pred = hx0 * exp_multiSE23T6(omegk);
    
    % 2. First-Order Jacobian Extraction
    Phi = phi(omegk);
    C = matriz_C_se23T6(hx_pred, u, gn, Cen, dt);
    F_jacobian = Ad_G(exp_multiSE23T6(-omegk)) + Phi * C;
    
    % 3. Sigma Point Generation (Pre-Propagation)
    P0_sym = (P0 + P0') / 2;
    P_scaled = (L + lambda) * P0_sym;
    [S, p_flag] = chol(P_scaled, 'lower');
    if p_flag ~= 0
        P_scaled = P_scaled + eye(L) * 1e-7;
        S = chol(P_scaled, 'lower');
    end
    
    xi_0 = zeros(L, 2*L+1);
    for i = 1:L
        xi_0(:, i+1)   =  S(:, i);
        xi_0(:, i+L+1) = -S(:, i);
    end
    
    % 4. Taylor-Series Projection (Biswas SPUKF Strategy)
    % xi_pred = e^(F * dt) * xi_0   (Linear projection of Lie algebra error)
    expm_F = F_jacobian;
    
    Wc = [lambda/(L+lambda)+(1-alpha^2+beta); repmat(1/(2*(L+lambda)), 2*L, 1)];
    P_pred = Q; % Add process noise directly
    
    for i = 1:(2*L+1)
        if i == 1
            xi_pred = zeros(L, 1);
        else
            xi_pred = expm_F * xi_0(:, i);
        end
        % Reconstruct Covariance from approximated sigma points
        P_pred = P_pred + Wc(i) * (xi_pred * xi_pred');
    end
    
    P_pred = (P_pred + P_pred') / 2;
end
