load KSC.mat
% Pay attention as the 20 channels have not been removed originally, there,
% it is performed here-under:
load KSC_spec.mat;
X=KSC(50:50+360-1,50:50+360-1,:); % take the subimage 120x120 pixels
V=double(X);  % convert to double format
save('V.mat','V')