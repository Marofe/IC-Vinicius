function Adj=Ad_G(X)
% X=[Ceb veb peb;0 0]
%Adj=[   C    0 0 ...
%    skew(v)C C 0 ...
%    skew(p)C 0 C ...
%                    I 0
%                    0 I]
C=X(1:3,1:3);
v=X(1:3,4);
p=X(1:3,5);

Adj=[C zeros(3,3) zeros(3,3);...
    skew(v)*C C zeros(3,3);...
    skew(p)*C zeros(3,3) C];

Adj=blkdiag(Adj,eye(6));
end
