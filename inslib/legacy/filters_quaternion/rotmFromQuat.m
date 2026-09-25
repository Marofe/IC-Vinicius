function C=rotmFromQuat(q)
    %% tirado do Grooves
    % C11=q(1)^2 + q(2)^2 - q(3)^2 - q(4)^2;
    % C12 = 2 * (q(2) * q(3) + q(1) * q(4));
    % C13 = 2 * (q(2) * q(4) - q(3) * q(1));
    % C21 = 2 * (q(2) * q(3) - q(4) * q(1));
    % C22 = q(1)^2 - q(2)^2 + q(3)^2 - q(4)^2;
    % C23 = 2 * (q(3) * q(4) + q(1) * q(2));
    % C31 = 2 * (q(2) * q(4) + q(1) * q(3));
    % C32 = 2 * (q(3) * q(4) - q(2) * q(1));
    % C33 = q(1)^2 - q(2)^2 - q(3)^2 + q(4)^2;
    % Cbe = [C11 C12 C13; C21 C22 C23; C31 C32 C33];
    %Ceb=Cbe';
    
    %% Notas do professor
    % qv=q(1:3);
    % q4=q(4);
    % Ceb=(q4^2 - norm(qv)^2)*eye(3) + 2*q4*skew(qv) + 2*(qv*qv');

    % Converts a quaternion q = [qx; qy; qz;qw] to a 3x3 rotation matrix R
    
    % 1. Enforce strict normalization to prevent scaling/skew artifacts
    q = q / norm(q);
    
    % 2. Extract components for readability
    qw = q(4);
    qx = q(1);
    qy = q(2);
    qz = q(3);
    
    % 3. Pre-compute repeated products to save floating-point operations (FLOPs)
    qx2 = qx * qx;
    qy2 = qy * qy;
    qz2 = qz * qz;
    
    qxqy = qx * qy;
    qxqz = qx * qz;
    qyqz = qy * qz;
    
    qwqx = qw * qx;
    qwqy = qw * qy;
    qwqz = qw * qz;
    
    % 4. Construct the rotation matrix
    C = [1 - 2*(qy2 + qz2),   2*(qxqy - qwqz),     2*(qxqz + qwqy);
         2*(qxqy + qwqz),     1 - 2*(qx2 + qz2),   2*(qyqz - qwqx);
         2*(qxqz - qwqy),     2*(qyqz + qwqx),     1 - 2*(qx2 + qy2)];

end