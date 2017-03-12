function [X,Y]=r_sample_patch(path,type,patchsize,patchnum,upscale)
%r_sample_patch : get sample image patches
%Input : 
%       path     = the path of training image file
%       type     = the type of training image
%       patchsize= image patch size
%       patchnum = number of patches to sample
%       upscale  = upscaling factor
%Output :
%       X        = high-resolution image patches
%       Y        = low-resolution image patches
X=[];
Y=[];
content=dir(fullfile(path,type));
img_num=length(content);
n_img=zeros(1,img_num);
for i=1:1:img_num
    img=imread(fullfile(path,content(i).name));
    n_img(i)=numel(img);
end
n_img=floor(n_img*patchnum/sum(n_img));
for i=1:1:img_num
    patch_num=n_img(i);
    img=imread(fullfile(path,content(i).name));
    [Hpatch,Lpatch]=sample_patch(img,patchsize,patch_num,upscale);
    X=[X,Hpatch];
    Y=[Y,Lpatch];
end