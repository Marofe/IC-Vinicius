function expo=exp_multiSE23T6(a)
    %a=[w a v ba0 bg0](15x1)
    % para o SE2(3)xT6 exp([w a v ba0 bg0])=blkdiag([exp([w a v]^)],[eye ba0;0 1],[eye bg0;0 1])

    exp_aSE23=exp_multiSE3(a(1:9)); % resulta em matriz(5x5)
    exp_ba0=[eye(3) a(10:12);zeros(1,3) 1];  % resulta em matriz(4x4)
    exp_bg0=[eye(3) a(13:15);zeros(1,3) 1];  % resulta em matriz(4x4)
    
    expo=blkdiag(exp_aSE23,exp_ba0,exp_bg0); %dimensao 13x13
end