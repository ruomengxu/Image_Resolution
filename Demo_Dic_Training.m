%Demo of dictionary training
%Input parameters
dsize=256;
lambda=0.15;
patchsize=3;
patchnum=100000;
upscale=2;
type='*.bmp';
threshold=10;
%Add path
addpath(genpath('RegularizedSC'));
%Training image path
Img_Path='Data/Training';
%Get random sample image patches
[X,Y]=r_sample_patch(Img_Path,type,patchsize,patchnum,upscale);
%Prune patches
[X,Y]=patch_prune(X,Y,threshold);
%Training
[D_h,D_l]=Joint_Dictionary_Training(Y,X,dsize,lambda);
%Save Dictionary
Dic_Path=['Dictionary/D_' num2str(dsize) '_' num2str(lambda) '_' num2str(patchsize) '.mat'];
save(Dic_Path,'D_h','D_l');  

clear;
test;


