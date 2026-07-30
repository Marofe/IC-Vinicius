function [hx,P]=update_EKF_Lie(hx0,P0,R,y,lb)
    H=matriz_H_se23T6(hx0,lb);
    K=P0*H'/(R+H*P0*H');
    Ceb=hx0(1:3,1:3);
    v=K*(y-(hx0(1:3,5)+Ceb*lb)); %v(k)=Klog(h(hx0)^-1 * y)v

    %% Update dos estados
    hx=hx0*exp_multiSE23T6(v);
    %% Update da covariancia
    P= phi(v)*(eye(15)-K*H)*P0*phi(v)';
    P=0.5*(P+P');


end