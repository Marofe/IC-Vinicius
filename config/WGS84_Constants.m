function wgs84 = WGS84_Constants() %#codegen
% WGS84_CONSTANTS Single source of truth for WGS-84 physical and geodetic constants.
%
% Outputs:
%   wgs84 - Struct containing standard WGS-84 ellipsoid and Earth rotation parameters

% 1. Calculate values with local variables
a        = 6378137.0;                         % Semi-major axis (Equatorial radius) [m]
f        = 1 / 298.257223563;                 % Flattening [-]
b        = a * (1 - f);                       % Semi-minor axis (Polar radius) [m]
e2       = f * (2 - f);                       % First eccentricity squared [-]
e        = sqrt(e2);                          % First eccentricity [-]
ep2      = (a^2 - b^2) / (b^2);               % Second eccentricity squared [-]
omega_ie = 7.2921151467e-5;                   % Earth rotation rate [rad/s]
g0_eq    = 9.7803253359;                      % Somigliana equatorial gravity [m/s^2]
k_somig  = 0.00193185265241;                  % Somigliana formula constant [-]

% 2. Populate structure fields without reading from the struct itself
wgs84.a        = a;
wgs84.f        = f;
wgs84.b        = b;
wgs84.e2       = e2;
wgs84.e        = e;
wgs84.ep2      = ep2;
wgs84.omega_ie = omega_ie;
wgs84.g0_eq    = g0_eq;
wgs84.k_somig  = k_somig;
end