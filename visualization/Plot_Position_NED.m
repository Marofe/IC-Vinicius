function Plot_Position_NED(pe, gnss_or_ref, ref_or_Cen, time, gps_time, lb, euler, filterNames, runTitle)
% PLOT_POSITION_NED Vectorized conversion and plotting of trajectory in local NED frame (#41).
% Pure function (zero in-place mutation of inputs) with vectorized geodetic conversions.
%
% Supports calling conventions:
%   Plot_Position_NED(pe, gnss, ref, time, gps_time, lb, euler)
%   Plot_Position_NED(pe, gnss, ref, time, gps_time, lb, euler, filterNames, runTitle)
%   Plot_Position_NED(pe, ref_pe, Cen)

if nargin == 3
    ref_pe = gnss_or_ref;
    Cen    = ref_or_Cen;
    pe0    = ref_pe(1, :)';
    if iscell(pe), pe = pe{1}; end
    pos_ned = Cen' * (pe - pe0);
    ref_ned = (Cen' * (ref_pe' - pe0))';

    figure('Name', 'Position in NED Frame (3D)');
    plot3(pos_ned(1, :), pos_ned(2, :), pos_ned(3, :), 'r', 'LineWidth', 1.5);
    hold on;
    plot3(ref_ned(:, 1), ref_ned(:, 2), ref_ned(:, 3), 'b--', 'LineWidth', 1.5);
    grid on;
    xlabel('North (m)');
    ylabel('East (m)');
    zlabel('Down (m)');
    legend('Estimated', 'Reference', 'Location', 'best', 'Interpreter', 'none');
    title('Position in NED Frame', 'Interpreter', 'none');
    return;
end

if ~iscell(pe)
    pe = {pe};
end
if ~iscell(euler)
    euler = {euler};
end
numFilters = numel(pe);

if nargin < 8 || isempty(filterNames)
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

if nargin < 9 || isempty(runTitle)
    figName3D   = 'Position in NED frame (3D)';
    plotTitle3D = 'Position in NED frame (3D)';
    figName2D   = 'Position in NED frame (2D)';
    plotTitle2D = 'Position in NED frame (2D)';
    figNameH    = 'Height Profile';
    plotTitleH  = 'Height Profile';
else
    figName3D   = sprintf('%s - Position in NED frame (3D)', runTitle);
    plotTitle3D = sprintf('%s: Position in NED frame (3D)', runTitle);
    figName2D   = sprintf('%s - Position in NED frame (2D)', runTitle);
    plotTitle2D = sprintf('%s: Position in NED frame (2D)', runTitle);
    figNameH    = sprintf('%s - Height Profile', runTitle);
    plotTitleH  = sprintf('%s: Height Profile', runTitle);
end

gnss = gnss_or_ref;
ref  = ref_or_Cen;

p0   = gnss(:, 1);
lla0 = Single_LLA_From_ECEF(p0);
Cen0 = DCM_ECEF_To_NED(lla0(1), lla0(2));

% Vectorized lever-arm compensation for ground-truth reference (N_ref x 3)
ref_euler_ned = Euler_ENU_To_NED(ref.euler)'; % 3 x N_ref [roll; pitch; yaw]
ref_pe_T      = ref.pe';                      % 3 x N_ref
lla_ref       = Single_LLA_From_ECEF(ref_pe_T);
ref_pe_comp   = compensate_leverarm_vec(ref_pe_T, flip(ref_euler_ned, 1), lla_ref, lb);

% Convert reference and GNSS from ECEF to local NED relative to p0
ned_ref = Cen0' * (ref_pe_comp - p0);
ned_gps = Cen0' * (gnss - p0);

xn = ned_ref(1, :); ye = ned_ref(2, :); zd = ned_ref(3, :);
gps_n = ned_gps(1, :); gps_e = ned_gps(2, :); gps_d = ned_gps(3, :);

% Vectorized lever-arm compensation and NED conversion for each filter
ned_sol = cell(1, numFilters);
for k = 1:numFilters
    lla_sol    = Single_LLA_From_ECEF(pe{k});
    pe_comp    = compensate_leverarm_vec(pe{k}, euler{k}, lla_sol, lb);
    ned_sol{k} = Cen0' * (pe_comp - p0);
end

%% Plot 3D NED
figure('Name', figName3D);
plot3(xn, ye, -zd, '.', 'LineWidth', 2, 'DisplayName', 'Ground Truth');
hold on;
for k = 1:numFilters
    plot3(ned_sol{k}(1, :), ned_sol{k}(2, :), -ned_sol{k}(3, :), '.', 'LineWidth', 2, 'DisplayName', filterNames{k});
end
plot3(gps_n, gps_e, -gps_d, 'ro', 'LineWidth', 2, 'DisplayName', 'GNSS');
grid on;
title(plotTitle3D, 'Interpreter', 'none');
legend('Location', 'best', 'Interpreter', 'none');
xlabel('N (m)');
ylabel('E (m)');
zlabel('-D (m)');

%% Plot 2D NED
figure('Name', figName2D);
plot(xn, ye, '.', 'LineWidth', 2, 'DisplayName', 'Ground Truth');
hold on;
for k = 1:numFilters
    plot(ned_sol{k}(1, :), ned_sol{k}(2, :), '.', 'LineWidth', 2, 'DisplayName', filterNames{k});
end
plot(gps_n, gps_e, 'ro', 'LineWidth', 2, 'DisplayName', 'GNSS');
grid on;
title(plotTitle2D, 'Interpreter', 'none');
legend('Location', 'best', 'Interpreter', 'none');
xlabel('N (m)');
ylabel('E (m)');

%% Plot Height Profile
figure('Name', figNameH);
plot(ref.time, -zd, '.', 'LineWidth', 2, 'DisplayName', 'Ground Truth');
hold on;
for k = 1:numFilters
    plot(time, -ned_sol{k}(3, :), '.', 'LineWidth', 2, 'DisplayName', filterNames{k});
end
plot(gps_time, -gps_d, 'ro', 'LineWidth', 2, 'DisplayName', 'GNSS');
legend('Location', 'best', 'Interpreter', 'none');
title(plotTitleH, 'Interpreter', 'none');
xlabel('Time (s)');
ylabel('Height (m)');
grid on;
end

function pe_out = compensate_leverarm_vec(pe_in, euler_deg, lla, lb)
% Vectorized evaluation of pe_out(:,k) = pe_in(:,k) + DCM_ECEF_To_NED(lat_k,lon_k) * Rotm_Euler_Deg(flip(euler(:,k)),'ZYX')' * lb
roll  = euler_deg(1, :);
pitch = euler_deg(2, :);
yaw   = euler_deg(3, :);

cr = cosd(roll); sr = sind(roll);
cp = cosd(pitch); sp = sind(pitch);
cy = cosd(yaw); sy = sind(yaw);

% Cbn rows (where Cnb = Cbn')
C11 = cp .* cy;
C12 = cp .* sy;
C13 = -sp;
C21 = -cr .* sy + sr .* sp .* cy;
C22 =  cr .* cy + sr .* sp .* sy;
C23 =  sr .* cp;
C31 =  sr .* sy + cr .* sp .* cy;
C32 = -sr .* cy + cr .* sp .* sy;
C33 =  cr .* cp;

% v_ned = Cnb * lb = Cbn' * lb
vn = C11 * lb(1) + C21 * lb(2) + C31 * lb(3);
ve = C12 * lb(1) + C22 * lb(2) + C32 * lb(3);
vd = C13 * lb(1) + C23 * lb(2) + C33 * lb(3);

% Cen * v_ned
lat = lla(1, :);
lon = lla(2, :);
slat = sind(lat); clat = cosd(lat);
slon = sind(lon); clon = cosd(lon);

dx = -slat .* clon .* vn - slon .* ve - clat .* clon .* vd;
dy = -slat .* slon .* vn + clon .* ve - clat .* slon .* vd;
dz =  clat .* vn                      - slat .* vd;

pe_out = pe_in + [dx; dy; dz];
end
