function C = DCM_ECEF_To_NED(lat_deg, lon_deg, varargin) %#codegen
% DCM_ECEF_TO_NED Computes direction cosine matrix from navigation to ECEF frame.
if nargin == 2
    frame = 'NED';
else
    frame = varargin{end};
end
switch frame
    case 'NED'
        C = [-sind(lat_deg)*cosd(lon_deg), -sind(lon_deg), -cosd(lat_deg)*cosd(lon_deg); ...
             -sind(lat_deg)*sind(lon_deg),  cosd(lon_deg), -cosd(lat_deg)*sind(lon_deg); ...
              cosd(lat_deg),                0,             -sind(lat_deg)];
    case 'ENU'
        C = 0; % Deferred per Problem #33*
    otherwise
        C = [-sind(lat_deg)*cosd(lon_deg), -sind(lon_deg), -cosd(lat_deg)*cosd(lon_deg); ...
             -sind(lat_deg)*sind(lon_deg),  cosd(lon_deg), -cosd(lat_deg)*sind(lon_deg); ...
              cosd(lat_deg),                0,             -sind(lat_deg)];
end
end
