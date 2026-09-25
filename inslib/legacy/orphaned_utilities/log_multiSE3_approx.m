function [xi] = log_multiSE3_approx(chi)
%Log Serie
% log(X)=sum_i=1^\infty (-1)^(m+1)(X-I)^m/m
t=chi-eye(7);
t2=t*t;
t3=t2*t;
t4=t3*t;
t5=t4*t;
t6=t5*t;
t7=t6*t;
t8=t7*t;
X=t-1/2*t2+1/3*t3-1/4*t4+1/5*t5-1/6*t6+1/7*t7-1/8*t8;
xi=[X(3,2);X(1,3);X(2,1);X(1:3,4);X(1:3,5);X(1:3,6);X(1:3,7)];
end