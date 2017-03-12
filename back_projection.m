function [img_h]=back_projection(img_h,img_l,IterNum)
%back_projection : minimizes the sum of the first and third terms of (11)(with small \lambda)
%Input :
%       img_h  = the high-resolution image
%       img_l  = the low-resolution image
%       IterNum= the max interation time
%Output:
%       img_h  = the high-resolution image after back projection operation
%Initialize
[row_l,col_l]=size(img_l);
[row_h,col_h]=size(img_h);
img_l=double(img_l);
img_h=double(img_h);
%Create gaussian lowpass filter
g=fspecial('gaussian',3,1);
g=g.^2;
g=g./sum(g(:));
%Interate
for i=1:1:IterNum
    img_m=imresize(img_h,[row_l,col_l],'bicubic');
    img_diff=img_l-img_m;
    img_diff=imresize(img_diff,[row_h,col_h],'bicubic');
    img_h=img_h+conv2(img_diff,g,'same');
end
    


