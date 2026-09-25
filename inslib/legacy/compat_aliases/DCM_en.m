function C = DCM_en(L, lon, varargin) %#codegen
% DCM_EN Backwards-compatible wrapper for DCM_ECEF_To_NED.
C = DCM_ECEF_To_NED(L, lon, varargin{:});
end