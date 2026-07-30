function D=nedCart2llad(L,h)
% Compute DCM from navigation NED to geodetic-ECEF frame
% input-> lat,h (rad,m)
% output-> Cen
R0=6378137;
ecc=0.0818191908425;
RN=R0*(1-ecc^2)/((1-ecc^2*sind(L)^2)^(3/2));
RE=R0/sqrt(1-ecc^2*sind(L)^2);
D=[1/(RN+h) 0 0;0 1/((RE+h)*cosd(L)) 0;0 0 -1];
end
