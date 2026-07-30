function h=media_nula_h(W,H,alpha,L)
%% equação 32 das notas de UKF-Lie
h=H(:,:,1);
N_max=30;
%% com for
 for k=1:N_max
     soma=zeros(3,1);
     for i=1:2*L+1
         soma=soma +(alpha^2)*W(i)*(H(1:3,4,i)-h(1:3,4));  %inv(h)*H(:,:,i)= [I H(1:3,4,i)-h(1:3,4);0 1]
     end
     % aux=h;
     h=[eye(3) h(1:3,4)+soma;zeros(1,3) 1]; %  h(k+1)=h(k)exp^(soma)
     if (norm(soma))<1e-3
         break;
     end
 end

% %% com while
% while (abs(aux(1:3,4)-h(1:3,4)))>1e-3
%     sum=0;
%     for i=1:2*L+1
%         sum=sum + (alpha^2)*W(i)*log_apr([eye(3) H(1:3,4,i)-h(1:3,4);zeros(1,3) 1]);  %inv(h)*H(:,:,i)= [I H(1:3,4,i)-h(1:3,4);0 1]
%     end
%     aux=h;
%     h=h*exp_apr(sum);
% end



end