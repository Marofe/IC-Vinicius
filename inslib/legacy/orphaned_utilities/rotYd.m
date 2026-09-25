function C=rotYd(theta)
% Rotate about y-axis following right-handed convention
% input -> theta (deg)
% output -> Ry
C=[cosd(theta) 0 -sind(theta);0 1 0;sind(theta) 0 cosd(theta)];
end
