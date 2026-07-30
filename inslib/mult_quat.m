function quat=mult_quat(qa,qb)
% seja qa=[ro_a; q4a] e qb=[ro_b; q4b]
%% qa = q'
ro_a=qa(1:3);
q4a=qa(4);
%% qb = q
ro_b=qb(1:3);
q4b=qb(4);
%% multiplicação de quaternion
quat=[q4a*ro_b + q4b*ro_a - cross(ro_a,ro_b);...
    q4a*q4b - dot(ro_a,ro_b)];

end