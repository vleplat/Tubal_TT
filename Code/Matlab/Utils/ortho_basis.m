function Q = ortho_basis(M)
%Computes an orthonormal basis for a matrix.
% Inputs : M: (m x n) matrix.
% Output : An orthonormal basis for M.

[Q,~] = qr(M,0);
end