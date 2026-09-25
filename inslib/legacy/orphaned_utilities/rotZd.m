function C=rotZd(theta)
% Rotate about z-axis following right-handed convention
% input -> theta (deg)
% output -> Rz
C=[cosd(theta) sind(theta) 0;-sind(theta) cosd(theta) 0;0 0 1];
end
