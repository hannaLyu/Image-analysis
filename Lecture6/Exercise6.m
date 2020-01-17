%% Intro
set(0,'defaultaxesfontsize',15);
clear; close all; clc;
load Image1.mat
imagesc(Image1);
imagegrid(gca,size(Image1));
colormap(hot);

%% Exercise 1 + 2:
%Original image
subplot(1,3,1)
imagesc(Image1);
imagegrid(gca,size(Image1));
colormap(hot);

subplot(1,3,2);
% 4 connectiviy
L4 = bwlabel(Image1,4);
imagesc(L4);
imagegrid(gca,size(L4));
colormap(hot);
title('4-connectitivty')
% Using 4 connectivity we detect 8 blobs. They have to share edges of
% pixels not just corners to be in one blob. 

subplot(1,3,3);
% 8 connectiviy
L8 = bwlabel(Image1,8);
imagesc(L8);
imagegrid(gca,size(L8));
colormap(hot);
title('8-connectitivty')
% Using 8 connectivity we get 5 blobs and it is enough to share a corner to
% be in the same blob. 

%% Exercise 3: label2rgb
RGB4 = label2rgb(L4);
RGB8 = label2rgb(L8);

% RGB = label2rgb(L,cmap,zerocolor,order) - (how to use label2rgb)
%RGB4 = label2rgb(L4, 'spring', 'c', 'shuffle');
%RGB8 = label2rgb(L8, 'spring', 'c', 'shuffle');

subplot(1,2,1);
imagesc(RGB4);
imagegrid(gca,size(RGB4));

subplot(1,2,2);
imagesc(RGB8);
imagegrid(gca,size(RGB8));

%% Exercise 4: Region properties
stats8 = regionprops(L8, 'Area'); %This is a struct with the area of each blob in pixels

 %% Exercise 5:
val1= stats8(1).Area; %Area of blob 1=8
val2= stats8(2).Area; %Area of blob 2=5
val3= stats8(3).Area; %Area of blob 3=16

%% Exercise 6
% all blob areas in a vector
allArea = [stats8.Area];

 %% Exercise 7
idx = find([stats8.Area] > 16); %indices of blobs larger than 16 pixels
BW2 = ismember(L8,idx); %Finds pixels that are in a blob with more than 16.
%ismember returns a logical array --> blob number is lost (but can easily
%be obtained again by multiplying with L8 fx: blob_nums = L8.*BW2)
 
figure
imagesc(BW2);
imagegrid(gca,size(BW2));
colormap(hot);

%% Exercise 8: Perimeters
stats8 = regionprops(logical(L8), 'All');
 
allPerimeter = [stats8.Perimeter]

%% Exercise 9: 
sum(allPerimeter>20) %2 objects with perimeter larger than 20
%numel(allPerimeter(allPerimeter>20))
%numel(find(allPerimeter>20))


%% exercise 10: object perimeter as a function of area
plot(allArea, allPerimeter, '*');

%yes there is some correlation - the larger blob, the larger the perimeter. 

%% Exercise 11+12: Chemometec U2OS cell analysis - raw images
clear; close all; clc; % Clean the workspace
I16 = imread('CellData/Sample E2 - U2OS DAPI channel.tiff');
I16c = imcrop(I16, [700 900 500 500]); % Crop region from raw image
Im = im2uint8(I16c); % Convert region into 8-bit grayscale
figure
imshow(Im, [0 150]); title('DAPI Stained U2OS cell nuclei'); 

%imcrop documentation. Specifiy area to crop by [xmin ymin width height]
%gray scale range: nuclei are most visible in the range [0 150]
%% Exercise 13: 
%Image histogram
imhist(Im)

%Histogram without zeros
hist(double(Im(Im > 0)),100)

%Inspect different thresholds
figure;
thres = 1:3:28;
for i=1:9
    subplot(3,3,i)
    imshow(Im>thres(i))
    title(sprintf('Threshold= %d',thres(i)))
end

% threshold=10 chosen
BW = (Im>10);%idx_thres(4)
figure, imshow(BW); title('Thresholded image');

%% Exercise 14: Remove border objects
BWc = imclearborder(BW);
figure
subplot(1,2,1)
imshow(BW); title('Thresholded image')
subplot(1,2,2)
imshow(BWc); title('Thresholded image - border cells removed');

%% Exercise 15: Label objects
L = bwlabel(BWc,8);
L1 = label2rgb(L);
figure, imagesc(L1); axis image; title('Regions labeled with RGB colors');

%% Exercise 16:
cellStats = regionprops(BWc, 'All'); %30 objects found (see size of cellStats.)
%cellStats = regionprops(logical(L), 'All')
%cellStats = regionprops(L, 'All');
cellArea = [cellStats.Area];

%Show histogram of object areas
figure
hist(cellArea,100); title('Cell Area Histogram');

%% Exercise 17: Define min and max for cellarea/size
%Objects to remove:
idx = find([cellStats.Area] > 150); %indices of objects with area>150
BW2 = ismember(L,idx); % find objects with same label as idx (the objects with area>200)
figure, imagesc(BW2); axis image; title('Object with area > 150');
countremove = numel(idx); 

%Objects to keep
idx = find([cellStats.Area] < 150); %indices of objects with area<150
BW2 = ismember(L,idx); % find objects with same label as idx (the objects with area<150)
figure, imagesc(BW2); axis image; title('Object with area < 150');
countkeep = numel(idx); 

minArea = 50;
maxArea = 150;
idx = find([cellStats.Area] < maxArea & [cellStats.Area] > minArea ); %indices of objects with area between min and max specification
BW2 = ismember(L,idx);
figure, imagesc(BW2); axis image; title('Object with area < 150 and area > 50');
countA2 = numel(idx); %22 objects out of 27 are kept

%% Exercise 18: circularity


circularity = (2*sqrt(pi*[cellStats.Area]))./([cellStats.Perimeter]);
hist(circularity,100); %suggestions for min and max values for circularity: 0.9 and 1.3

idx = find(circularity > 1); %0.9 could also be a good threshold
BW2 = ismember(L,idx);
figure, imagesc(BW2); axis image; title('Circularity > 1'); axis off
countC = numel(idx); %23 objects with cicularity>1 - the clustered cells are removed as well as elongated structures

%Objects with circularity less than 1:
idx = find(circularity < 1);  %0.9 could also be a good threshold
BW2 = ismember(L,idx);
figure, imagesc(BW2); axis image; title('Circularity < 1'); axis off

%% Exercise 19: Combination of circularity and area measures
%Filter cells, such that only cells with area between 50 and 150 and
%circularity larger than 1 remain
idx = find(circularity > 1 & [cellStats.Area] < 150 & [cellStats.Area] > 50);
BW2 = ismember(L,idx);
countCA = numel(idx); %22 objects fullfils the combined requirements
tit = sprintf('Circularity and Area filtered : %i cells',countCA);
figure, imagesc(BW2); axis image; title(tit); axis off

%Removed cells:
idx = find(circularity < 1 | [cellStats.Area] > 150 | [cellStats.Area] < 50);
BW3 = ismember(L,idx);
countCA_removed = numel(idx); %5 objects that are removed due to size or circularity filtering
tit = sprintf('Removed: %i cells',countCA_removed);
figure, imagesc(BW3); axis image; title(tit); axis off

%% Exercise 20:
% Cell counts after filtering:
countA %Area filtered
countC %Circularity filtered
countCA %Both

% Test CountCellNuclei.m
[I, N] = CountCellNuclei_lriga(Im);
sprintf('CountCellNuclei says %i cells ',N);
tit = sprintf('CountCellNuclei output with %i cells',N);
figure, imagesc(I); axis image; title(tit)

%% Exercise 21:
clear; close all; clc; % Clean the workspace
filename = 'Sample G1 - COS7 cells DAPI channel.tiff';
region = [1000, 500, 500, 500];

I16 = imread(strcat('CellData/',filename));
I16c = imcrop(I16, region); % Crop region from raw image
Im = im2uint8(I16c); % Convert region into 8-bit grayscale

[I, N, I_rem,N_rem] = CountCellNuclei_lriga(Im);

figure
subplot(1,3,1)
imshow(Im, [0 150]); title('DAPI Stained U2OS cell nuclei');
subplot(1,3,2)
tit = sprintf('CountCellNuclei output with %i cells',N);
imagesc(I); axis image; title(tit); axis off
subplot(1,3,3)
imagesc(I_rem); axis image; title('Cells removed'); axis off

%% Exercise 22+23: Prøv dig frem!

%% Exercise 24: Morphology operations: 
clear; close all; clc; % Clean the workspace
I16 = imread('CellData/Sample E2 - U2OS DAPI channel.tiff');
I16c = imcrop(I16, [700 900 500 500]); % Crop region from raw image
Im = im2uint8(I16c); % Convert region into 8-bit grayscale

figure
imshow(Im, [0 150]); title('SampleE2 U2OS DAPIchannel');

BW = (Im > 20);
% Remove objects touching border
BWc = imclearborder(BW);
% Morphoogy - opening: 
se = strel('disk',3);        
BWe = imopen(BWc,se);
figure 
subplot(2,2,1)
imshow(Im, [0 150]); title('Input');
subplot(2,2,2)
imshow(BWc); title('Threshold+clear borders')
subplot(2,2,3)
imshow(BWe); title('Opened image');

% Label blobs
L = bwlabel(BWe,8);

% blob features
cellStats = regionprops(L, 'All');
 
cellPerimeter = [cellStats.Perimeter];
cellArea = [cellStats.Area];

% Compute circulatiry
circularity =  (4 * pi * [cellStats.Area]) ./ ([cellStats.Perimeter].^2);

% Filter based on circularit and area
idx = find([circularity] > 0.9 & [cellStats.Area] < 150 & [cellStats.Area] > 50);

% Generate output image and number of found blobs
I = ismember(L,idx);
N = numel(idx);

subplot(2,2,4)
imshow(I),title('Detected cells');

