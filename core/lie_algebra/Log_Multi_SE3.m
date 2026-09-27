function [xi] = Log_Multi_SE3(chi) %#codegen
% LOG_MULTI_SE3 Log map for SE_2(3) (multi-SE3): closed-form with Taylor small-angle safeguard.
%
% Numerical Findings & Rationale for Fix:
%   1. Catastrophic cancellation in trace(C) / acos():
%      The previous implementation computed phi = real(acos(0.5 * (trace(C) - 1))) and set
%      phi_a = zeros(3, 1) whenever phi < 1e-10. Because the diagonal entries of C = Exp_SO3(phi_a)
%      are 1 - c2 * (phi_y^2 + phi_z^2), subtracting O(phi^2) from 1.0 in IEEE 754 double precision
%      (eps = 2.22e-16) causes 0.5 * (trace(C) - 1) ~ 1 - 0.5 * phi^2 to round to exactly 1.0
%      whenever phi < sqrt(2 * eps) = 1.49e-8 rad. Consequently, acos(cos_phi) underflows to 0.0
%      below 1.49e-8 rad (100% relative error) and loses half of its significant digits for
%      phi in [1.49e-8, 1e-4] rad.
%   2. Hard-zero truncation of small sigma-point rotations in UKF_Lie / SRUKF_Lie:
%      Even when phi is small, phi_a = phi * a is non-zero. Setting phi_a = zeros(3, 1) violated
%      the round-trip identity Log(Exp(xi)) = xi for small angles. In 200 Hz GNSS/INS filtering
%      (dt = 0.005 s, alpha = 0.014), the attitude perturbation on the gyroscope-bias sigma points
%      (||-dt * delta_bg|| ~ 4.3e-9 rad) and cross-correlated velocity/position/accel-bias sigma
%      points (1.2e-11 to 1.25e-8 rad) is below 1.49e-8 rad, so the old branch zeroed out
%      xi_state(1:3, i) on 24 of the 30 state-error sigma points at every prediction step.
%   3. Fix Implementation:
%      - Off-diagonal entries of C are added to 0.0 in Exp_Multi_SE3, so the skew-symmetric vector
%        skew_vec = 0.5 * vee(C - C') = sin(phi) * a retains full 16-digit precision down to 1e-308.
%      - Computing sin_phi = norm(skew_vec) and phi = atan2(sin_phi, cos_phi) eliminates acos()
%        underflow and preserves full double precision across all angle regimes.
%      - For phi < 1e-4 (matching the theta < 1e-4 threshold in Exp_Multi_SE3), since
%        skew_vec = (sin(phi) / phi) * phi_a, the rotation vector is recovered without dividing by
%        sin_phi via the 4th-order Taylor series of phi / sin(phi):
%          phi_a = (1 + phi^2 / 6 + (7 / 360) * phi^4) * skew_vec
%        and the inverse left Jacobian iJ is evaluated via its nonsingular Taylor series:
%          iJ = I - 0.5 * [phi_a]_x + (1 / 12) * [phi_a]_x^2.

C = chi(1:3, 1:3);
r = chi(1:3, 4:end);

% Extract sin(phi)*a from the off-diagonal skew-symmetric part: 0.5*(C - C') = sin(phi)*[a]_x
skew_vec = 0.5 * [C(3, 2) - C(2, 3); C(1, 3) - C(3, 1); C(2, 1) - C(1, 2)];
sin_phi  = norm(skew_vec);
cos_phi  = 0.5 * (trace(C) - 1);
phi      = atan2(sin_phi, cos_phi);

if phi < 1e-4
    % Small-angle Taylor expansion of (phi / sin(phi)) and inverse left Jacobian iJ
    phi2  = phi * phi;
    phi_a = (1 + phi2 / 6 + (7 / 360) * (phi2 * phi2)) * skew_vec;
    A     = Skew_Symmetric_3(phi_a);
    iJ    = eye(3) - 0.5 * A + (1 / 12) * (A * A);
else
    phi_a    = (phi / sin_phi) * skew_vec;
    a        = phi_a / phi;
    A        = Skew_Symmetric_3(a);
    a_ta     = a * a.';
    half_phi = 0.5 * phi;
    cot_half = cos(half_phi) / sin(half_phi);
    iJ       = half_phi * cot_half * eye(3) + (1 - half_phi * cot_half) * a_ta - half_phi * A;
end
rho = iJ * r;
xi  = [phi_a; rho(:)];
end