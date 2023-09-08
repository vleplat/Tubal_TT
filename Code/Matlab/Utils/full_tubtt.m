function Y = full_ttt(G)
% Full tensor from Tubal-TT tensor G
% AnhHuy Phan
%
sz = cellfun(@(x) size(x,2),G,'uni',1);
sz = sz(:)';
r = cellfun(@(x) size(x,1),G,'uni',1);
N = numel(G);
r(end+1) = r(1);
D = size(G{1},ndims(G{1}));

n = 1;
Y = reshape(G{n},[],r(n+1),D);
for n = 2:N
    Y = tprod(Y,reshape(G{n},r(n),[],D));
    Y = reshape(Y,[],r(n+1),D);
end

Y = reshape(Y,[sz D]);
end

