function RGB = RGB_visu(V)

%RGB visualization
%clc;close all;
[r c w] = size(V);
rgbImage = cat(3,V(:,:,1),V(:,:,12),V(:,:,26));
XYZ = reshape(rgbImage, r*c, 3);
XYZ = max(XYZ, 0);
XYZ = XYZ/max(XYZ(:));
RGB = XYZ2sRGB_exgamma(XYZ);
RGB = max(RGB, 0);
RGB = min(RGB, 1);
RGB=reshape(RGB.^0.6,r,c,[]);




