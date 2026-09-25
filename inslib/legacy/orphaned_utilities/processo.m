function hx=processo(hx0,omg_dt)
    %% x(k+1)=x(k)*exp^(Omeg*dt)
    
    hx=hx0*exp_multiSE3(omg_dt); 
    
end