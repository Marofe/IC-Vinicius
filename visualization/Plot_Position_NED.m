function Plot_Position_NED(pe, gnss_or_ref, ref_or_Cen, time, gps_time, lb, euler)
% PLOT_POSITION_NED Vectorized conversion and plotting of trajectory in local NED frame (#41).
% Pure function (zero in-place mutation of inputs) with vectorized geodetic conversions.
%
% Supports both calling conventions:
%   Plot_Position_NED(pe, gnss, ref, time, gps_time, lb, euler)
%   Plot_Position_NED(pe, ref_pe, Cen)

if nargin == 3
    ref_pe = gnss_or_ref;
    Cen    = ref_or_Cen;
    pe0     = ref_pe(1, :)';
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
    legend('Estimated', 'Reference', 'Location', 'best');
    title('Position in NED Frame');
    return;
end

gnss = gnss_or_ref;
ref  = ref_or_Cen;

p0   = gnss(:, 1);
lla0 = Single_LLA_From_ECEF(p0);
Cen0 = DCM_ECEF_To_NED(lla0(1), lla0(2));

% Vectorized lever-arm compensation for estimated trajectory (3xN)
lla_sol = Single_LLA_From_ECEF(pe);
pe_comp = compensate_leverarm_vec(pe, euler, lla_sol, lb);

% Vectorized lever-arm compensation for ground-truth reference (N_ref x 3)
ref_euler_ned = Euler_ENU_To_NED(ref.euler)'; % 3 x N_ref [roll; pitch; yaw]
ref_pe_T      = ref.pe';                      % 3 x N_ref
lla_ref       = Single_LLA_From_ECEF(ref_pe_T);
ref_pe_comp   = compensate_leverarm_vec(ref_pe_T, flip(ref_euler_ned, 1), lla_ref, lb);

% Convert ECEF to local NED relative to p0
ned_ref = Cen0' * (ref_pe_comp - p0);
ned_sol = Cen0' * (pe_comp - p0);
ned_gps = Cen0' * (gnss - p0);

xn = ned_ref(1, :); ye = ned_ref(2, :); zd = ned_ref(3, :);
n  = ned_sol(1, :); e  = ned_sol(2, :); d  = ned_sol(3, :);
gps_n = ned_gps(1, :); gps_e = ned_gps(2, :); gps_d = ned_gps(3, :);

%% Plot 3D NED
figure('Name', 'Position in NED frame (3D)');
plot3(xn, ye, -zd, '.', 'LineWidth', 2, 'DisplayName', 'Ground Truth');
hold on;
plot3(n, e, -d, '.', 'LineWidth', 2, 'DisplayName', 'Solution');
plot3(gps_n, gps_e, -gps_d, 'ro', 'LineWidth', 2, 'DisplayName', 'GNSS');
grid on;
title('Position in NED frame (3D)');
legend('Location', 'best');
xlabel('N (m)');
ylabel('E (m)');
zlabel('-D (m)');

%% Plot 2D NED
figure('Name', 'Position in NED frame (2D)');
plot(xn, ye, '.', 'LineWidth', 2, 'DisplayName', 'Ground Truth');
hold on;
plot(n, e, '.', 'LineWidth', 2, 'DisplayName', 'Solution');
plot(gps_n, gps_e, 'ro', 'LineWidth', 2, 'DisplayName', 'GNSS');
grid on;
title('Position in NED frame (2D)');
legend('Location', 'best');
xlabel('N (m)');
ylabel('E (m)');

%% Plot Height Profile
figure('Name', 'Height Profile');
plot(ref.time, -zd, '.', 'LineWidth', 2, 'DisplayName', 'Ground-truth');
hold on;
plot(time, -d, '.', 'LineWidth', 2, 'DisplayName', 'Solution');
plot(gps_time, -gps_d, 'ro', 'LineWidth', 2, 'DisplayName', 'GNSS');
legend('Location', 'best');
title('Height Profile');
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
