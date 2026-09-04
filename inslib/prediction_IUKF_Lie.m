function [hx,P] = prediction_IUKF_Lie(hx0, P0, u, Q, dt) %#codegen
% PREDICTION_IUKF_Lie
% Analytical state and covariance propagation on Lie Groups (Brossard 2018).

    %% State Prediction
    [omeg, gn, Cen] = Omega(hx0, u);               
    omegk = omeg * dt;
    hx = hx0 * exp_multiSE23T6(omegk);         

    %% Covariance Prediction 
    Phi = phi(omegk);
    C = matriz_C_se23T6(hx, u, gn, Cen, dt);  
    
    % F matrix (Jacobian of the system on the Lie Algebra)
    F = Ad_G(exp_multiSE23T6(-omegk)) + Phi * C; 
    
    Qk = Q;
    P = F * P0 * F' + Phi * Qk * Phi';
    
    % Force symmetry
    P = (P + P') / 2;
end
