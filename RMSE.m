function [rmse]=RMSE(img1,img2)
%RMSE  : evaluate the results visually and qualitatively in Root Mean Square Error
%Input : img1 = input image1
%      : img2 = input image2
%Output: rmse = evalution in Root Mean Square Error
%Convert RGB image to YCbCR if necessary
if size(img1,3)==3
    img1=rgb2ycbcr(img1);
    img1=img1(:,:,1);
end
if size(img2,3)==3
    img2=rgb2ycbcr(img2);
    img2=img2(:,:,1);
end
%Calculate RMSE between img1 and img2
diff=double(img1)-double(img2);
diff=diff(:);
rmse=sqrt(mean(diff.^2));

