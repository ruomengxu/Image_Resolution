%Demo of Image Super-Resolution Via Sparse Representation
%Input initial parameters
tic
lambda=0.1;                   % sparsity regularization
overlap=2;                    % overlap pixel
upscale=2;                    % scaling factor
Iter=20;                      % Iteration time
%Load demo image
Img_l=imread('Data/Testing/Lena_L.bmp');
Img_L=Img_l;
%Load dictionary
load('Dictionary/D_1024_0.15_3.mat');
%Convert
Img_l_ycbcr=rgb2ycbcr(Img_l);
Img_l_y=Img_l_ycbcr(:, :, 1);
Img_l_cb=Img_l_ycbcr(:, :, 2);
Img_l_cr=Img_l_ycbcr(:, :, 3);
%SR
[Img_h_y]=SR(Img_l_y,upscale,D_h,D_l,lambda,overlap);
[Img_h_y]=back_projection(Img_h_y,Img_l_y,Iter);
%Upscale
[row,col]=size(Img_h_y);
Img_h_cb=imresize(Img_l_cb,[row,col],'bicubic');
Img_h_cr=imresize(Img_l_cr,[row,col],'bicubic');
Img_h_ycbcr=zeros([row, col,3]);
Img_h_ycbcr(:,:,1) =Img_h_y;
Img_h_ycbcr(:,:,2) =Img_h_cb;
Img_h_ycbcr(:,:,3) =Img_h_cr;
Img_h=ycbcr2rgb(uint8(Img_h_ycbcr));
%Load original image
Img=imread('Data/Testing/Lena_O.bmp');
%cubic
Img_b=imresize(Img_l,[row,col],'bicubic');
%Compute RMSE
rmse_h=RMSE(Img,Img_h);
rmse_b=RMSE(Img,Img_b);
fprintf('RMSE for SR: %f \n', rmse_h);
fprintf('RMSE for BI: %f \n', rmse_b);
%Show images
subplot(1,3,1);
imshow(Img_L);
title('Low-resolution Image');
subplot(1,3,2);
imshow(Img_h);
t=['High-resolution Image(RMSE:',num2str(rmse_h),')'];
title(t);
subplot(1,3,3);
imshow(Img_b);
t=['Bicubic Interp Image(RMSE:',num2str(rmse_b),')'];
title(t);
toc