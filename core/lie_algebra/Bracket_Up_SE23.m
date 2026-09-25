function dOmega = Bracket_Up_SE23(Omega) %#codegen
% BRACKET_UP_SE23 Wedge operator [Omega]^ on se_2(3) (5x5).
dOmega = [Skew_Symmetric_3(Omega(1:3)), Omega(4:6), Omega(7:9); ...
          zeros(2, 3),                  zeros(2, 2)];
end
