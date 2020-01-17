function [ix,iy] = findLiverOutline(im, center)
%This function finds the outline of the liver in rectangular coordinates
%[ix,iy]

lSpoke = 110; %spoke length
nAng = 360; %number of angles
IM=double(im);
[linesI, lCoords] = SampleSpokes(IM, nAng, lSpoke, center);

I_spoke1 = uint8(linesI); %Polar image

Ithr = I_spoke1;
Ithr(Ithr>150)=0;

%Use smoothing filter (gaussian)
h = fspecial('gaussian', 3, 1);
Igauss = imfilter(Ithr,h,'replicate');

%Use sobel filter to enhance edges
sobel = fspecial('sobel'); 
Iedge = imfilter(Igauss,sobel');

%Cost image
costI = 255 - Iedge;

% The cost matrix needs to be of type double
Brd = doDP(double(costI)); %Gives column indices for each row, where the dynamic programming line goes through

[ix,iy] = dpConvertPolar(nAng, lCoords, Brd);


