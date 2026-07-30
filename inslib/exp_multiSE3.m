function chi = exp_multiSE3(xi)
theta = norm(xi(1:3));
NbXi = length(xi)/3-1;
if(theta == 0)
    chi = eye(3+NbXi);
    chi(1:3,4:end) = reshape(xi(4:end),[3 NbXi]);
else
    Xi = zeros(3+NbXi);
    Xi(1:3,1:3) = cross2matrix(xi(1:3));
    Xi(1:3,4:end) = reshape(xi(4:end),[3 NbXi]);
    Xi2=Xi*Xi;
    Xi3=Xi2*Xi;
    chi = eye(3+NbXi) + Xi + 1/theta^2*(1-cos(theta))*Xi2 + 1/theta^3*(theta-sin(theta))*Xi3;
end
end

