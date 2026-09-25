function Plot_Euler_Angles(euler, ref, time, filterNames, runTitle)
% PLOT_EULER_ANGLES Plots estimated Euler angles vs ground-truth reference in NED frame.
% Supports a single filter (3xN numeric array) or multiple filters (cell array of 3xN arrays).

if ~iscell(euler)
    euler = {euler};
end
numFilters = numel(euler);

if nargin < 4 || isempty(filterNames)
    if numFilters == 1
        filterNames = {'Solution'};
    else
        filterNames = arrayfun(@(k) sprintf('Filter %d', k), 1:numFilters, 'UniformOutput', false);
    end
elseif ischar(filterNames) || (isstring(filterNames) && isscalar(filterNames))
    filterNames = {char(filterNames)};
elseif isstring(filterNames)
    filterNames = cellstr(filterNames(:)');
end

if nargin < 5 || isempty(runTitle)
    figName   = 'Euler Angles (NED frame)';
    plotTitle = 'Euler Angles (NED frame)';
else
    figName   = sprintf('%s - Euler Angles (NED frame)', runTitle);
    plotTitle = sprintf('%s: Euler Angles (NED frame)', runTitle);
end

hasRef = (nargin >= 2) && ~isempty(ref) && isstruct(ref) && isfield(ref, 'euler');
if hasRef
    ref_euler = Euler_ENU_To_NED(ref.euler);
end

angleLabels = {'Roll (deg)', 'Pitch (deg)', 'Yaw (deg)'};
figure('Name', figName);
for i = 1:3
    subplot(3, 1, i);
    hold on;
    for k = 1:numFilters
        plot(time, euler{k}(i, :), 'LineWidth', 1.2, 'DisplayName', filterNames{k});
    end
    if hasRef
        plot(ref.time, ref_euler(:, i), 'k--', 'LineWidth', 1.2, 'DisplayName', 'Ground Truth');
    end
    grid on;
    ylabel(angleLabels{i});
    legend('Location', 'best', 'Interpreter', 'none');
    if i == 1
        title(plotTitle, 'Interpreter', 'none');
    end
end
xlabel('Time (s)');
end
