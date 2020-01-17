%% Exercise 3
clc;
clear all;
close all;


%% Initial analysis
vb = imread('vertebra.png');
imshow(vb);
figure, imhist(vb);

% Is the histogram bimodal? The histogram is roughly bimodal, with the
% background on the left side and bone on the right side. The higher
% intensity signal seems to be divided into two small peaks. Between the
% low intensity background and high intensity bone we have a somewhat
% constant contribution, arising from the combination of some bone and
% tissue i.e. around the neck. 

% Minimum value
min_val = min(min(vb));

% Maximum value
max_val = max(max(vb));


%% Exercise 1

help mean2
% What does mean2 do? mean2(A) computes the average of the matrix elements
% in matrix A.

% The function mean2 has input x and output y. It takes the sum of all
% elements in x, x(:), and divides by the number of elements in x using the function numel. It
% outputs the answer in format double.

av_val = mean2(vb);

%% Exercise 2

% Create function HistStretch.m

Io = HistStretch(vb);


figure
subplot(1,2,1); imshow(vb), title('Original x-ray');
subplot(1,2,2); imshow(Io), title('Image after histogram stretching')

% What changes do you see? Contrast looks better and vertebra are a little
% clearer.

%% Exercise 3
% Gamma curves

% We want to plot a gamma curve for three values of gamma over the range x
% = [0,1];

gamma_val = [0.48, 1, 1.52];

x = linspace(0,1,100);          % Create a vector with 100 points between 0 and 1

figure
hold on
for i = 1 : 3
    gamma = gamma_val(i);
    y = x.^gamma;
    plot(x,y)
end
hold off
title('Gamma curves')
legend('gamma = 0.48', 'gamma = 1', 'gamma = 1.52');


%% Exercise 4

% Create function GammaMap

% Perform mapping with different values of gamma_val, defined above
vb_g1 = GammaMap(vb, gamma_val(1));
vb_g2 = GammaMap(vb, gamma_val(2));
vb_g3 = GammaMap(vb, gamma_val(3));

% Show the results next to the original
figure
subplot(2,2,1); imshow(vb), title('Original x-ray');
subplot(2,2,2); imshow(vb_g1), title('Gamma = 0.48')
subplot(2,2,3); imshow(vb_g2), title('Gamma = 1 (same as original)')
subplot(2,2,4); imshow(vb_g3), title('Gamma = 1.52')

% Gamma = 1.52 seems nice for contrast. It makes the dark pixels darker.



%% Exercise 5

doc imadjust;

% If no input parameters are stated, the function imadjust maps the intensity values in an image such that the
% 1% of the data is at the lowest and highest intensities (0 and 1). This
% increases the contrast of the image.
vb_autoadjust = imadjust(vb);

% If input parameters are stated, an intensity mapping is performed
% according to the low and high limits that you state. These must be between 0 and 1. See the
% documentation.

vb_adjusted = imadjust(vb, [0.5 1], []);
imshow(vb_adjusted);

%% Exercise 6
% Create function ImageThreshold
vb_thresh = ImageThreshold(vb,195);
imagesc(vb_thresh), colormap gray;      % I use imagesc here for automatic adjustment of the intensity limits.
%imshow(vb_thresh), caxis([0 1]);


% Perform mapping with different values of gamma_val, defined above
vb_t1 = ImageThreshold(vb, 100);
vb_t2 = ImageThreshold(vb, 185);
vb_t3 = ImageThreshold(vb, 200);

% Show the results next to the original
figure
subplot(2,2,1); imshow(vb), title('Original x-ray');
subplot(2,2,2); imshow(vb_t1), caxis([0 1]), title('Threshold 100')
subplot(2,2,3); imshow(vb_t2), caxis([0 1]), title('Threshold 185')
subplot(2,2,4); imshow(vb_t3), caxis([0 1]), title('Threshold 200')


%It seems difficult to segment veretbra just by thresholding


%% Exercise 7

doc graythresh

% The function, graythresh, computes a global threshold that is used to
% convert the grayscale image to a binary image. The threshold is between
% [0, 1]

threshlvl = graythresh(vb);

% Convert threshold between 0 and 1, to threshold between 0 and 255.
thresh = threshlvl * 255;       % Finds 148

% Use our own function to look at thresholded image
thresh_vb = ImageThreshold(vb, thresh);
imshow(thresh_vb), caxis([0,1])

% Look at histogram again. Why is 148 chosen to be the threshold?
imhist(vb)


%% Exercise 8


% See instructions

%% Exercise 9

imtool(vb)


%% Color Thresholding in RGB Space

% Make a tool to segment the red sign
im = imread('DTUSigns2.jpg');
imshow(im);
Rcomp = im(:,:,1);
Gcomp = im(:,:,2);
Bcomp = im(:,:,3);

% Create a binary segmentation image based on the RGB components in the original image
red_segm = Rcomp > 130 & Bcomp < 65 & Gcomp < 65;
figure;
imshow(red_segm,[]);



%% Color Thresholding in HSI/HSV Space
    
% Segment both blue and red sign

HSV = rgb2hsv(im);
imshow(HSV)
Hcomp = HSV(:,:,1);
Scomp = HSV(:,:,2);
Vcomp = HSV(:,:,3);

blue_segm = Hcomp > 0.5 & Scomp > 0.8 & Vcomp > 0.7;

red_segm = Hcomp > 0.6 & Scomp > 0.6 & Scomp < 0.7 & Vcomp > 0.6 & Vcomp < 0.7;

figure,
subplot(1,2,1), imshow(blue_segm,[]), title('Blue Sign') 
subplot(1,2,2), imshow(red_segm,[]), title('Red Sign') 

