function g = gravityModel(lat)
%Compute the nominal gravity value considering the WGS-84 model
%  input -> latitude in deg
%  output -> local gravity in m/s^2
% Reference: 
%[1] R. M. Rogers, Applied Mathematics in Integrated Navigation Systems,
% vol. 27, no. 7. 2003.

ecc=0.0818191908426; %First Eccentricity
gWGS0=9.7803267714; %Gravit at equator
gWGS1=0.00193185138639; % Gravity formula constant
g=gWGS0*(1+gWGS1*sind(lat)^2)/sqrt(1-ecc^2*sind(lat)^2);
end

