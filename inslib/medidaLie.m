function Ht=medidaLie(G,R,L)
global lb
%% ALLOCATE MEMORY
    Ht=zeros(4,4,2*L+1);
%% SigPoint da medida
    for i=1:2*L+1
        Ceb=G(1:3,1:3,i);
        peb=G(1:3,5,i);
        Ht(:,:,i)=[eye(3) (peb+Ceb*lb+R(:,i));zeros(1,3) 1];
    end
    
end