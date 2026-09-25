function [H,Ceb]=Jacobian_medida_quat(q,lb,Cen)
    Ceb=Cen*rotmFromQuat(q);
    H=[-Ceb*skew(lb) zeros(3,3) eye(3) zeros(3,3) zeros(3,3)];
end