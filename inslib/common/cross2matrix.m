function M = cross2matrix(a)
% return the cross product matrix [a]x
%  
M=[0 -a(3) a(2);...
    a(3) 0 -a(1);....
    -a(2) a(1) 0];
end

