function g = Gravity_WGS84(lat_deg) %#codegen
% GRAVITY_WGS84 Computes normal gravity using Somigliana model on WGS-84.
wgs84 = WGS84_Constants();
s2 = sind(lat_deg).^2;
g  = wgs84.g0_eq .* (1 + wgs84.k_somig .* s2) ./ sqrt(1 - wgs84.e2 .* s2);
end
