function [rmse, angles, pos, vel] = evaluateStateRMSE(euler, pe, ve, ref, varargin)
% EVALUATESTATERMSE Backwards-compatible wrapper for Evaluate_State_RMSE.
[rmse, angles, pos, vel] = Evaluate_State_RMSE(euler, pe, ve, ref, varargin{:});
end
