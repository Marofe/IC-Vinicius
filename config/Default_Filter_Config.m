function cfg = Default_Filter_Config()
% DEFAULT_FILTER_CONFIG Centralized filter parameters, noise characteristics,
% initial state covariances, and Unscented Transform tuning values.
%
% Outputs:
%   cfg - Struct with fields: dim, noise, cov, ut, leverarm
%
% References:
%   - Giorgio M. Magalhaes et al., CBA 2018 (UKF-Lie)
%   - Bourmaud et al., 2013 (EKF-Lie)
%   - Menegaz et al., IEEE TAC 2015

%% 1. Dimension Constants
cfg.dim.p             = 15;        % Process Lie algebra error state dimension (dtheta, dv, dp, dba, dbg)
cfg.dim.q             = 3;         % Measurement Lie algebra dimension (GNSS position in ECEF)
cfg.dim.n             = 13;        % Homogeneous state matrix dimension on SE_2(3) x R^6
cfg.dim.L             = 2*cfg.dim.p + cfg.dim.q; % L = 33 (augmented UKF dimension)
cfg.dim.N_sigma_ukf   = 2*cfg.dim.L + 1;         % 67 sigma points for full UKF-Lie
cfg.dim.N_sigma_spukf = 2*cfg.dim.p + 1;         % 31 sigma points for SPUKF-Lie

%% 2. Sensor Continuous Noise Spectral Densities / Discrete Standard Deviations
% Physical units:
% Accelerometer white noise:        sigma_acc [ (m/s^2) / sqrt(Hz) ]
% Velocity pseudo-noise:            sigma_vel [ (m/s) / sqrt(Hz) ]
% Gyroscope white noise:            sigma_gyr [ (rad/s) / sqrt(Hz) ]
% Accelerometer bias random walk:   sigma_ba  [ (m/s^3) / sqrt(Hz) ]
% Gyroscope bias random walk:       sigma_bg  [ (rad/s^2) / sqrt(Hz) ]
% GNSS position accuracy:           sigma_gnss [ m ] (1 cm 1-sigma standard)
cfg.noise.sigma_acc  = 1e-9 * ones(3, 1);
cfg.noise.sigma_vel  = 1e-3 * ones(3, 1);
cfg.noise.sigma_gyr  = 1e-6 * ones(3, 1);
cfg.noise.sigma_ba   = 1e-9 * ones(3, 1);
cfg.noise.sigma_bg   = 1e-9 * ones(3, 1);
cfg.noise.sigma_gnss = 1e-2 * ones(3, 1);

%% 3. Filter Process & Measurement Covariances
% Process noise covariance matrix Pqq (15x15) ordering:
% [gyroscope (3x3), accelerometer (3x3), velocity (3x3), acc bias (3x3), gyro bias (3x3)]
cfg.cov.Pqq = blkdiag(diag(cfg.noise.sigma_gyr.^2), ...
                      diag(cfg.noise.sigma_acc.^2), ...
                      diag(cfg.noise.sigma_vel.^2), ...
                      diag(cfg.noise.sigma_ba.^2), ...
                      diag(cfg.noise.sigma_bg.^2));

% Measurement noise covariance matrix Prr (3x3):
% GNSS position measurement variance in ECEF frame [ m^2 ]
cfg.cov.Prr = diag(cfg.noise.sigma_gnss.^2);

%% 4. Initial State Error Covariance P0 (15x15)
% Physical units and standard deviations for all 15 error state variances:
%
% State 1:3   (delta_theta - Attitude error about ECEF axes):
%             Variance = 1e-6 rad^2        (sigma_theta0 = 1.0 mrad = 0.0573 deg)
% State 4:6   (delta_v     - Velocity error in ECEF frame):
%             Variance = 1e-9 (m/s)^2      (sigma_v0 = 31.6 um/s)
% State 7:9   (delta_p     - Position error in ECEF frame):
%             Variance = 1e-6 m^2          (sigma_p0 = 1.0 mm)
% State 10:12 (delta_ba    - Accelerometer bias error):
%             Variance = 1e-6 (m/s^2)^2    (sigma_ba0 = 1.0 mm/s^2)
% State 13:15 (delta_bg    - Gyroscope bias error):
%             Variance = 1e-9 (rad/s)^2    (sigma_bg0 = 31.6 urad/s)
cfg.cov.P0 = diag([1e-6, 1e-6, 1e-6, ...
                   1e-9, 1e-9, 1e-9, ...
                   1e-6, 1e-6, 1e-6, ...
                   1e-6, 1e-6, 1e-6, ...
                   1e-9, 1e-9, 1e-9]);

%% 5. Unscented Transform Tuning Parameters
cfg.ut.alpha_opt = 0.0140; % UKF-Lie optimal spread parameter
cfg.ut.beta      = 2;      % Optimal for Gaussian prior distributions
cfg.ut.kappa     = 0;      % Secondary scaling parameter

%% 6. Hardware Mounting / Lever Arm Vector
% Body-to-antenna lever arm vector in body frame [ m ]
cfg.leverarm = [0.040; -0.139; -0.439];

end
