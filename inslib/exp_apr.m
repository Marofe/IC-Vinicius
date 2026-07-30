function exp = exp_apr(A)
    n=size(A,1);
    exp= eye(n)+ A + 0.5*A*A + (1/6)*A*A*A;    
end
