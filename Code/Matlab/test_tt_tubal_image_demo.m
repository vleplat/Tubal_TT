clear all
clc
close all;

imfile = 'airplane.bmp';
%imfile = 'pepper.tiff';
s1rgb = imread(imfile);
[pp,imname,ex] = fileparts(imfile);
Y = im2double(s1rgb) ;
Y = imresize(Y,[512 512]);

szY = size(Y);
d = log2(szY(1));

% Reshape to tensor of order-d
szYt = [2*ones(1,d*2) 3];
Yt = reshape(Y,szYt);
ordix = reshape(reshape(1:2*d,d,2)',1,[]);
ordix = [ordix([1 2])  ordix(3:end) 2*d+1];
Yt = permute(Yt,ordix);
szYt2 = [4*ones(1,d) 3];
Yt = reshape(Yt,szYt2);

ftensor2image = @(Yx) reshape(ipermute(reshape(Yx,szYt(ordix)),ordix),szY);

r = [1 2 6 9 35 40 51 16 4 1];

% TT-SVD algorithm with ranks given
Ytt = tubttsvd(Yt,r);

Yx = full_tubtt(Ytt);

Yxm = ftensor2image(Yx);

err_ttsvd = norm(Y(:) - Yxm(:) )/norm(Y(:))
noparams = sum(cellfun(@(x) numel(x),Ytt,'uni',1));

fprintf('Number of parameters of TTTSVD %d   error %.3d \n ',noparams,err_ttsvd)

Perf_ = eval_rec(Y,Yxm);
fprintf('Denoising result \n')
fprintf('MSE %.2f dB \n', Perf_{1,2})
fprintf('PSNR %.2f dB \n', Perf_{2,2})
fprintf('SSIM %.4f \n', Perf_{3,2})


% fig = figure(4);
% clf
% imagesc(Yxm)
% axis image
% axis off


opts = ttmps_a2cu();
opts.compression = false;
[Yt_dmrg,output] = tubtt_a2cu(Yt,r,opts);
Yt_dmrgfull = full_tubtt(Yt_dmrg.U);

%Visualize
Yxm = ftensor2image(Yt_dmrgfull);

err_ttsvd = norm(Y(:) - Yxm(:) )/norm(Y(:))
noparams = sum(cellfun(@(x) numel(x),Yt_dmrg.U,'uni',1));

fprintf('Number of parameters of TTT-DMRG %d   error %.3d \n ',noparams,err_ttsvd)

Perf_ = eval_rec(Y,Yxm);
fprintf('Denoising result \n')
fprintf('MSE %.2f dB \n', Perf_{1,2})
fprintf('PSNR %.2f dB \n', Perf_{2,2})
fprintf('SSIM %.4f \n', Perf_{3,2})


% fig = figure(1);
% clf
% imagesc(Yxm)
% axis image
% axis off


opts = ttmps_a2cu();
opts.compression = false;

%min  \|Y - X\|_F  <= noise_level^2 * numel(Y)
relative_error = 0.15;
opts.noise_level = relative_error^2*norm(Yt(:))^2;

[Yt_dmrg,output] = tubtt_a2cu(Yt,[],opts);
Yt_dmrgfull = full_tubtt(Yt_dmrg.U);

%Visualize
Yxm = ftensor2image(Yt_dmrgfull);

err_ttsvd = norm(Y(:) - Yxm(:) )/norm(Y(:))
noparams = sum(cellfun(@(x) numel(x),Yt_dmrg.U,'uni',1));

fprintf('Number of parameters of tubalTT fixed tolerance %d   error %.3d \n ',noparams,err_ttsvd)

Perf_ = eval_rec(Y,Yxm);
fprintf('Denoising result \n')
fprintf('MSE %.2f dB \n', Perf_{1,2})
fprintf('PSNR %.2f dB \n', Perf_{2,2})
fprintf('SSIM %.4f \n', Perf_{3,2})


fig = figure(1);
clf
imagesc(Yxm)
title('Proposed algorithm')
axis image
axis off

opts = ttmps_a2cu();
opts.compression = false;

%min  \|Y - X\|_F  <= noise_level^2 * numel(Y)
relative_error = 0.15;
opts.noise_level = relative_error^2*norm(Yt(:))^2;

[Ytx2,output] = ttmps_a2cu(Yt,[],opts);
Ytxf= full(Ytx2);
Yxm = ftensor2image(Ytxf);

%Visualize
err_ttsvd = norm(Y(:) - Yxm(:) )/norm(Y(:))
noparams = sum(cellfun(@(x) numel(x),Ytx2.U,'uni',1));

fprintf('Number of parameters of TTSVD %d   error %.3d \n ',noparams,err_ttsvd)

Perf_ = eval_rec(Y,Yxm);
fprintf('Denoising result \n')
fprintf('MSE %.2f dB \n', Perf_{1,2})
fprintf('PSNR %.2f dB \n', Perf_{2,2})
fprintf('SSIM %.4f \n', Perf_{3,2})


fig = figure(2);
clf
imagesc(Yxm)
title('TT-based algorithm')
axis image
axis off

function Perf_ = eval_rec(Y,Ym)

% Assess performance of denoising
Perf_  = {};
for metrix = {'MSE' 'PSNR' 'SSIM'}
    perf_ = metrix_mux(Y*255,double(Ym)*255,metrix{1});
    Perf_ = [Perf_ ; metrix {perf_}];
end
end
