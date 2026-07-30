function [hx,P,z]= EKF_update(hx0,P0,R,y,n,lb)
%state=[roll_e pitch_e yaw_e vx_e vy_e vz_e px_e py_e pz_e ba1 ba2 ba3 bg1 bg2 bg3]
      H=measurementJacobian_euler(hx0,lb);
      %% measurement model
      Ceb=rotm(flip(hx0(1:3)),'ZYX')'; %ECEF to body
      hy=hx0(7:9)+Ceb*lb;
      %%
      z=y-hy;
      K=P0*H'/(R+H*P0*H');
      % update angles/postion/velocity
      hx=hx0+K*z;
      hx(3)=wrapToPi(hx(3));
      % Updated Covariance
      P=(eye(n)-K*H)*P0*(eye(n)-K*H)'+K*R*K';
      P=(P+P')/2; %force symmetry (compensate for numeric errors)
      %% final residue
      Ceb=rotm(flip(hx(1:3)),'ZYX'); %ECEF to body
      hy=hx(7:9)+Ceb*lb;
      z=y-hy;
end