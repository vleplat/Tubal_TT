function [U,S,V] = r_svd(A, rank, n_subspace_iters)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


n_samples = 2 * rank;

% Stage A
Q = find_range(A, n_samples, n_subspace_iters);

% Stage B
B = Q' * A;
[U_tilde, S, V] = svd(B);
U = Q * U_tilde;

% Truncate
U = U(:,1:rank);
S = S(1:rank,1:rank);
V = V(:,1:rank);

end