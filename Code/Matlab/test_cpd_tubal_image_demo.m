%% 
% Tubal CPD
% 
% AnhHuy Phan

clear all
clc
close all;

%imfile = 'lena.bmp';
imfile = 'pepper.tiff';
s1rgb = imread(imfile);
[pp,imname,ex] = fileparts(imfile);
Y = im2double(s1rgb) ;
Y = imresize(Y,[512 512]);

szY = size(Y);
d = log2(szY(1));
d = 3;
% Reshape to tensor of order-d
szYt = [8*ones(1,6) 3];
Yt = reshape(Y,szYt);
ordix = reshape(reshape(1:2*d,d,2)',1,[]);
ordix = [ordix([1 2])  ordix(3:end) 2*d+1];
Yt = permute(Yt,ordix);
szYt2 = [64*ones(1,d) 3];
Yt = reshape(Yt,szYt2);

ftensor2image = @(Yx) reshape(ipermute(reshape(Yx,szYt(ordix)),ordix),szY);
%%
Yf = fft(Yt,[],ndims(Yt));
halfn3 = ceil((szYt2(end)+1)/2);
R = 100;

for k = 1 : halfn3

    %%
    opt = cp_fastals;
    opt.maxiters = 10;
    opt.printitn = 1;
    P = cp_fastals(tensor(Yf(:,:,:,k)),R,opt);
    U = cpd_nls(Yf(:,:,:,k),P.U,struct('Display',1));
    P = ktensor(U);
    Yks{k} = P;
end

%%
Xa = cell(ndims(Yt)-1,1);
halfn3 = ceil((szYt2(end)+1)/2);
for n = 1:ndims(Yt)-1    
    for k = 1 : halfn3
        if n==1
            if k == 1
                Xa{n} = Yks{k}.U{n}*diag(Yks{k}.lambda);
            else
                Xa{n} = cat(3,Xa{n},Yks{k}.U{n}*diag(Yks{k}.lambda));
            end
        else
            if k == 1
                Xa{n}(:,:,k) = Yks{k}.U{n};
            else
                Xa{n}(:,:,k) = Yks{k}.U{n};
            end
        end
    end

    for k = halfn3+1 : szYt2(end)        
        Xa{n}(:,:,k) = conj(Xa{n}(:,:,szYt2(end)+2-k));
    end
end

for n = 1:numel(Xa)
    Xt{n} = ifft(Xa{n},[],3);
end

%%
% FULL CP-tub
Yx = 0;
for r = 1:R
    Ur = cellfun(@(x) x(:,r,:),Xt,'uni',0);
    Yr = tub_kron(Ur{3},tub_kron(Ur{2},Ur{1}));
    Yx = Yx + Yr;
end

Yxm = ftensor2image(Yx);
%% Visualize


err_ttsvd = norm(Y(:) - Yxm(:) )/norm(Y(:))

fprintf('error %.3d \n ',err_ttsvd)

Perf_ = eval_rec(Y,Yxm);
fprintf('Denoising result \n')
fprintf('MSE %.2f dB \n', Perf_{1,2})
fprintf('PSNR %.2f dB \n', Perf_{2,2})
fprintf('SSIM %.4f \n', Perf_{3,2})


fig = figure(4);
clf
imagesc(Yxm)
axis image
axis off

%% CPD of Yt

Rcp = round(sum(cellfun(@(x) numel(x),Xa))/sum(size(Yt)));
opt = cp_fastals;
opt.maxiters = 100;
opt.printitn = 1;
P = cp_fastals(tensor(Yt),Rcp,opt);

%%

Ycp = ftensor2image(double(full(P)));

err_ttsvd = norm(Y(:) - Ycp(:) )/norm(Y(:))

fprintf('error %.3d \n ',err_ttsvd)

Perf_ = eval_rec(Y,Ycp);
fprintf('Denoising result \n')
fprintf('MSE %.2f dB \n', Perf_{1,2})
fprintf('PSNR %.2f dB \n', Perf_{2,2})
fprintf('SSIM %.4f \n', Perf_{3,2})


fig = figure(4);
clf
imagesc(Yxm)
axis image
axis off
%%
function Perf_ = eval_rec(Y,Ym)

% Assess performance of denoising
Perf_  = {};
for metrix = {'MSE' 'PSNR' 'SSIM'}
    perf_ = metrix_mux(Y*255,double(Ym)*255,metrix{1});
    Perf_ = [Perf_ ; metrix {perf_}];
end

end