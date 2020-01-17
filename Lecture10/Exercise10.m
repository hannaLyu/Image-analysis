%% Week 10 Exercise: Registration
% November 2019, Mariam Andersson


clc
clear all
close all

%% Part 1


hand1 = imread('Hand1.jpg'); %reference image -- this stays fixed
hand2 = imread('Hand2.jpg'); %template image -- this is moved to fit the reference

figure
subplot(1,2,1)
imshow(hand1)
title('Hand 1: reference (fixed) image')
subplot(1,2,2)
imshow(hand2)
title('Hand 2: template (moving) image')


%% Exercise 1: place landmarks

% cpselect(hand2,hand1);
% 
% save('fixedPoints.mat','fixedPoints');
% save('movingPoints.mat','movingPoints');
load fixedPoints.mat
load movingPoints.mat

%% Exercise 2: visualise points

figure;
plot(fixedPoints(:,1), fixedPoints(:,2),'b*-', ...
    movingPoints(:,1), movingPoints(:,2),'r*-');
legend('Hand 1 - The fixed image', 'Hand 2 - The moving image');
axis ij


%% Exercise 3: calculate objective function
 
ex = fixedPoints(:,1) - movingPoints(:,1);      % Error in x
errorX = ex' * ex;                              % Error in x^2
ey = fixedPoints(:,2) - movingPoints(:,2);      % Error in y
errorY = ey' * ey;                              % Error in y^2
F = errorX + errorY;                            % Combined error


%% Exercise 4: compute centres of mass

fixed_COM = [mean(fixedPoints(:,1)), mean(fixedPoints(:,2))];
moving_COM = [mean(movingPoints(:,1)), mean(movingPoints(:,2))];


%% Exercise 5: translate images according to COM

fixed_trans = [fixedPoints(:,1) - fixed_COM(1) ...
    fixedPoints(:,2) - fixed_COM(2)];
moving_trans = [movingPoints(:,1) - moving_COM(1) ... 
    movingPoints(:,2) - moving_COM(2)];

figure; 
plot(fixed_trans(:,1),fixed_trans(:,2),'b*-', moving_trans(:,1), moving_trans(:,2), 'r*-');
legend('Hand 1 - The fixed image', 'Hand 2 - The moving image');
title('Subtracted COM')

%% Exercise 6: compute similarity transform with fitgeotrans

mytform = fitgeotrans(movingPoints, fixedPoints, 'NonreflectiveSimilarity');

%% Exercise 7: perform similarity transform with tformfwd

forward = transformPointsForward(mytform, movingPoints);

figure; plot(fixedPoints(:,1), fixedPoints(:,2), 'b*-', forward(:,1), forward(:,2),'r*-');

%% Exercise 8: compute error between fixed and transformed landmarks

ex = fixedPoints(:,1) - forward(:,1);
errorX = ex' * ex;
ey = fixedPoints(:,2) - forward(:,2);
errorY = ey' * ey;
F8 = errorX + errorY;

% The error decreases

%% Exercise 9: perform transform on whole image

hand2t = imwarp(hand2, mytform);
figure; 
subplot(1,3,1)
imshow(hand1)
title('Hand 1')
subplot(1,3,2);
imshow(hand2);
title('Hand 2')
subplot(1,3,3);
imshow(hand2t);
title('Hand 2: transformed')


%% Part 2: Analysis of Glioma

clc
clear all
close all

%% Exercise 10

% What is a glioma and how is it typically treated?

%% Exercise 11: load MR images

BT1 = imread('BT1.png');    % Before treatment
BT2 = imread('BT2.png');    % After treatment
% 
% 

% 
% save('fixedPointsBT.mat','fixedPoints');
% save('movingPointsBT.mat','movingPoints');
load fixedPointsBT.mat
load movingPointsBT.mat

%% Exercise 12: use cpselect to define landmarks and perform similarity transform on images

mytformBT = fitgeotrans(movingPointsBT, fixedPointsBT, 'NonreflectiveSimilarity');

Width = size(BT1, 2);
Height = size(BT1, 1);

TI = imwarp(BT2, mytformBT, 'OutputView', imref2d(size(BT2)));


figure,
subplot(1,3,1)
imshow(BT1)
title('Pre-Glioma Treatment')
subplot(1,3,2)
imshow(BT2)
title('Post-Glioma Treatment')
subplot(1,3,3)
imshow(TI)
title('Post-Glioma Treatment: Transformed')

%% Exercise 13: perform manual delineation of tumour

% figure;
% tumor1 = roipoly(BT1);
% figure;
% tumor2 = roipoly(TI);
% imwrite(tumor1, 'BT1_annot.png');
% imwrite(tumor2, 'BT2_annot.png');

bw1 = imread('BT1_annot.png');
bw2 = imread('BT2_annot.png');

%% Exercise 14

figure; imshow(label2rgb(bw1+bw2)); % values are either 0, 1 or 2
    
figure; imshow(label2rgb(bw1+bw2+bw2)); % values range between 0, 1 or 3

% Look at RGB values. Why are they different when adding 2 * bw2?
% Answer: The tumour both grows and shrinks during the time between the two
% images. By adding 2*bw, you can now see a) where the tumour is in picture
% 1 AND 2, b) the region the tumour used to be, but is no longer (shrinking), 
% c) the region the tumour has grown to.  

%% Exercise 15 -- compare tumour areas

stat1 = regionprops(bw1,'Area');
stat2 = regionprops(bw2, 'Area');

stat1.Area
stat2.Area

%Approx 30% remains