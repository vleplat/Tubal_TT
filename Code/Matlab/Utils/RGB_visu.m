function RGB = RGB_visu(V,spec)

%RGB visualization
%clc;close all;
[r c w] = size(V);
rgbImage = cat(3,V(:,:,spec(1)),V(:,:,spec(2)),V(:,:,spec(3)));
XYZ = reshape(rgbImage, r*c, 3);
XYZ = max(XYZ, 0);
XYZ = XYZ/max(XYZ(:));
RGB = XYZ2sRGB_exgamma(XYZ);
RGB = max(RGB, 0);
RGB = min(RGB, 1);
RGB=reshape(RGB.^0.6,r,c,[]);




