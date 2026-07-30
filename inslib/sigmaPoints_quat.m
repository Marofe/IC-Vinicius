function X = sigmaPoints_quat(hx0,P0,lambda)
n=size(P0,1); %n=15
%% alocação de memória
%del_x
del_x=zeros(n,1); % 15x1 del_x = [del_phi del_veb del_peb del_ba del_bg]

 if size(hx0,1)==1
     hx0=hx0';
 end
P0=0.5*(P0+P0');
minEig=min(real(eig(P0)));
if minEig < 0
    P0=P0+eye(size(P0,1))*abs(minEig*2);
end
%P=P'>0
%% calculo da matriz sqrt(P0)
S=chol(P0)'; %S'S=P; S=sqrtm(P) 9x9
t=sqrt(lambda+(n));
%% calculo dos Sigma points 'intermediários'
Xii=[del_x del_x+t*S del_x-t*S];        %nx(2n+1) ==> Xii=[del_phi del_veb del_peb] 15x31
%% Aplicando  X = del_x + hx ou X = Xii +hx,  X = 10x19 
X=zeros(n+1,2*n+1); % 16x31
E=Xi(hx0(1:4)); %4x3
% for i=1:2*n+1
%     %% sigma points para o quaternion
%     % del_phi = Xii(1:3)
%     X(1:4,i)=hx0(1:4) + 0.5*E*Xii(1:3,i);   % Xquat = del_ q(x)hq => eq (41)
%     X(1:4,i)=X(1:4,i)/norm(X(1:4,i));                  %normalização forçada
%     %% sigma points para veb e peb
%     X(5:10,i)=hx0(5:10)+Xii(4:9,i);                    %Xpeb= h_peb + del_peb ; Xveb= h_veb + del_veb
% end
% X(1:4,:)=hx0(1:4)+0.5*E*Xii(1:3,:);
% X(5:10,:)=hx0(5:10)+Xii(4:9,:);
X=hx0+blkdiag(0.5*E,eye(12))*Xii;
%% del_m ao redor do vetor m
% del_m=t*S;  % variação ao redor de m (9x9);
%del_m(1:3)= t*S(1:3) =del_phi/2
%del_m(4:6)=del_v
%del_m(7:9)=del_p
%% sigma points 
% qi=zeros(4,2*n+1); %sigma point dos quaternions
% Xii=zeros(6,2*n+1);  %sigma points de veb  e peb
%% primeiro valor dos sigma points
% qi(:,1)=m(1:4);   % o primeiro sigm point do quat é a m(1:4)
% Xii(:,1)=m(5:10); % o primeiro sigm point de veb e peb é a média m(5:10)
%% Construindo os sigma points
    % for i=1:n
    %     %construindo os sig point para o quaternion  qi= hq(x)del_q
    %     qi(:,i+1)=mult_quat(m(1:4),[del_m(1:3,i)/2;1]);  %qi=hq(x)[del_phi/2 1]' 
    %     qi(:,i+n+1)=mult_quat(m(1:4),[-del_m(1:3,i)/2;-1]); %qi=hq(x)(-1)[del_phi/2 1]'
    %     %forçando norma igual a 1
    %     qi(:,i+1)=qi(:,i+1)/norm(qi(:,i+1));
    %     qi(:,i+n+1)=qi(:,i+n+1)/norm(qi(:,i+n+1));
    %     % construindo os sigma point para veb e peb
    %     Xii(:,i+1)=m(5:10)+del_m(4:9,i);
    %     Xii(:,i+n+1)=m(5:10)-del_m(4:9,i);
    % end

% X=[qi;Xii]; %10x(2*n+1)=10x19 [qi1x4 vi1x3 pi1x3]  


end

