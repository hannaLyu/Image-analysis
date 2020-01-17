%% Exercise Session 1
clc
clear all
close all

%% Exercise 1

mc = imread('Data/metacarpals.png');

% size(mc)
% whos mc

%% Exercise 2
figure, imshow(mc);

% Why is the bone lighter around the edges? X-ray images are negative
% images -- the denser the matter, the lighter the image. Bones are more
% dense around the edges and hence appear lighter.

%% Exercise 3
imhist(mc);

[counts, x] = imhist(mc);

mostcommon = find(counts == max(counts));


%% Exercise 4
% Pixel value at (100,90)

mc(100,90)

%% Exercise 5
% Start simple image analysis tool
imtool(mc)

% Does most common intensity belong to BG?



%% Exercise 6
%Working with own image

I = imread('Data/horns.jpg');
I2 = imresize(I, 0.25);
imshow(I2);

% How to calculate factor of 0.25 automatically: 1000/max(size(I))


%% Exercise 7
% Examine single pixel
impixel(I2, 500, 400)
% OR I2(400,500,:)

%Transform to gray-level image
Igr = rgb2gray(I2);
figure, imshow(Igr);

% rgb2gray uses a weighted sum of the R, G and B components to calculate a
% grayscale value. 0.2989 * R + 0.5870 * G + 0.1140 * B
% Why these values? The aim is to preserve the luminance of the image
% during the conversion. In the end, the two images should have the same
% absolute luminance. The definition of luminance is defined using a
% standar model of human vision. See Wikipedia pay on Grayscale,
Igr(400,500)

%% Exercise 8
% Histogram of image: 
imhist(Igr)

%% Exercise 9
% Difference between flash and noflash? Take own photos here and compare
% histograms!

flash = imread('Data/flash.jpg');
flash = rgb2gray(flash);

noflash = imread('Data/noflash.jpg');
noflash = rgb2gray(noflash);

figure, imhist(flash), title('Flash');
figure, imhist(noflash), title('No flash');


%% Exercise 10 DICOM Images

% Examine header info

ctInf = dicominfo('Data/CTangio.dcm');
ctInf

% Toshiba manufactured the scanner

ct = dicomread('Data/CTangio.dcm');
whos ct

imshow(ct)  %not 8-bit int, so imshow does not scale too well. imshow(ct,[]) scales better. imagesc can scale image better
imtool(ct)

%% Exercise 11
% NOTICE: colormap does not work as stated in the instructions with
% funtion imshow. If using imshow, choose "Edit --> Colormap --> Tools -->
% Standard colormaps" to change the colormap. Otherwise use imagesc.


%imshow(mc)
imagesc(mc)
colormap(jet);



%% Colour channels

im1 = imread('DTUSign1.jpg');

Rcomp = im1(:,:,1);
figure;
imshow(Rcomp);
%colormap(gca, gray);

%The DTU Compute sign looks bright in red because it is red, and contains
%the most of this component. 

%% Simple Image Manipulation

im1(500:1000,800:1500,:)=0;


colormap(gca,gray)

imwrite(im1,'DTUSign1-marked.jpg');

%% Advanced Image Visualisation

fing = imread('finger.png');
imcontour(fing, 5);

%%
figure
imshow(fing);
improfile;

%%
mesh(double(fing));
