% Written by Kai Zhang,
% For further information, please contact: zhkmath@163.com
% More matlab codes can be found from: http://www.mathworks.com/matlabcentral/fileexchange/?term=authorid%3A635779
% My homepage is: https://sites.google.com/site/cskaizhang/home
%
% The code is used in the following paper:
%
% [1] Kai Zhang, Baoquan Wang, Wangmeng Zuo,  Hongzhi Zhang, and Lei Zhang, "Joint Learning of Multiple
% Regressors for Single Image Super-Resolution", to appear in IEEE SIGNAL PROCESSING LETTERS, 2016.

% [2] Zhang, Kai, et al. "Revisiting Single Image Super-Resolution Under Internet Environment: Blur Kernels
% and Reconstruction Algorithms." Advances in Multimedia Information Processing. Springer International
% Publishing, 2015. 677-687.
%
% Please cite the papers if you use this code.

function [I] = zoom_function(I,upperleft_pixel,box,zoomfactor,zoom_position)

y       = upperleft_pixel(1);
x       = upperleft_pixel(2);
box1    = box(1);
box2    = box(2);

s_color = [255 255 255];
l_color = [255 255 255];

nline   = 2;

[~, ~, hw]  =  size(I);

if hw == 1
    I = repmat(I,[1,1,3]);
end

Imin = I(x:x+box1-1,y:y+box2-1,:);
I(x-nline:x+box1-1+nline,y-nline:y+box2-1+nline,1) = s_color(1);
I(x-nline:x+box1-1+nline,y-nline:y+box2-1+nline,2) = s_color(2);
I(x-nline:x+box1-1+nline,y-nline:y+box2-1+nline,3) = s_color(3);
I(x:x+box1-1,y:y+box2-1,:) = Imin;
Imax = imresize(Imin,zoomfactor,'nearest');

switch lower(zoom_position)
    case {'uper_left','ul'}
        
        I(1:2*nline+zoomfactor*box1,1:2*nline+zoomfactor*box2,1) = l_color(1);
        I(1:2*nline+zoomfactor*box1,1:2*nline+zoomfactor*box2,2) = l_color(2);
        I(1:2*nline+zoomfactor*box1,1:2*nline+zoomfactor*box2,3) = l_color(3);
        I(1+nline:zoomfactor*box1+nline,1+nline:zoomfactor*box2+nline,:) = Imax;
        
    case {'uper_right','ur'}
        
        I(1:2*nline+zoomfactor*box1,end-2*nline-zoomfactor*box2+1:end,1) = l_color(1);
        I(1:2*nline+zoomfactor*box1,end-2*nline-zoomfactor*box2+1:end,2) = l_color(2);
        I(1:2*nline+zoomfactor*box1,end-2*nline-zoomfactor*box2+1:end,3) = l_color(3);
        I(1+nline:zoomfactor*box1+nline,end-nline-zoomfactor*box2+1:end-nline,:) = Imax;
        
    case {'lower_left','ll'}
        
        I(end-2*nline-zoomfactor*box1+1:end,1:2*nline+zoomfactor*box2,1) = l_color(1);
        I(end-2*nline-zoomfactor*box1+1:end,1:2*nline+zoomfactor*box2,2) = l_color(2);
        I(end-2*nline-zoomfactor*box1+1:end,1:2*nline+zoomfactor*box2,3) = l_color(3);
        I(end-nline-zoomfactor*box1+1:end-nline,1+nline:zoomfactor*box2+nline,:) = Imax;
        
    case {'lower_right','lr'}
        
        I(end-2*nline-zoomfactor*box1+1:end,end-2*nline-zoomfactor*box2+1:end,1) = l_color(1);
        I(end-2*nline-zoomfactor*box1+1:end,end-2*nline-zoomfactor*box2+1:end,2) = l_color(2);
        I(end-2*nline-zoomfactor*box1+1:end,end-2*nline-zoomfactor*box2+1:end,3) = l_color(3);
        I(end-nline-zoomfactor*box1+1:end-nline,end-nline-zoomfactor*box2+1:end-nline,:) = Imax;
        
end



