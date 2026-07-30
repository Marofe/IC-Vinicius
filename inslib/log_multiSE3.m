function [xi] = log_multiSE3(chi)
% Log map for SE_2(3) (multi-SE3): closed-form, avoids eig().
% Uses direct Rodrigues extraction from the rotation matrix.
C = chi(1:3,1:3);
r = chi(1:3,4:end);

% phi from trace: tr(C) = 1 + 2*cos(phi)
cos_phi = 0.5*(trace(C)-1);
cos_phi = min(1, max(-1, cos_phi));  % clamp for numerical safety
phi = real(acos(cos_phi));

if phi < 1e-10
    % Near-identity: iJ ~ I, axis is arbitrary
    a      = zeros(3,1);
    phi_a  = a;
    iJ     = eye(3);
else
    % Extract axis from skew-symmetric part: C - C' = 2*sin(phi)*[a]_x
    skew_C = 0.5*(C - C.');
    sin_phi = sin(phi);
    ax = skew_C(3,2)/sin_phi;
    ay = skew_C(1,3)/sin_phi;
    az = skew_C(2,1)/sin_phi;
    a  = [ax;ay;az];
    % Normalise to unit vector (guard against numerical drift)
    na = norm(a);
    if na > 1e-12, a = a/na; end
    phi_a = phi*a;
    A  = [0 -a(3) a(2); a(3) 0 -a(1); -a(2) a(1) 0];
    a_ta = a*a.';
    half_phi = phi/2;
    cot_half = cos(half_phi)/sin(half_phi);
    iJ = half_phi*cot_half*eye(3) + (1 - half_phi*cot_half)*a_ta - half_phi*A;
end
rho = iJ*r;
xi  = [phi_a; rho(:)];
end

