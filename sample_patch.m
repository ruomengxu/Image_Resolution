function [HP,LP]=sample_patch(img,patchsize,patchnum,upscale)
%smaple_patch: get sample patches
%Input : 
%       img      = the input image
%       patchsize= image patch size
%       patchnum = image patch number
%       upscale  = upscaling factor
%Output : 
%       Hpatch   = the high-resolution patches
%       Lpatch   = the low-resolution patches

%Convert if necessary
if size(img,3)==3
    HImg=rgb2gray(img);
else
    HImg=img;
end
%Generate low-resolution image
LImg=imresize(HImg,1/upscale,'bicubic');
LImg=imresize(LImg,size(HImg),'bicubic');
[row,col]=size(HImg);
%Random permutation
x=randperm(row-2*patchsize-1)+patchsize;
y=randperm(col-2*patchsize-1)+patchsize;
[X,Y]=meshgrid(x,y);
X=X(:);
Y=Y(:);
if patchnum<length(X)
    X=X(1:patchnum);
    Y=Y(1:patchnum);
end
patchnum=length(X);
HImg=double(HImg);
LImg=double(LImg);
%Extract gradient features
f1=[-1 0 1];f2=f1';f3=[1 0 -2 0 1];f4=f3';%(26)
LImgG11=conv2(LImg,f1,'same');
LImgG12=conv2(LImg,f2,'same');
LImgG21=conv2(LImg,f3,'same');
LImgG22=conv2(LImg,f4,'same');
%Get sample patches
for i=1:1:patchnum
    row=X(i);
    col=Y(i);
    Hpatch=HImg(row:row+patchsize-1,col:col+patchsize-1);
    Lpatch_1=LImgG11(row:row+patchsize-1,col:col+patchsize-1);
    Lpatch_2=LImgG12(row:row+patchsize-1,col:col+patchsize-1);
    Lpatch_3=LImgG21(row:row+patchsize-1,col:col+patchsize-1);
    Lpatch_4=LImgG22(row:row+patchsize-1,col:col+patchsize-1);
    Lpatch=[Lpatch_1(:),Lpatch_2(:),Lpatch_3(:),Lpatch_4(:)];
    Lpatch=Lpatch(:);
    HP(:,i)=Hpatch(:)-mean(Hpatch(:));
    LP(:,i)=Lpatch;
end




