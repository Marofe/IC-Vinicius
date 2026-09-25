function Plot_Position_ECEF(pe, gnss, ref, filterNames, runTitle)
% PLOT_POSITION_ECEF Plots 3D trajectory, GNSS measurements, and ground truth in ECEF frame.
% Supports a single filter trajectory (3xN numeric array) or multiple filters (cell array of 3xN arrays).

if ~iscell(pe)
    pe = {pe};
end
numFilters = numel(pe);

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
    figName   = 'Position in ECEF frame';
    plotTitle = 'Position in ECEF frame';
else
    figName   = sprintf('%s - Position in ECEF frame', runTitle);
    plotTitle = sprintf('%s: Position in ECEF frame', runTitle);
end

figure('Name', figName);
plot3(ref.pe(:, 1), ref.pe(:, 2), ref.pe(:, 3), '.', 'LineWidth', 2, 'DisplayName', 'Ground Truth');
hold on;
for k = 1:numFilters
    plot3(pe{k}(1, :), pe{k}(2, :), pe{k}(3, :), '.', 'LineWidth', 2, 'DisplayName', filterNames{k});
end
plot3(gnss(1, :), gnss(2, :), gnss(3, :), 'or', 'LineWidth', 2, 'DisplayName', 'GNSS');
grid on;
title(plotTitle, 'Interpreter', 'none');
legend('Location', 'best', 'Interpreter', 'none');
xlabel('x');
ylabel('y');
zlabel('z');
end
