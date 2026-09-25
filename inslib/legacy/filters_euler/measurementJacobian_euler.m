function H=measurementJacobian_euler(hx,lb)
%Measurment model - Jacobian
rx=lb(1);
ry=lb(2);
rz=lb(3);
phi=hx(1); %roll (ECEF)
theta=hx(2); %pitch (ECEF)
psi=hx(3); %yaw (ECEF)
H=[[  ry*(sin(phi)*sin(psi) + cos(phi)*cos(psi)*sin(theta)) + rz*(cos(phi)*sin(psi) - cos(psi)*sin(phi)*sin(theta)), rz*cos(phi)*cos(psi)*cos(theta) - rx*cos(psi)*sin(theta) + ry*cos(psi)*cos(theta)*sin(phi), rz*(cos(psi)*sin(phi) - cos(phi)*sin(psi)*sin(theta)) - ry*(cos(phi)*cos(psi) + sin(phi)*sin(psi)*sin(theta)) - rx*cos(theta)*sin(psi), 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0]
[- ry*(cos(psi)*sin(phi) - cos(phi)*sin(psi)*sin(theta)) - rz*(cos(phi)*cos(psi) + sin(phi)*sin(psi)*sin(theta)), rz*cos(phi)*cos(theta)*sin(psi) - rx*sin(psi)*sin(theta) + ry*cos(theta)*sin(phi)*sin(psi), rz*(sin(phi)*sin(psi) + cos(phi)*cos(psi)*sin(theta)) - ry*(cos(phi)*sin(psi) - cos(psi)*sin(phi)*sin(theta)) + rx*cos(psi)*cos(theta), 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0]
[                                                                ry*cos(phi)*cos(theta) - rz*cos(theta)*sin(phi),                          - rx*cos(theta) - rz*cos(phi)*sin(theta) - ry*sin(phi)*sin(theta),                                                                                                                                      0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0]];
end