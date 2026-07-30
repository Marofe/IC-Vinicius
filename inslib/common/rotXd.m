function C=rotXd(theta)
% Rotate about x-axis following right-handed convention
% input -> theta (deg)
% output -> Rx 
C=[1 0 0;0 cosd(theta) sind(theta);0 -sind(theta) cosd(theta)];
end
