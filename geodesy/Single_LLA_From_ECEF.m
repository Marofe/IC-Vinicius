function lla = Single_LLA_From_ECEF(pe) %#codegen
% SINGLE_LLA_FROM_ECEF Converts ECEF coordinates (3x1 or 3xN) to Geodetic LLA.
% Vectorized across N columns using centralized WGS-84 constants.
%
% Inputs:
%   pe  - ECEF position vector(s) [x; y; z] in meters (3x1 or 3xN)
% Outputs:
%   lla - [lat (deg); lon (deg); alt (m)] (3x1 or 3xN)

wgs84 = WGS84_Constants();
a   = wgs84.a;
b   = wgs84.b;
e2  = wgs84.e2;
ep2 = wgs84.ep2;

x = pe(1, :);
y = pe(2, :);
z = pe(3, :);

p     = hypot(x, y);
theta = atan2(z .* a, p .* b);

lon = atan2(y, x);
lat = atan2(z + ep2 .* b .* (sin(theta).^3), p - e2 .* a .* (cos(theta).^3));

sin_lat = sin(lat);
N_rad   = a ./ sqrt(1 - e2 .* (sin_lat.^2));
alt     = (p ./ cos(lat)) - N_rad;

lla = [rad2deg(lat); rad2deg(lon); alt];
end
