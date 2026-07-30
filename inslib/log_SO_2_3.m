function log=log_SO_2_3(X)

    %sum(k=1-->inf)(-1)^(k-1)/k (g-I)^k

    A=X-eye(5);
    log=A + ((-1)/2)*A*A + (1/3)*A*A*A;

end