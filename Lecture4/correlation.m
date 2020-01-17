function [outputArg1] = correlation(image,template)
%compute the normalised cross correlation.
% 
%num_temp=imfilter(image,template);
num_temp=image.*template;
num=sum(num_temp(:));
image_patch=image.*image;
image_patch=sum(image_patch(:));
template_length=template.*template;
template_length=sum(template_length(:));
den1=sqrt(image_patch);
den2=sqrt(template_length);
den=den1*den2;
outputArg1 = num/den;

end

