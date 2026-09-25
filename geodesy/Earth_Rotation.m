function wie_n = Earth_Rotation(lat_deg, frame) %#codegen
% EARTH_ROTATION Computes Earth rotation vector in local navigation frame.
if nargin < 2
    frame = 'NED';
end
wgs84 = WGS84_Constants();
W = wgs84.omega_ie;
switch frame
    case 'ENU'
        wie_n = [0; W * cosd(lat_deg); W * sind(lat_deg)];
    case 'NED'
        wie_n = [W * cosd(lat_deg); 0; -W * sind(lat_deg)];
    otherwise
        wie_n = [W * cosd(lat_deg); 0; -W * sind(lat_deg)];
end
end
