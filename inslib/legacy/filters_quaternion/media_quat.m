function m_q=media_quat(Xq,Wm)
    %Xq = 4x19
    %Wm = 19x1
    N=size(Wm,1); % N=19= 9*2+1  
    M=zeros(4,4);
    for i=1:N
        if Xq(4,i)<0
           Xq(:,i)=-Xq(:,i);
        end
        
        M=M + Wm(i)*(Xq(:,i)*Xq(:,i)');
    end
    [V,D]=eig(M); %V=> autvet e D autovalores
    [~,idx]=max(diag(D)); 
    m_q=V(:,idx);         
    m_q=m_q/norm(m_q);
    
    if m_q(4) < 0
    m_q = -m_q;
    end

end