function [Img]=generate_low_resolution(Input,upscale)
%generate_low_resolution : Generate the low-resolution version of the
%input image
%Input :
%       Input   = the original image
%       Upscale = upscaling factor 
%Output:
%       Img     = the low-resolution counter parts
%Convert if necessary
%Generate low-resolution image
Img=imresize(Input,1/upscale,'bicubic');
imwrite(Img,'ST_l.jpg','jpg')

