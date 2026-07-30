function adj=adj_G(a)
%adj=[sk(w) 0 0;skw(t1) skw(w) 0;skw(t2) 0 skw(w)] eq85
adj=[skew(a(1:3)) zeros(3,3) zeros(3,3);...
    skew(a(4:6)) skew(a(1:3)) zeros(3,3);...
    skew(a(7:9)) zeros(3,3) skew(a(1:3))];
    
adj=blkdiag(adj,zeros(6,6));

end