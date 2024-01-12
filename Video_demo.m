%% Tubal TT
%foreman_qcif
%akiyo_qcif
%news_qcif
clear all
clc
close all;
videoSequence = 'akiyo_qcif.yuv'; 
width  = 176;
height = 144;
nFrame = 300;
[Y,U,V] = yuvRead(videoSequence, width, height ,nFrame); 
Y=double(Y);

Y=Y(:,:,1:300);

%Y=reshape(Y,[4,4,9,4,4,11,3,4,5,5]);
% imfile = 'pepper.tiff';
% s1rgb = imread(imfile);
% [pp,imname,ex] = fileparts(imfile);
% Y = im2double(s1rgb) ;
% Y = imresize(Y,[512 512]);
% subplot(1,3,1)
% imshow(Y)
%%

szY = size(Y);
d = log2(szY(1));

% % Reshape to tensor of order-d
% szYt = [2*ones(1,d*2) 3];
% Yt = reshape(Y,szYt);
% ordix = reshape(reshape(1:2*d,d,2)',1,[]);
% ordix = [ordix([1 2])  ordix(3:end) 2*d+1];
% Yt = permute(Yt,ordix);
% szYt2 = [4*ones(1,d) 3];
%szYt2=[4,4,9,4,4,11,4,15,5];
szYt2=[4,4,9,4,4,11,3,4,5,5];
Yt = reshape(Y,szYt2);

%ftensor2image = @(Yx) reshape(ipermute(reshape(Yx,szYt(ordix)),ordix),szY);
%% Run DMRG two core update
% 

% opts = ttmps_a2cu();
% opts.compression = false;
% [Yt_dmrg,output] = tubtt_a2cu(Yt,r,opts);
% Yt_dmrgfull = full_tubtt(Yt_dmrg.U);
% 
% %Visualize
% Yxm = ftensor2image(Yt_dmrgfull);
% 
% err_ttsvd = norm(Y(:) - Yxm(:) )/norm(Y(:))
% noparams = sum(cellfun(@(x) numel(x),Yt_dmrg.U,'uni',1));
% 
% fprintf('Number of parameters of TTT-DMRG %d   error %.3d \n ',noparams,err_ttsvd)
% 
% Perf_ = eval_rec(Y,Yxm);
% fprintf('Denoising result \n')
% fprintf('MSE %.2f dB \n', Perf_{1,2})
% fprintf('PSNR %.2f dB \n', Perf_{2,2})
% fprintf('SSIM %.4f \n', Perf_{3,2})


% fig = figure(2);
% clf
% imagesc(Yxm)
% axis image
% axis off
%% TubTT with approximation error given 

opts = ttmps_a2cu();
opts.compression = false;

%min  \|Y - X\|_F  <= noise_level^2 * numel(Y)
relative_error = 0.1;
opts.noise_level = relative_error^2*norm(Yt(:))^2;

tic
[Yt_dmrg,output] = tubtt_a2cu(Yt,[],opts);
toc
Yt_dmrgfull = full_tubtt(Yt_dmrg.U);

%Visualize
% Yxm = ftensor2image(Yt_dmrgfull);
Yxm=reshape(Yt_dmrgfull,size(Y));

err_ttsvd = norm(Y(:) - Yxm(:) )/norm(Y(:))
noparams = sum(cellfun(@(x) numel(x),Yt_dmrg.U,'uni',1));

fprintf('Number of parameters of tubalTT fixed tolerance %d   error %.3d \n ',noparams,err_ttsvd)

% Perf_ = eval_rec(Y,Yxm);
% fprintf('Denoising result \n')
% fprintf('MSE %.2f dB \n', Perf_{1,2})
% fprintf('PSNR %.2f dB \n', Perf_{2,2})
% fprintf('SSIM %.4f \n', Perf_{3,2})
% 
% 
% fig = figure(3);
% clf
% imagesc(Yxm)
% axis image
% axis off
% for i=1:300
% imshow(uint8(Yxm(:,:,i)));
% drawnow
% end
PS=[];
for i=1:300
    PS=[PS,PSNR(Y(:,:,i),Yxm(:,:,i))];
end
%subplot(1,2,1)
plot(PS,'LineWidth',4)
ylabel('PSNR')
hold on
PS=[];
yyaxis right
for i=1:300
    PS=[PS,ssim(Y(:,:,i),Yxm(:,:,i))];
end
plot(PS,'LineWidth',4)
ylabel('SSIM')


% t=0;
% for i=1:9
%     t=t+numel(Yt_dmrg.U{i});
% end
% numel(Y)/t
hold on
%% TT 

opts = ttmps_a2cu();
opts.compression = false;

%min  \|Y - X\|_F  <= noise_level^2 * numel(Y)
relative_error = 0.1;
opts.noise_level = relative_error^2*norm(Yt(:))^2;
tic
[Ytx2,output] = ttmps_a2cu(Yt,[],opts);
toc
Ytxf= full(Ytx2);
%Yxm = ftensor2image(Ytxf);
Yxm_2=reshape(Ytxf,size(Y));

%Visualize
err_ttsvd = norm(Y(:) - Yxm_2(:) )/norm(Y(:))
noparams = sum(cellfun(@(x) numel(x),Ytx2.U,'uni',1));
% t=0;
% for i=1:9
%     t=t+numel(Yxm_2.U{i});
% end
% numel(Y)/t

fprintf('Number of parameters of TTSVD %d   error %.3d \n ',noparams,err_ttsvd)

% Perf_ = eval_rec(Y,Yxm);
% fprintf('Denoising result \n')
% fprintf('MSE %.2f dB \n', Perf_{1,2})
% fprintf('PSNR %.2f dB \n', Perf_{2,2})
% fprintf('SSIM %.4f \n', Perf_{3,2})

% for i=1:300
% imshow(uint8(Yxm(:,:,i)));
% drawnow
% end
%clear PS
PS_2=[];
for i=1:300
    PS_2=[PS_2,PSNR(Y(:,:,i),Yxm_2(:,:,i))];
end
% subplot(1,2,2)
yyaxis left
plot(PS_2,'LineWidth',4)
% fig = figure(4);
% clf
% imagesc(Yxm)
% axis image
% axis off
PS_2=[];
hold on
yyaxis right
for i=1:300
    PS_2=[PS_2,ssim(Y(:,:,i),Yxm_2(:,:,i))];
end
plot(PS_2,'LineWidth',4)
xlabel('Number of frames')
legend('Proposed Algorithm', 'Proposed Algorithm','TT-based method','TT-based method')
% t=0;
% for i=1:9
%     t=t+numel(Ytx2.U{i});
% end
% numel(Y)/t


%%
function Perf_ = eval_rec(Y,Ym)

% Assess performance of denoising
Perf_  = {};
for metrix = {'MSE' 'PSNR' 'SSIM'}
    perf_ = metrix_mux(Y*255,double(Ym)*255,metrix{1});
    Perf_ = [Perf_ ; metrix {perf_}];
end
end
