clc;clear all;close all

%imfile = 'baboon.bmp';
imfile = 'kodim4.png';
%imfile = ['kodim23.png'];
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


mr=0.70;
S=size(Y);
Q = gen_W(S,mr);
Y_miss=Q.*Y;
%% %%%%

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

for i=1:50
% TT-SVD algorithm with ranks given
YYt = tubttsvd(YY,r);
YY = full_tubtt(YYt);
YY=YY.*(~Qt)+Yt_miss;
Yh = ftensor2image(YY);
imagesc(Yh)
drawnow
fprintf('Iteration: %d', i)
eval_rec(Yh,Y)
end
%%
Yt=reshape(Y,[64,64,64,3]);
Qt=reshape(Q,[64,64,64,3]);
Yt_miss=reshape(Y_miss,[64,64,64,3]);
 R=3;
YY=randn(size(Yt));
for i=1:50
% TT-SVD algorithm with ranks given
[ut,st,vt] = H_tsvd(YY);
% YYY = H_tprod(H_tprod(ut,st),H_tran(vt));
% u_t=ut(:,1:3,:,:,:,:,:,:,:,:);
% s_t=st(1:3,1:3,:,:,:,:,:,:,:,:);
% v_t=vt(:,1:3,:,:,:,:,:,:,:,:);
u_t=ut(:,1:R,:,:);
s_t=st(1:R,1:R,:,:);
v_t=vt(:,1:R,:,:);
YY = H_tprod(H_tprod(u_t,s_t),H_tran(v_t));
YY=YY.*(~Qt)+Yt_miss;
Yh_2 = reshape(YY,[512,512,3]);
imagesc(Yh_2)
drawnow
fprintf('Iteration: %d', i)
eval_rec(Yh,Y)
end

subplot(1,4,1)
imshow(Y)
title('Original Image','FontSize',10)
subplot(1,4,2)
imshow(Y_miss)
title('Missing Image','FontSize',10)
subplot(1,4,3)
imshow(Yh)
title('Proposed','FontSize',10)
subplot(1,4,4)
imshow(Yh_2)
title('T-SVD','FontSize',10)
%%
eval_rec(Yh_2,Y)
eval_rec(Yh,Y)

function Perf_ = eval_rec(Y,Ym)

% Assess performance of denoising
Perf_  = {};
for metrix = {'MSE' 'PSNR' 'SSIM'}
    perf_ = metrix_mux(Y*255,double(Ym)*255,metrix{1});
    Perf_ = [Perf_ ; metrix {perf_}];
end
end
