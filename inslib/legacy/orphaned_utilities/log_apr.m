function log=log_apr(A)
    n=size(A,1);
    M=A-eye(n);
    log = M -0.5*M*M + (1/3)*M*M*M; % até k=1 até k=3
end