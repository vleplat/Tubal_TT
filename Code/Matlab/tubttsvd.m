function G = tttsvd(Y,r)
% Tubal TT-SVD
% AnhHuy Phan
% see tt_tensor
%
N = ndims(Y)-1;
sz = size(Y);
D = sz(end);
Y1 = Y;
G = cell(N,1);
for n = 1:N-1
    Y1 = reshape(Y1,r(n)*sz(n),[],D);
    [u1,s1,v1] = tsvds(Y1,r(n+1));
    G{n} = reshape(u1,[r(n) sz(n) r(n+1) D]);
    Y1 = tprod(s1,tran(v1));
end 
G
G{N} = reshape(Y1,[r(N) sz(N) r(N+1) D]);
end