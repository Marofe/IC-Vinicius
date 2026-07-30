function log = log_multiSE23T6(X)

X_se23=X(1:5,1:5);
ba=X(6:8,9);
bg=X(10:12,13);
%% log (X_SE_2(3))
logX_se23=log_multiSE3(X_se23);
%% Log([eye(3) b,zeros(1,3) 1])=b

log=[logX_se23;ba;bg];

end