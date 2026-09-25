function [hx,P]=update_ekf_quat(hx0,P0,R,y,lb,n,Cen)
    [H,Ceb]=Jacobian_medida_quat(hx0(1:4),lb,Cen);
    hy=hx0(8:10)+Ceb*lb;
    z=y-hy;
    K=P0*H'/(R+H*P0*H');
    del_phi_X=K*z;
    del_phi=del_phi_X(1:3);
    del_X=del_phi_X(4:15);
    
    %update quaternion
    hx(1:4)=hx0(1:4) + 0.5*Xi(hx0(1:4))*del_phi;
    hx(1:4)=hx(1:4)/norm(hx(1:4)); % normalização forçada
    %update veb,peb
    hx(5:16)=hx0(5:16)+del_X;
    %Update matriz de Covariância
    P=(eye(n-1)-K*H)*P0*(eye(n-1)-K*H)'+K*R*K';
    P=(P+P')/2; %force symmetry (compensate for numeric errors)
end