function Plot_Filter_Diagnostics(time, gps_time, hx, trP, euler, y, ref, Cen, leverarm, filterName, trajectoryName)
% PLOT_FILTER_DIAGNOSTICS Modular plotting utility generating standard diagnostic figures.
% Supports both single-filter inputs and multi-filter cell array inputs on the same dataset,
% combining all filters running on the same trajectory into a single set of figures.
%
% Inputs:
%   time           - IMU time vector (Nx1)
%   gps_time       - GNSS time vector (Mx1)
%   hx             - 13x13xN state trajectory tensor, or 1xK cell array of tensors
%   trP            - Trace of covariance array (1xN), or 1xK cell array of arrays
%   euler          - Euler angles in NED frame (3xN) in degrees, or 1xK cell array
%   y              - GNSS measurement positions (3xM)
%   ref            - Ground truth reference struct (optional/empty if unavailable)
%   Cen            - Direction cosine matrix from NED to ECEF (3x3)
%   leverarm       - Antenna lever arm vector (3x1)
%   filterName     - Filter name string or cell/string array of names (e.g. {'EKF_Lie', 'UKF_Lie'})
%   trajectoryName - Trajectory identifier string (e.g. 'helicoidal')

if ~iscell(hx), hx = {hx}; end
if ~iscell(trP), trP = {trP}; end
if ~iscell(euler), euler = {euler}; end
numFilters = numel(hx);

if nargin < 10 || isempty(filterName)
    if numFilters == 1
        filterNames = {'Filter'};
    else
        filterNames = arrayfun(@(k) sprintf('Filter %d', k), 1:numFilters, 'UniformOutput', false);
    end
elseif ischar(filterName) || (isstring(filterName) && isscalar(filterName))
    filterNames = {char(filterName)};
elseif isstring(filterName)
    filterNames = cellstr(filterName(:)');
else
    filterNames = filterName(:)';
end

if nargin < 11 || isempty(trajectoryName)
    trajectoryName = '';
else
    trajectoryName = char(trajectoryName);
end

if numFilters == 1
    filtLabel = filterNames{1};
elseif numFilters == 2
    filtLabel = sprintf('%s and %s', filterNames{1}, filterNames{2});
else
    filtLabel = sprintf('%s and %s', strjoin(filterNames(1:end-1), ', '), filterNames{end});
end

if ~isempty(trajectoryName)
    runTitle = sprintf('%s on %s', filtLabel, trajectoryName);
else
    runTitle = filtLabel;
end

pos_all       = cell(1, numFilters);
acc_bias_all  = cell(1, numFilters);
gyro_bias_all = cell(1, numFilters);
for k = 1:numFilters
    [pos_all{k}, ~, ~, acc_bias_all{k}, gyro_bias_all{k}] = Extract_Lie_States(hx{k});
end

hasRef = (nargin >= 7) && ~isempty(ref) && isstruct(ref);

%% 1. Trace of Covariance
figure('Name', sprintf('%s - Trace P', runTitle));
hold on;
for k = 1:numFilters
    plot(time, trP{k}, 'LineWidth', 1.2, 'DisplayName', filterNames{k});
end
grid on;
title(sprintf('%s: Trace of Error Covariance P', runTitle), 'Interpreter', 'none');
xlabel('Time (s)'); ylabel('tr(P)');
legend('Location', 'best', 'Interpreter', 'none');

%% 2. Position ECEF
if hasRef
    Plot_Position_ECEF(pos_all, y, ref, filterNames, runTitle);
end

%% 3. Position NED & Height Profile
if hasRef
    Plot_Position_NED(pos_all, y, ref, time, gps_time, leverarm, euler, filterNames, runTitle);
end

%% 4. Euler Angles (NED Frame)
Plot_Euler_Angles(euler, ref, time, filterNames, runTitle);

%% 5. Sensor Biases
accLabels = {'b_{ax} (m/s^2)', 'b_{ay} (m/s^2)', 'b_{az} (m/s^2)'};
figure('Name', sprintf('%s - Accelerometer Biases', runTitle));
for i = 1:3
    subplot(3, 1, i);
    hold on;
    for k = 1:numFilters
        plot(time, acc_bias_all{k}(i, :), 'LineWidth', 1.2, 'DisplayName', filterNames{k});
    end
    if hasRef && isfield(ref, 'ba')
        yline(ref.ba(i), 'k--', 'LineWidth', 1, 'DisplayName', 'Truth');
    end
    grid on;
    ylabel(accLabels{i});
    legend('Location', 'best', 'Interpreter', 'none');
    if i == 1
        title(sprintf('%s: Accelerometer Bias Estimates', runTitle), 'Interpreter', 'none');
    end
end
xlabel('Time (s)');

gyroLabels = {'b_{gx} (rad/s)', 'b_{gy} (rad/s)', 'b_{gz} (rad/s)'};
figure('Name', sprintf('%s - Gyroscope Biases', runTitle));
for i = 1:3
    subplot(3, 1, i);
    hold on;
    for k = 1:numFilters
        plot(time, gyro_bias_all{k}(i, :), 'LineWidth', 1.2, 'DisplayName', filterNames{k});
    end
    if hasRef && isfield(ref, 'bg')
        yline(ref.bg(i), 'k--', 'LineWidth', 1, 'DisplayName', 'Truth');
    end
    grid on;
    ylabel(gyroLabels{i});
    legend('Location', 'best', 'Interpreter', 'none');
    if i == 1
        title(sprintf('%s: Gyroscope Bias Estimates', runTitle), 'Interpreter', 'none');
    end
end
xlabel('Time (s)');

end


