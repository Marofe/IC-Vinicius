function y = hampelFilter(x,T,t)
 %   T=10; %Window
 %   t=2; %Confidence
 if nargin==1
     T=10;
     t=2;
 end
y=x(1:T);
for k=T+1:length(x)-T
    m=median(x(k-T:k+T));
    S=1.4826*median(abs(x(k-T:k+T)-m));
    if abs(x(k)-m)<=t*S
        y(k)=x(k);
    else
        y(k)=m;
    end
end
k=length(x)-T;
y(k+1:k+T)=x(k+1:k+T);
end

