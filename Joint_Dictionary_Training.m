function [D_h,D_l]=Joint_Dictionary_Training(Y,X,dsize,lambda)
%Joint_Dictionary_Training : learn dictionaries for high-resolution and low-resolution image patches
%Input :
%        Y      = low-resolution image patches
%        X      = high-resolution image patches
%        dsize  = the size of dictionary
%        lambda = sparsity regularization
%Output: 
%        D_l    = dictionary trained from low-resolution patches
%        D_h    = dictionary trained from high-resolution patches
%Add the folder,which contains functions written by authors of 
%the paper and other paper,to the search path
addpath(genpath('RegularizedSC'));
M=size(Y,1);
N=size(X,1);
%Normalize
Norm_Y=sqrt(sum(Y.^2));
Norm_X=sqrt(sum(X.^2));
Index=find(Norm_Y & Norm_X);
Y=Y(:,Index);
X=X(:,Index);
Y=Y./repmat(sqrt(sum(Y.^2)),size(Y,1),1);
X=X./repmat(sqrt(sum(X.^2)),size(X,1),1);
%Joint
X_c=[sqrt(N)*X;sqrt(M)*Y]; %(25)
Norm_X_c=sqrt(sum(X_c.^2,1));
%Training
X_c=X_c(:,Norm_X_c>1e-5);
X_c=X_c./repmat(sqrt(sum(X_c.^2,1)),N+M,1);
[D]=reg_sparse_coding(X_c,dsize,[],0,lambda,40);
D_h=D(1:N,:);%(25)
D_l=D(N+1:end,:);









