function Q = subspace_iter(A, Y0, n_iters)
%Algorithm 4.4: Randomized subspace iteration (p. 244 of Halko et al).
% Uses a numerically stable subspace iteration algorithm to down-weight
%    smaller singular values.
% Inputs : 
% % A:                  (m x n) matrix.
% % Y0:                 Initial approximate range of A.
% % n_iters:            Number of subspace iterations.
% %
% Output : Orthonormalized approximate range of A after power
%                    iterations.
Q = ortho_basis(Y0);

for i=1:n_iters
     Z = ortho_basis(A'*Q);
      Q = ortho_basis(A*Z);
end

end