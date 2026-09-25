function eul = eulerFromRotm(C, varargin) %#codegen
% EULERFROMROTM Backwards-compatible wrapper for Euler_Rad_From_Rotm.
eul = Euler_Rad_From_Rotm(C, varargin{:});
end