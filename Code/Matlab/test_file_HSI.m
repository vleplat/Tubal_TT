clear all;close all;clc

%% ------------------------------------------------------------------------
% Add libraries and data sets
%%-------------------------------------------------------------------------
% addpath('./DataSets/Samson/')
% addpath('./DataSets/')
% addpath('./Libraries/Tensor-tensor-product-toolbox-master/tproduct toolbox 1.0/')
addpath(genpath(pwd))
%% ------------------------------------------------------------------------
% Data loading and misc. init.
%%-------------------------------------------------------------------------
%%% Urban HSI data set
% load Urban.mat;
% mx = 307;
% my = 307;

%%% Moffet data set
% load Moffet.mat;
% mx = 50;
% my = 50;

%%% Uncomment below for previous HSI
% [spec_bands,b] = size(X);
% Y = X;
% clear X;
% Y = reshape(Y',[mx my spec_bands]);

%%% Kennedy space center data set
% load V.mat;
% mx = 360;
% my = 360;
% Y = V;
% clear V;


%%% Pavia HSI data set
load PaviaU.mat;
Y = paviaU;
clear paviaU;

% urban relerror: 0.08 | 0.062 vs 0.08 
% Y = Y(30:30+249,30:30+249,:);   

% urban with lower order folding: 0.038 vs 0.04
% Y = Y(1:300,1:300,1:160);

% moffet relerror:  0.02   | 0.012 vs 0.02 
% Y = Y(:,:,1:150); 

% KSC: 0.05  and 0.02
% Y = Y(55:55+249,55:55+249,1:160);

% PaviaU: 0.08         | 0.076 vs 0.08
Y = Y(1:600,:,1:100);   

sizeY = size(Y);


%%% Init arrays and variables for post-processing stage
algorithmNum = 2;
runtime = zeros(algorithmNum,1);
%% ------------------------------------------------------------------------
% Trasnform into N-th order tensor
%%-------------------------------------------------------------------------
% szY = size(Y);
% d = round(log2(szY(1)));
% % Reshape to tensor of order-d
% szYt = [3*ones(1,2*d) 3];
% Yt = reshape(Y,szYt);
% ordix = reshape(reshape(1:2*d,d,2)',1,[]);
% ordix = [ordix([1 2])  ordix(3:end) 2*d+1];
% Yt = permute(Yt,ordix);
% szYt2 = [4*ones(1,d) 3];
szYt2 = factor(prod(sizeY));
% szYt2 = 10*ones(1,7); %only with second setting of urban
Yt = reshape(Y,szYt2);

% ftensor2image = @(Yx) reshape(ipermute(reshape(Yx,szYt(ordix)),ordix),szY);
ftensor2image = @(Yx) reshape(Yx,sizeY);

%% ------------------------------------------------------------------------
% Call of Tubal TT model
%%-------------------------------------------------------------------------

opts = ttmps_a2cu();
opts.compression = false;

%min  \|Y - X\|_F  <= noise_level^2 * numel(Y)
relative_error = 0.08;
opts.noise_level = relative_error^2*norm(Yt(:))^2;
% opts.activateRSVD = 1;
opts.n_subspace_iters = 1;
start = tic;
[Yt_dmrg,output_ttt] = tubtt_a2cu(Yt,[],opts); %proposed
runtime(1) = toc(start);
Yt_dmrgfull = full_tubtt(Yt_dmrg.U);       

%Visualize
Yxm_ttt = ftensor2image(Yt_dmrgfull);

err_tttsvd = norm(Y(:) - Yxm_ttt(:) )/norm(Y(:));
noparams = sum(cellfun(@(x) numel(x),Yt_dmrg.U,'uni',1));

fprintf('Number of parameters of tubalTT fixed tolerance %d   error %.3d \n ',noparams,err_tttsvd)



%% ------------------------------------------------------------------------
% Call of  TT model
%%-------------------------------------------------------------------------

opts = ttmps_a2cu();
opts.compression = false;

%min  \|Y - X\|_F  <= noise_level^2 * numel(Y)
relative_error = 0.08;
opts.noise_level = relative_error^2*norm(Yt(:))^2;
start = tic;
[Ytx2,output_tt] = ttmps_a2cu(Yt,[],opts);
runtime(2) = toc(start);
Ytxf= full(Ytx2);
Yxm_tt = ftensor2image(Ytxf);

%Visualize
err_ttsvd = norm(Y(:) - Yxm_tt(:) )/norm(Y(:));
noparams = sum(cellfun(@(x) numel(x),Ytx2.U,'uni',1));

fprintf('Number of parameters of TTSVD %d   error %.3d \n ',noparams,err_ttsvd)



%% ------------------------------------------------------------------------
% Post-processing
%%-------------------------------------------------------------------------
close all;
%Blue Green Red
bands = [1 12 26];          %urban:[1 12 26], Parvia ? 
RGB = RGB_visu(Y,bands); 
%%% Display RGB-like images
figure;
subplot(1,3,1)
imshow(RGB); title('Original Image','FontSize',10)
axis image
axis off
subplot(1,3,2)
imshow(RGB_visu(Yxm_tt,bands)); title('TT model','FontSize',10)
axis image
axis off
subplot(1,3,3)
imshow(RGB_visu(Yxm_ttt,bands)); title('Proposed model','FontSize',10)
axis image
axis off

%%% Metric computation
PSNR = zeros(algorithmNum,1);
SAM = zeros(algorithmNum,1);
RMSE = zeros(algorithmNum,1);
UIQI = zeros(algorithmNum,1);
ERGAS = zeros(algorithmNum,1);

[PSNR(1,1),RMSE(1,1),ERGAS(1,1),SAM(1,1),UIQI(1,1),psnr_TTT,sam_TTT,mse_TTT] = ...
            quality_assessment(Y,Yxm_ttt,0,1);
% fprintf('(Tubal TT) time: %gs, PSNR: %g, SAM: %g.\n',...
%             runtime(1,1),PSNR(1,1),SAM(1,1));
[PSNR(2,1),RMSE(2,1),ERGAS(2,1),SAM(2,1),UIQI(2,1),psnr_TT,sam_TT,mse_TT] = ...
            quality_assessment(Y,Yxm_tt,0,1);
% fprintf('(TT) time: %gs, PSNR: %g, SAM: %g.\n',...
%             runtime(2,1),PSNR(2,1),SAM(2,1));

figure;benchMarkTable(runtime,PSNR,RMSE,ERGAS,SAM,UIQI)


%%% Display SAM MAPS
h3 = subplott(1,2);
CLIM = [0 20];
imagesc(sam_TTT,'parent',h3(1),CLIM)
imagesc(sam_TT,'parent',h3(2),CLIM)
colormap jet