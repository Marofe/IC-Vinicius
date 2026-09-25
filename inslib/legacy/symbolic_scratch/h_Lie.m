function h=h_Lie(X)
global lb
%X=[Ceb veb peb,0 I(2)]   
    
    y=X*[lb;...
         0;...
         1];
    %y = [p+Ceb*l;0;1]
    
    h=[eye(3) y(1:3);zeros(1,3) 1]; %4x4  Y==>T(3) 
end
