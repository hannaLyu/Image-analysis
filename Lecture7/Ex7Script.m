%% Exercise 7/MA
        
clc
clear all
close all

%%
    
ct2 = dicomread('CTangio2.dcm');
I2 = imread('CTAngio2Scaled.png');
imshow(I2)  

%% Exercise 1 

% LiverROI = roipoly(I2);
% imwrite(LiverROI, 'LiverROI.png');
% LiverVals = double(ct2(LiverROI));
% 
% BackgroundROI = roipoly(I2);
% imwrite(BackgroundROI, 'BackgroundROI.png');
% BackgroundVals = double(ct2(BackgroundROI));
% 
% FatROI = roipoly(I2);
% imwrite(FatROI, 'FatROI.png');
% FatVals = double(ct2(FatROI));
% 
% KidneyROI = roipoly(I2);
% imwrite(KidneyROI, 'KidneyROI.png');
% KidneyVals = double(ct2(KidneyROI));
% 
% SpleenROI = roipoly(I2);
% imwrite(SpleenROI, 'SpleenROI.png');
% SpleenVals = double(ct2(SpleenROI));
% 
% TrabecularROI = roipoly(I2);
% imwrite(TrabecularROI, 'TrabecularROI.png');
% TrabecularVals = double(ct2(TrabecularROI));
% 
% BoneROI = roipoly(I2);
% imwrite(BoneROI, 'BoneROI.png');
% BoneVals = double(ct2(BoneROI));
% 

LiverROI = imread('LiverROI.png');
LiverVals = double(ct2(LiverROI));

BackgroundROI = imread('BackgroundROI.png');
BackgroundVals = double(ct2(BackgroundROI));

FatROI = imread('FatROI.png');
FatVals = double(ct2(FatROI));

KidneyROI = imread('KidneyROI.png');
KidneyVals = double(ct2(KidneyROI));

SpleenROI = imread('SpleenROI.png');
SpleenVals = double(ct2(SpleenROI));

TrabecularROI = imread('TrabecularROI.png');
TrabecularVals = double(ct2(TrabecularROI));

BoneROI = imread('BoneROI.png');
BoneVals = double(ct2(BoneROI));


%% Exercise 2
figure, hist(LiverVals);
sprintf('Liver mean %g std %g min %g max %d', ...
mean(LiverVals), std(LiverVals), ...
min(LiverVals), max(LiverVals))
title('Liver')

figure, hist(BackgroundVals);
sprintf('Background mean %g std %g min %g max %d', ...
mean(BackgroundVals), std(BackgroundVals), ...
min(BackgroundVals), max(BackgroundVals))
title('Background')

figure, hist(FatVals);
sprintf('Fat mean %g std %g min %g max %d', ...
mean(FatVals), std(FatVals), ...
min(FatVals), max(FatVals))
title('Fat')


figure, hist(KidneyVals);
sprintf('Kidney mean %g std %g min %g max %d', ...
mean(KidneyVals), std(KidneyVals), ...
min(KidneyVals), max(KidneyVals))
title('Kidney')


figure, hist(SpleenVals);
sprintf('Spleen mean %g std %g min %g max %d', ...
mean(SpleenVals), std(SpleenVals), ...
min(SpleenVals), max(SpleenVals))
title('Spleen')


figure, hist(TrabecularVals);
sprintf('Trabecular mean %g std %g min %g max %d', ...
mean(TrabecularVals), std(TrabecularVals), ...
min(TrabecularVals), max(TrabecularVals))
title('Trabecular')


figure, hist(BoneVals);
sprintf('Liver mean %g std %g min %g max %d', ...
mean(BoneVals), std(BoneVals), ...
min(BoneVals), max(BoneVals))
title('Bone')


% Liver and fat seem quite Gaussian

%% Exercise 3

figure; 
xrange = -1200:0.1:1200; % Fit over the complete Hounsfield range
pdfFitLiver = normpdf(xrange, mean(LiverVals), std(LiverVals));
S = length(LiverVals); % A simple scale factor

hold on; 
hist(LiverVals,xrange);
plot(xrange, pdfFitLiver*S, 'r');
hold off;
xlim([-10, 100]);

%% Exercise 4

pdfFitBackground = normpdf(xrange, mean(BackgroundVals), std(BackgroundVals));
pdfFitTrabecular = normpdf(xrange, mean(TrabecularVals), std(TrabecularVals));
pdfFitSpleen = normpdf(xrange, mean(SpleenVals), std(SpleenVals));
pdfFitKidney = normpdf(xrange, mean(KidneyVals), std(KidneyVals));
pdfFitFat = normpdf(xrange, mean(FatVals), std(FatVals));
pdfFitBone = normpdf(xrange, mean(BoneVals), std(BoneVals));



figure; plot(xrange, pdfFitBackground, xrange, pdfFitTrabecular, xrange, ...
    pdfFitLiver, xrange, pdfFitSpleen, xrange, pdfFitKidney, ...
    xrange, pdfFitFat, xrange, pdfFitBone);
legend('Background','Trabecular','Liver','Spleen','Kidney','Fat','Bone');
xlim([-1200 1200]);

% Which classes are well separated?  Background, trabeculae, bone
% Liver, kidney and spleen really overlap and can be collapsed into one
% Background could also be separated

%% Exercise 5

% Minimum distance classification
% Find the distances between classes
% Select the closest class

% What are our classes? Background, Fat, Soft tissue (liver,
% kidney, spleen), Bone, Trabecular

Background_fat = (mean(BackgroundVals)+mean(FatVals))/2;
Fat_soft = (mean(FatVals)+mean([KidneyVals; LiverVals; SpleenVals]))/2;
Soft_trabecular = (mean([KidneyVals; LiverVals; SpleenVals])+mean(TrabecularVals))/2;
Trabecular_bone = (mean(TrabecularVals)+mean(BoneVals))/2;

%% Exercise 6 

ILabel = LabelImage(ct2, Background_fat, Fat_soft, Soft_trabecular, Trabecular_bone, Trabecular_bone );


%% Exercise 7
figure; 
imagesc(ILabel)
hcb=colorbar;
set(hcb, 'YTick', [0,1,2,3,4]);
%set(hcb, 'YTickLabel', {'Class 0', 'Class 1', 'Class 2',...
 %   'Class 3', 'Class 4', 'Class 5'});
set(hcb, 'YTickLabel', {'Background', 'Fat', 'Soft tissue',...
    'Trabecular', 'Bone'});

%% Exercise 8

pdfSoft = normpdf(xrange, mean([KidneyVals; LiverVals; SpleenVals]), std([KidneyVals; LiverVals; SpleenVals]));
figure; plot(xrange, pdfFitBackground, xrange, pdfFitTrabecular, ...
        xrange, pdfSoft, xrange, pdfFitFat, xrange, pdfFitBone);
legend('Background','Trabecular','Soft tissue','Fat','Bone');
xlim([-1200 1200]);

%% Exercise 9
ILabel2 = LabelImage(ct2, -500, -17, 88, 209, 209);
figure; 
imagesc(ILabel2)
hcb=colorbar;
set(hcb, 'YTick', [0,1,2,3,4]);
%set(hcb, 'YTickLabel', {'Class 0', 'Class 1', 'Class 2',...
 %   'Class 3', 'Class 4', 'Class 5'});
set(hcb, 'YTickLabel', {'Background', 'Fat', 'Mixed',...
    'Bone', 'Trabecular'});



%% Exercise 10 DTU Sign Image Classification

I = imread('DTUSigns055.jpg');
Ired = I(:,:,1);
Igreen = I(:,:,2);
Iblue = I(:,:,3);


BSROI = roipoly(I);
imwrite(BSROI, 'BSROI.png');    

redVals = double(Ired(BSROI));
greenVals = double(Igreen(BSROI));
blueVals = double(Iblue(BSROI));


% Inspect combined histogram

figure;
totVals = [redVals greenVals blueVals];
nbins = 255;
hist(totVals,nbins);
h = findobj(gca,'Type','patch');
set(h(3),'FaceColor','r','EdgeColor','r','FaceAlpha',0.3,'EdgeAlpha',0.3);
set(h(2),'FaceColor','g','EdgeColor','g','FaceAlpha',0.3,'EdgeAlpha',0.3);
set(h(1),'FaceColor','b','EdgeColor','b','FaceAlpha',0.3,'EdgeAlpha',0.3);
xlim([0 255]);


%% Exercise 11

figure;
BlueSign = Ired > 0 & Ired < 55 & Igreen > 56 & Igreen < 150 & Iblue > 151 & Iblue < 256;
imshow(BlueSign);

%% Eksamenopgaver 12.3

% Six pixel labels

I = [162, 163, 220, 233, 231, 10, 5, 4;
    161, 164, 189, 237, 12, 18, 2, 3;
    166, 167, 180, 181, 25, 14, 3, 7;
    170, 165, 185, 186, 187, 75, 9, 8;
    161, 160, 183, 179, 181, 78, 64, 10;
    120, 124, 164, 180, 182, 76, 55, 11;
    121, 126, 120, 180, 77, 77, 54, 40;
    125, 127, 122, 78, 89, 80, 52, 51];

% Range mellem type 3 og type 4
R34 = (161+182)/2

% Range mellem type 4 og type 5

R45 = (182+221)/2

I(I>R34 & I<R45) = 1;       % Set all pixels within type 4 range to 1
I(I~=1)=0;                  % Set pixels not already equal to 1, equal to 0


% Morpholopgical erosion with disk element 
se = strel('disk',1);       

% Add function "imagegrid.m" from previous exercises to path/folder
Ie = imerode(I,se);
figure; imagesc(Ie);
imagegrid(gca,size(Ie));
colormap(hot);

% Answer: 2 pixels
%% Eksamesopgaver 12.17


%V = [normpdf(68,7.3,3), normpdf(68,58,3), normpdf(68,75,2), normpdf(68,83.3,1.53), normpdf(68,200.67, 2.52)];

xrange = 0:1:300;



% pdfBG = normpdf(xrange',mean([4, 8, 10]),std([4, 8, 10]));
% pdfBV = normpdf(xrange',mean([61, 58, 55]),std([61, 58, 55]));
% pdfN = normpdf(xrange',mean([75, 77, 73]), std([75, 77, 73]));
% pdfM = normpdf(xrange',mean([85, 82, 83]),std([85, 82, 83]));
% pdfK = normpdf(xrange',mean([198, 201, 203]), std([198, 201, 203]));

% figure; plot(xrange, pdfBG, xrange, pdfBV, xrange, ...
%   pdfN, xrange, pdfM, xrange, pdfK);
% legend('Background','Soft','Liver','Spleen','Kidney');
% xlim([-1200 1200]);

V = [normpdf(68,mean([4, 8, 10]),std([4, 8, 10])),...
    normpdf(68,mean([61, 58, 55]),std([61, 58, 55])),...
    normpdf(68,mean([75, 77, 73]), std([75, 77, 73])),...
    normpdf(68,mean([85, 82, 83]),std([85, 82, 83])), ...
    normpdf(68,mean([198, 201, 203]), std([198, 201, 203]))];



% 
% [val, idx] = max(V); 

% Svar: Blødt väv



