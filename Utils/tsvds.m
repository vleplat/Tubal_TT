%% [U,S,V] = tensor_t_svd(A)
% 
function [U,S,V] = tensor_t_svd(A,R)
  D = fft(A,[],3);
  %D = A;
  n3 = size(A,3);
  
  for i = 1:n3 %nframes
    [Cc,Uu,Rr] = svds(D(:,:,i),R);
    %size(D(:,:,i))
%    [Cc,Uu,Rr]=CURT(D(:,:,i),R,R);
%     size(C)
%     size(U)
%     size(R)
    Uy(:,:,i) = Cc;
    Sy(:,:,i) = Uu;
    Vy(:,:,i) = Rr;
  end
  
  U = ifft(Uy,[],3);
  S = ifft(Sy,[],3);
  V = ifft(Vy,[],3);
  %U = Uy;
  %S = Sy;
  %V = Vy;
end