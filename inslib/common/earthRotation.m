function w_ie=earthRotation(L)
% Compute the Earth angular velocity in rad/s for a given latitude wrt to
% navigation frame (w_ie^n)
w_ie=7.2722e-05*[cosd(L);0;-sind(L)];
end