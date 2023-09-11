clc;clear all;close all

%imfile = 'baboon.bmp';
imfile = 'kodim3.bmp';
imfile = ['kodim23.png'];
%imfile = 'barbara.bmp';
%imfile = 'airplane.bmp';
%imfile = 'pepper.tiff';
s1rgb = imread(imfile);
[pp,imname,ex] = fileparts(imfile);
Y = im2double(s1rgb) ;
Y = imresize(Y,[512 512]);
%subplot(1,3,1)

%imagesc(Y)
%title('Original Image','FontSize',3)


mr=0.80;
S=size(Y);
Q = gen_W(S,mr);
Y_miss=Q.*Y;
%%%%%%

szY = size(Y);
d = log2(szY(1));

% Reshape to tensor of order-d
szYt = [2*ones(1,d*2) 3];
Yt = reshape(Y,szYt);
Qt = reshape(Q,szYt);
Yt_miss = reshape(Y_miss,szYt);
ordix = reshape(reshape(1:2*d,d,2)',1,[]);
ordix = [ordix([1 2])  ordix(3:end) 2*d+1];
Yt = permute(Yt,ordix);
Qt = permute(Qt,ordix);
Yt_miss = permute(Yt_miss,ordix);
szYt2 = [4*ones(1,d) 3];
Yt = reshape(Yt,szYt2);
Qt = reshape(Qt,szYt2);
Yt_miss = reshape(Yt_miss,szYt2);

ftensor2image = @(Yx) reshape(ipermute(reshape(Yx,szYt(ordix)),ordix),szY);

%
r = [1 2 6 14 14 14 14 14 4 1];

YY=randn(size(Yt));

for i=1:500
% TT-SVD algorithm with ranks given
YYt = tubttsvd(YY,r);
YY = full_tubtt(YYt);
YY=YY.*(~Qt)+Yt_miss;
Yh = ftensor2image(YY);
imagesc(Yh)
drawnow
eval_rec(Yh,Y)
end
%%
% YY=randn(size(Yt));
% for i=1:500
% % TT-SVD algorithm with ranks given
% [ut,st,vt] = H_tsvd(YY);
% u_t=ut(:,:,:,:,:,:,:,:,:,:);
% s_t=st(:,:,:,:,:,:,:,:,:,:);
% s_t=st(:,:,:,:,:,:,:,:,:,:);
% YY = H_tprod(H_tprod(ut,st),H_tran(vt));
% YY=YY.*(~Qt)+Yt_miss;
% Yh = ftensor2image(YY);
% imagesc(Yh)
% drawnow
% eval_rec(Yh,Y)
% end


function Perf_ = eval_rec(Y,Ym)

% Assess performance of denoising
Perf_  = {};
for metrix = {'MSE' 'PSNR' 'SSIM'}
    perf_ = metrix_mux(Y*255,double(Ym)*255,metrix{1});
    Perf_ = [Perf_ ; metrix {perf_}];
end
end