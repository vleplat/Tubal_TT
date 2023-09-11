function Q = find_range(A, n_samples, n_subspace_iters)

%Algorithm 4.1: Randomized range finder (p. 240 of Halko et al).
% Given a matrix A and a number of samples, computes an orthonormal matrix
% that approximates the range of A.
% Inputs : 
% % A:                  (m x n) matrix.
% % n_samples:          Number of Gaussian random samples.
% % n_subspace_iters:   Number of subspace iterations.
% %
% Output : Orthonormal basis for approximate range of A.

[m,n] = size(A);
O = randn(n, n_samples);
Y = A * O;

if n_subspace_iters>1
    Q = subspace_iter(A, Y, n_subspace_iters);
else
    Q = ortho_basis(Y);
end

end