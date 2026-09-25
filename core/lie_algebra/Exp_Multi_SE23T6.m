function expo = Exp_Multi_SE23T6(a) %#codegen
% EXP_MULTI_SE23T6 Exponential map from R^15 to SE_2(3) x T(6) (13x13).
exp_aSE23 = Exp_Multi_SE3(a(1:9));
exp_ba0   = [eye(3), a(10:12); zeros(1, 3), 1];
exp_bg0   = [eye(3), a(13:15); zeros(1, 3), 1];

expo = blkdiag(exp_aSE23, exp_ba0, exp_bg0);
end