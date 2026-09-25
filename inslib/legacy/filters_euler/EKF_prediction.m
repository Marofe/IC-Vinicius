function [hx,P]= EKF_prediction(hx0,u,P0,Q,dt)
%state=[roll_e pitch_e yaw_e vx_e vy_e vz_e px_e py_e pz_e ba1 ba2 ba3 bg1 bg2 bg3]
    %% prediction
    [f_eul,gn]=f(hx0,u);
    hx=hx0+f_eul*dt; %integral de Euler
    hx(3)=wrapToPi(hx(3)); %guarantees that the heading is within -pi and +pi
    A=dynamicJacobian_euler(hx,u,gn);
    Phi=eye(15)+A*dt+0.5*A*A*dt^2; %approx exponential expm(A*dt)
    %Q=blkdiag(diag(Ng.^2),diag(Na.^2),diag(Nv.^2),diag(ba.^2),diag(bg.^2)); %process covariance (model and IMU precision)
    Qk=Q;
    P=Phi*P0*Phi'+Qk;
    P=(P+P')/2; %force symmetry (compensate for numeric errors)
end