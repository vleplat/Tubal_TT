function C = tub_kron(A,B)
% Kronecker-Conv product 
% C(i,j,:) = cconv(A(i,j,:),B(i,j,:))

szA = size(A);
szB = size(B);

Af = fft(A,[],3);
Bf = fft(B,[],3);
C = zeros([szA(1)*szB(1) szA(2)*szB(2) szA(3)]);

for k = 1:ceil((szA(3)+1)/2)
    C(:,:,k) = kron(Af(:,:,k),Bf(:,:,k));
end
for k = ceil((szA(3)+1)/2)+1:szA(3)
    C(:,:,k) = conj(C(:,:,szA(3)+2-k));
end
C = ifft(C,[],3);
