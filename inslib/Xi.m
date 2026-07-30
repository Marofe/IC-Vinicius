function T=Xi(q)
    T=[q(4)*eye(3)+skew(q(1:3));...
     -q(1:3)'];
end