function pe = ECEF_From_LLA(lla) %#codegen
% ECEF_FROM_LLA Converts Geodetic LLA [lat(deg); lon(deg); alt(m)] to ECEF (m).
wgs84 = WGS84_Constants();
lat = lla(1, :);
lon = lla(2, :);
alt = lla(3, :);

Re = wgs84.a ./ sqrt(1 - wgs84.e2 .* (sind(lat).^2));
x  = (Re + alt) .* cosd(lat) .* cosd(lon);
y  = (Re + alt) .* cosd(lat) .* sind(lon);
z  = ((1 - wgs84.e2) .* Re + alt) .* sind(lat);
pe = [x; y; z];
end
