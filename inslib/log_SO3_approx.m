function xi = log_SO3_approx(chi)
t=chi-eye(3);
t2=t*t;
t3=t2*t;
t4=t3*t;
t5=t4*t;
t6=t5*t;
X=t-1/2*t2+1/3*t3-1/4*t4+1/5*t5-1/6*t6;
xi=[X(3,2);X(1,3);X(2,1)];
end

