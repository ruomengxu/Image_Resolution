function [Img_h] = SR(Img_l, upscale, D_h, D_l, lambda, overlap)
%SR : SR via Sparse Representation
%Input : 
%       Img_l   = the low-resolution image
%       upscale = scaling factor, depending on the trained dictionary
%       D_h     = dictionary trained from high-resolution image patches
%       D_l     = dictionary trained from low-resolution image patches
%       lambda  = sparsity regularization
%       overlap = number of overlap pixel
%Output:
%        Img_h   = the output image after SR via Sparse Representation
%Add path
addpath(genpath('RegularizedSC'));
patchsize=sqrt(size(D_h,1));
%Normalize
Norm_D_l=sqrt(sum(D_l.^2,1)); 
D_l=D_l./repmat(Norm_D_l,size(D_l,1),1);
%Cubic interpolation
Img_m=single(imresize(Img_l,upscale,'bicubic'));
Img_h=zeros(size(Img_m));
M=zeros(size(Img_m));
[row, col] = size(Img_m);
%Extract gradient features
Img_m_f=zeros([row,col,4]);
f1=[-1 0 1];
f2=f1';
f3=[1 0 -2 0 1];
f4=f3';
Img_m_f(:,:,1)=conv2(Img_m,f1,'same');
Img_m_f(:,:,2)=conv2(Img_m,f2,'same');
Img_m_f(:,:,3)=conv2(Img_m,f3,'same');
Img_m_f(:,:,4)=conv2(Img_m,f4,'same');
%Get patch index
gridx=3:patchsize-overlap:col-patchsize-2;
gridx=[gridx,col-patchsize-2];
gridy=3:patchsize-overlap:row-patchsize-2;
gridy=[gridy,row-patchsize-2];
%Algorithm 1 step 2
A=D_l'*D_l;
for i=1:length(gridx),
    for j=1:length(gridy),
        x=gridx(i);
        y=gridy(j);
        Patch_m=Img_m(y:y+patchsize-1,x:x+patchsize-1);
        Mean_m=mean(Patch_m(:));
        Patch_m=Patch_m(:)-Mean_m;
        Norm_m=sqrt(sum(Patch_m.^2));
        Patch_m_f=Img_m_f(y:y+patchsize-1,x:x+patchsize-1,:);   
        Patch_m_f=Patch_m_f(:);
        Norm_m_f=sqrt(sum(Patch_m_f.^2));
        if Norm_m_f > 1,
            b=-D_l'*(Patch_m_f./Norm_m_f);
        else
            b=-D_l'*Patch_m_f;
        end
        col=L1QP_FeatureSign_yang(lambda,A,b);
        Patch_h=D_h*col;
        Norm_h=sqrt(sum(Patch_h.^2));
        if Norm_h,
            Patch_h=Patch_h.*(Norm_m*1.2/Norm_h);
        end
        Patch_h=reshape(Patch_h,[patchsize, patchsize]);
        Patch_h=Patch_h+Mean_m;
        Img_h(y:y+patchsize-1,x:x+patchsize-1)=Img_h(y:y+patchsize-1,x:x+patchsize-1)+Patch_h;
        M(y:y+patchsize-1,x:x+patchsize-1)=M(y:y+patchsize-1,x:x+patchsize-1)+1;
    end
end
Index=(M< 1);
Img_h(Index)=Img_m(Index);
M(Index)=1;
Img_h=uint8(Img_h./M);
