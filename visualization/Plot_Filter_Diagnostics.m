function Plot_Filter_Diagnostics(time, gps_time, hx, trP, euler, y, ref, Cen, leverarm, filterName, trajectoryName)
% PLOT_FILTER_DIAGNOSTICS Modular plotting utility generating standard diagnostic figures.
% Decouples visualization routines from core filter runners and execution scripts.
%
% Inputs:
%   time           - IMU time vector (Nx1)
%   gps_time       - GNSS time vector (Mx1)
%   hx             - 13x13xN state trajectory tensor
%   trP            - Trace of covariance array (1xN)
%   euler          - Euler angles in NED frame (3xN) in degrees
%   y              - GNSS measurement positions (3xM)
%   ref            - Ground truth reference struct (optional/empty if unavailable)
%   Cen            - Direction cosine matrix from NED to ECEF (3x3)
%   leverarm       - Antenna lever arm vector (3x1)
%   filterName     - Name string for figure titles (e.g. ''UKF_Lie'')
%   trajectoryName - Trajectory identifier string (e.g. ''rectangular'')

if nargin < 10 || isempty(filterName), filterName = 'Filter'; end
if nargin < 11 || isempty(trajectoryName), trajectoryName = ''; end

[pos, ~, ~, acc_bias, gyro_bias] = Extract_Lie_States(hx);

hasRef = (nargin >= 7) && ~isempty(ref) && isstruct(ref);

%% 1. Trace of Covariance
figure('Name', sprintf('%s - Trace P (%s)', filterName, trajectoryName));
plot(time, trP, 'LineWidth', 1.2);
grid on;
title(sprintf('%s: Trace of Error Covariance P', filterName));
xlabel('Time (s)'); ylabel('tr(P)');

%% 2. Position ECEF
if hasRef
    Plot_Position_ECEF(pos, y, ref);
end

%% 3. Position NED & Height Profile
if hasRef
    Plot_Position_NED(pos, y, ref, time, gps_time, leverarm, euler);
end

%% 4. Euler Angles (NED Frame)
if hasRef
    Plot_Euler_Angles(euler, ref, time);
else
    figure('Name', sprintf('%s - Euler Angles (%s)', filterName, trajectoryName));
    subplot(3,1,1); plot(time, euler(1,:)); grid on; ylabel('Roll (deg)');
    subplot(3,1,2); plot(time, euler(2,:)); grid on; ylabel('Pitch (deg)');
    subplot(3,1,3); plot(time, euler(3,:)); grid on; ylabel('Yaw (deg)');
    xlabel('Time (s)');
end

%% 5. Sensor Biases
figure('Name', sprintf('%s - Accelerometer Biases (%s)', filterName, trajectoryName));
plot(time, acc_bias', 'LineWidth', 1.2);
grid on;
title(sprintf('%s: Accelerometer Bias Estimates', filterName));
xlabel('Time (s)'); ylabel('m/s^2');
if hasRef && isfield(ref, 'ba')
    hold on;
    yline(ref.ba(1), 'k--', 'LineWidth', 1);
    yline(ref.ba(2), 'k--', 'LineWidth', 1);
    yline(ref.ba(3), 'k--', 'LineWidth', 1);
    legend('b_{ax}', 'b_{ay}', 'b_{az}', 'Truth', 'Location', 'best');
else
    legend('b_{ax}', 'b_{ay}', 'b_{az}', 'Location', 'best');
end

figure('Name', sprintf('%s - Gyroscope Biases (%s)', filterName, trajectoryName));
plot(time, gyro_bias', 'LineWidth', 1.2);
grid on;
title(sprintf('%s: Gyroscope Bias Estimates', filterName));
xlabel('Time (s)'); ylabel('rad/s');
if hasRef && isfield(ref, 'bg')
    hold on;
    yline(ref.bg(1), 'k--', 'LineWidth', 1);
    yline(ref.bg(2), 'k--', 'LineWidth', 1);
    yline(ref.bg(3), 'k--', 'LineWidth', 1);
    legend('b_{gx}', 'b_{gy}', 'b_{gz}', 'Truth', 'Location', 'best');
else
    legend('b_{gx}', 'b_{gy}', 'b_{gz}', 'Location', 'best');
end

end

