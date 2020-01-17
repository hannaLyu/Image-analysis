clc
clear all
load 02502data6\Image1.mat
RGB=label2rgb(Image1);
L4=bwlabel(Image1,4);
RGB4 = label2rgb(L4);
L8=bwlabel(Image1);
RGB8 = label2rgb(L8);
subplot(1,3,1);
%imagesc(Image1);
imshow(RGB);
title('origional')
subplot(1,3,2);
imshow(RGB4);
title('4-connection')
subplot(1,3,3);
imshow(RGB8);
title('8-connection')

%%
stats8 = regionprops(L8, 'Area');
%centroid,BoundingBox,Circularity,EquivDiameter,PixelIdxList,PixelList...
val = stats8(1).Area;
allArea = [stats8.Area];
stats4 = regionprops(L4, 'Area');

idx = find([stats8.Area] > 16); 
BW2 = ismember(L8,idx);
figure;
imshow(BW2)


%%
stats8 = regionprops(logical(L8), 'All');
sum(allPerimeter>20) %2 objects with perimeter larger than 20
%numel(allPerimeter(allPerimeter>20))
%numel(find(allPerimeter>20))
allPerimeter = [stats8.Perimeter]
figure;
plot(allArea, allPerimeter, '*');


%%
clear; close all; clc; % Clean the workspace
I16 = imread('02502data6/CellData/Sample E2 - U2OS DAPI channel.tiff');
I16c = imcrop(I16, [700 900 500 500]); % [xmin ymin width height]
Im = im2uint8(I16c); % Convert region into 8-bit grayscale
figure
imshow(Im, [0 150]); title('DAPI Stained U2OS cell nuclei'); 
imhist(Im)
hist(double(Im(Im > 0)),100)

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

%%
BWc = imclearborder(BW);
figure
subplot(1,2,1)
imshow(BW); title('Thresholded image')
subplot(1,2,2)
imshow(BWc); title('Thresholded image - border cells removed');

L = bwlabel(BWc,8);
L1 = label2rgb(L);
figure, imagesc(L1); axis image; title('Regions labeled with RGB colors');

cellStats = regionprops(BWc, 'All'); %30 objects found (see size of cellStats.)
%cellStats = regionprops(logical(L), 'All')
%cellStats = regionprops(L, 'All');
cellArea = [cellStats.Area];
figure
hist(cellArea,100); title('Cell Area Histogram');

%%
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

%%
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