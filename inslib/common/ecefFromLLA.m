function [x,y,z] = ecefFromLLA(lat,lon,alt)
%ECEFFROMLLA Summary of this function goes here
% input->lat,lon,alt in rad and meters
% output-> x,y,z in meters
R0=6.378137e6;
e=0.0818191908425;
RN=R0*(1-e^2)./((1-e^2*sind(lat).^2).^(1/2));
RE=R0./sqrt(1-e^2*sind(lat).^2);
x=(RE+alt).*cosd(lat).*cosd(lon);
y=(RE+alt).*cosd(lat).*sind(lon);
z=(RN+alt).*sind(lat);
end

