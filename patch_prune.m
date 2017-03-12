function [X,Y]=patch_prune(X,Y,threshold)
%patch_prune : prune patch with small variance
%Input : 
%        X        = random sample of high-resolution image patches
%        Y        = random sample of low-resolution image patches
%        threshold= threshold parameter setting for prune
%Output: 
%        X        = training data of high-resolution image patches after pruning
%        Y        = training data of low-resolution image patches after pruning
%Variance
variance=var(X,0,1);
Index=variance>threshold;
%Prune
X=X(:,Index);
Y=Y(:,Index);


