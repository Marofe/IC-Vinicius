function q=quatFromRotm(R)
    % q = zeros(4, 1);
    % q(4)=0.5*(sqrt(1+C(1,1)+C(2,2)+C(3,3)));
    % q(1) = (C(3,2) - C(2,3)) / (4 * q(4));
    % q(2) = (C(1,3) - C(3,1)) / (4 * q(4));
    % q(3) = (C(2,1) - C(1,2)) / (4 * q(4));
    % Extracts a unit quaternion q = [qw; qx; qy; qz] from a 3x3 rotation matrix R
    
    tr = trace(R);
    
    if tr > 0
        S = 2 * sqrt(tr + 1.0);
        qw = 0.25 * S;
        qx = (R(3,2) - R(2,3)) / S;
        qy = (R(1,3) - R(3,1)) / S;
        qz = (R(2,1) - R(1,2)) / S;
    elseif (R(1,1) > R(2,2)) && (R(1,1) > R(3,3))
        S = 2 * sqrt(1.0 + R(1,1) - R(2,2) - R(3,3));
        qw = (R(3,2) - R(2,3)) / S;
        qx = 0.25 * S;
        qy = (R(1,2) + R(2,1)) / S;
        qz = (R(1,3) + R(3,1)) / S;
    elseif R(2,2) > R(3,3)
        S = 2 * sqrt(1.0 - R(1,1) + R(2,2) - R(3,3));
        qw = (R(1,3) - R(3,1)) / S;
        qx = (R(1,2) + R(2,1)) / S;
        qy = 0.25 * S;
        qz = (R(2,3) + R(3,2)) / S;
    else
        S = 2 * sqrt(1.0 - R(1,1) - R(2,2) + R(3,3));
        qw = (R(2,1) - R(1,2)) / S;
        qx = (R(1,3) + R(3,1)) / S;
        qy = (R(2,3) + R(3,2)) / S;
        qz = 0.25 * S;
    end
    
    q = [qx; qy; qz; qw];
    
    % Ensure the quaternion is strictly normalized (mitigates floating point drift)
    q = q / norm(q); 
end