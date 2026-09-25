function [hx, P] = predction_ekf_quat(hx0, P0, u, Q, dt, n)
% PREDCTION_EKF_QUAT Legacy misspelled alias for Prediction_EKF_Quat.
% Deprecated: Use Prediction_EKF_Quat instead (Problem #21 fix).

[hx, P] = Prediction_EKF_Quat(hx0, P0, u, Q, dt, n);
end
