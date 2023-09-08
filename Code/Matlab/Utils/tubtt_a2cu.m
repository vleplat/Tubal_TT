function [Xt,output] = tubtt_a2cu(X,rankX,opts)
% Tubal tensor train 
% X: order-N
% AnhHuy Phan 

N = ndims(X);
szX = size(X);
Xf = fft(X,[],ndims(X));
Xf = reshape(Xf,[],szX(end));
for k = 1:szX(end)
    %Tk = tt_tensor(Xf,[],szYt2,r(1:end));
    [Xtk,output] = ttmps_a2cu((reshape(Xf(:,k),szX(1:end-1))),rankX,opts);
    if k ==1
        Xt = Xtk;
        rtt = Xtk.rank;
    else
        rtk = Xtk.rank;
        newrank = max(rtt,rtk);
        for n = 1:N-1
            Un = zeros(newrank(n),szX(n),newrank(n+1),size(Xt.U{n},4)); 
            Un(1:rtt(n),:,1:rtt(n+1),:) = Xt.U{n};
            
            Vn = zeros(newrank(n),szX(n),newrank(n+1)); 
            Vn(1:rtk(n),:,1:rtk(n+1)) = Xtk.U{n};
            Xt.U{n} = cat(4,Un,Vn);
        end
        rtt = newrank;
    end
end
 

Xt.U = cellfun(@(x) ifft(x,[],4),Xt.U,'uni',0);


