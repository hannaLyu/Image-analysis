%% Exercise 11

%% PART 1: LINES AND THE HOUGH SPACE
clear; clc; close all;

a = zeros(50,50);
a(25,25) = 1;
figure; imshow(a);

%% Ex 1
%Calculate Hough transform of small image example with one dot

[H, T, R] = hough(a);
figure;
imshow(H, [], 'XData', T, 'YData', R, 'InitialMag', 'fit');
axis on
title('Hough space');
xlabel('\theta')
ylabel('\rho')

% Since 'a' only contains one point, this point can belong to many lines.
% Therefore the hough space contains many points as one sinusoidal curve.
% Each of the points on the sinusoidal curve corresponds to a straight line
% passing through the point in the image. 

%% Ex 2
%Create example image with three points and compute Hough transform of the
%image.

a = zeros(50,50);
a(25,25) = 1;
a(5,5) = 1;
a(20,45) = 1;

[H, T, R] = hough(a);

figure;
subplot(1,2,1)
imagesc(a); colormap gray; axis image
subplot(1,2,2)
imshow(H, [], 'XData', T, 'YData', R, 'InitialMag', 'fit');
axis on
title('Hough space');
xlabel('\theta')
ylabel('\rho')

% Now three sinusoidal curves are created. Two curves meet in the point in
% Hough space that corresponds to the line in 'a' going through the two 
% points corresponding to those two curves.

%% Ex 3
%Create new example image, with three points in the image lying on a
%straight line. Compute Hough transform.

a = zeros(50,50);
a(25,25) = 1;
a(15,15) = 1;
a(35,34) = 1;

[H, T, R] = hough(a);

figure;
subplot(1,2,1)
imagesc(a); colormap gray; axis image
subplot(1,2,2)
imshow(H, [], 'XData', T, 'YData', R, 'InitialMag', 'fit');
axis on
title('Hough space');
xlabel('\theta')
ylabel('\rho')

% The three sinusoidal curves now meet in one point corresponding to a line
% in 'a' going through all three points in the image.

%% Ex 4
%Find peaks in Hough space:

P  = houghpeaks(H); %P gives indices of rho and theta in the hough space image - not the values of rho and theta.
%P  = houghpeaks(H,10,'Threshold',1.5);

figure;
imshow(H, [], 'XData', T, 'YData', R, 'InitialMag', 'fit');
axis on
title('Hough space');
xlabel('\theta')
ylabel('\rho')
hold on;
x = T(P(:,2));
y = R(P(:,1));
plot(x,y,'o','color','red','linewidth',3);

% The maximum is the point where all three curves meet. I.e. the point
% which corresponds to the line that goes through most of the points in a.

%% Ex 5 
%Compute the slope intercept equation of the line corresponding to the
%maximum found in Ex. 4 and plot together with the input points (in the
%image).

% Equation 12.4 page 166

% Using degrees directly
theta = T(P(:,2)); %theta is in columns of P
rho = R(P(:,1)); %rho is in rows of P
a_slope = -cosd(theta)/sind(theta);
b = rho/sind(theta);

% Using radians
%theta = T(P(:,2))*pi/180;
%rho = R(P(:,1));
%a_slope = -cos(theta)/sin(theta);
%b = rho/sin(theta);

x = 1:50;
y = a_slope*x + b;

figure;
imagesc(a); colormap gray; axis image
hold on
plot(x,y,'r-');

%% Line detection in a real image
clear; clc; close all;
%% Ex 6 - Read and prepare image

Irgb = imread('DTUSigns2.jpg');
Icrop = Irgb(1407:1635,1983:2433,:);
I = rgb2gray(Icrop); %convert to grayscale

imshow(I,[]);
title('Grayscale image')

%Edge detection
h = fspecial('gaussian', 3, 1); %Smoothing filter, to reduce noise
I2 = imfilter(I,h,'replicate'); %Filtering with replicate padding

figure;
imshow(I2,[]);
title('Smoothed image')

figure;
subplot(1,2,1)
BW1 = edge(I2,'prewitt');
imshow(BW1);
title('Smooth+Prewitt')
subplot(1,2,2)
BW2 = edge(I2,'canny',0.6);
imshow(BW2);
title('Smooth+Canny')

% We apply the gaussian filter to remove noise

%% Ex 7 - Hough space of edge image

%Binary mask to use:
BW = BW2; %canny 

[H, T, R] = hough(BW);
figure;
imshow(H, [], 'XData', T, 'YData', R, 'InitialMag', 'fit');
axis on
axis normal
title('Hough space');
xlabel('\theta')
ylabel('\rho')

%% Ex 8 - Find maximum in Hough space

P  = houghpeaks(H);
%P  = houghpeaks(H,12,'Threshold',0);

figure;
imshow(H, [], 'XData', T, 'YData', R, 'InitialMag', 'fit');
axis on
axis square
title('Hough space');
xlabel('\theta')
ylabel('\rho')
hold on;
x = T(P(:,2));
y = R(P(:,1));
plot(x,y,'o','color','red','linewidth',3);

%% 9 - Slope-intercept

% Using degrees directly
theta = T(P(:,2)); %theta is in columns of P
rho = R(P(:,1)); %rho is in rows of P
a_slope = -cosd(theta)/sind(theta);
b = rho/sind(theta);

% Using radians
%theta = (T(P(:,2))+eps)*pi/180;
%rho = R(P(:,1));
%a_slope = -cos(theta)./sin(theta);
%b = rho./sin(theta);

idx=1;
x = 1:size(I,2);
y = a_slope(idx)*x + b(idx);

%Show image with line corresponding to the max peak in the hough space
figure;
imagesc(I); colormap gray; axis image
hold on
plot(x,y,'r-','linewidth',3);
ylim([0 size(I,1)])

%% 10 - Extract line with houghlines
line_H = houghlines(BW,T,R,P,'FillGap',1000);
figure;
imshow(I,[]);
hold on

%Loop used if several peaks are found with houghpeaks - then several lines
%are plotted
for k = 1:length(line_H)
% Plot line
xy = [line_H(k).point1; line_H(k).point2];
plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

% Plot beginnings and ends of line
plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

end

hold off;

%% 11 - Locate several maxima
%P  = houghpeaks(H,6); %Defines its own threshold - therefore not necessarily 6 maxima.
P  = houghpeaks(H,6,'Threshold',0);

x = T(P(:,2)); 
y = R(P(:,1));

figure
imshow(H,[],'XData',T,'YData',R,'InitialMagnification','fit');
xlabel('\theta');
ylabel('\rho');
axis on, axis normal, hold on;
plot(x,y,'o','color','red');

%% 12 - Plot several lines

lines = houghlines(BW,T,R,P,'FillGap',1000);

figure, imshow(I), hold on
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
end
hold off; 

% We would hope to find the lines surrounding the signs itself.
% Instead we found a lot of the lines on the metal frame holding the signs.
% This makes sense, since these are longer lines than the sides of the
% signs.

%% 13 - Experiments

% More lines 
P  = houghpeaks(H,15,'Threshold',100);
%P  = houghpeaks(H,15,'Threshold',0);

lines = houghlines(BW,T,R,P,'FillGap',1000);

figure, imshow(I), hold on
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
end
hold off;

% Yes, the lines found are the ones expected. But not necessarily the ones
% desired to find. Depending on the threshold, some very strange lines are
% also found - for example using threshold=0.
%%
% Only with red channel
I = Icrop(:,:,1); 
%I_test = I-255;

% Filtering and edge detection
I2 = imfilter(I,h,'replicate');
BW = edge(I2,'canny');

%Hough transform
[H, T, R] = hough(BW);
P = houghpeaks(H,8,'Threshold',0);
lines = houghlines(BW,T,R,P,'FillGap',1000);
figure, imshow(I), hold on
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
end
hold off; 

% Using only the red channel does not give a better result.
% This is because other edges than the ones along the signs still are
% visible

%% Try to preprocess the red channel or the image, using the red channel
% Only with red channel
Ired = Icrop(:,:,1);
Igreen = Icrop(:,:,2);
Iblue = Icrop(:,:,3);
I = Ired>160 & Ired<180 & Igreen>50 & Igreen<70 & Iblue>50 & Iblue<70;
SE = strel('disk',5);
I_closed = imclose(I,SE);

%Show binary image - thresholded to only contain the red signs
imshow(I_closed)

% Filtering and edge detection
I2 = imfilter(I_closed,h,'replicate');
BW = edge(I2,'canny');

%Hough transform
[H, T, R] = hough(BW);
P = houghpeaks(H,8);
lines = houghlines(BW,T,R,P,'FillGap',1000);
figure, imshow(Icrop), hold on
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
end
hold off; 

%Now lines are along the signs - but the preprocessing, has made them
%smaller in the binary image, which results in lines a bit inside the red
%signs. This can be done better.

%%
%Canny filter seems to be better than prewitt, especially when threshold is used.

%% Part 2: Finding the liver outline
clear; clc; close all; 

%Load CT images
ct1 = dicomread('LiverTraining1.dcm');
ct2 = dicomread('LiverTraining2.dcm');
ct3 = dicomread('LiverTraining3.dcm');

ct1_val = dicomread('LiverValidation1.dcm');
ct2_val = dicomread('LiverValidation2.dcm');
ct3_val = dicomread('LiverValidation3.dcm');

%% Ex 14 - Show images

figure; 
subplot(2,3,1)
imshow(ct1,[-400,400]);
title('Training 1'); 
subplot(2,3,2)
imshow(ct2,[-400,400]);
title('Training 2'); 
subplot(2,3,3)
imshow(ct3,[-400,400]);
title('Training 3'); 
subplot(2,3,4)
imshow(ct1_val,[-400,400]);
title('Validation 1'); 
subplot(2,3,5)
imshow(ct2_val,[-400,400]);
title('Validation 2'); 
subplot(2,3,6)
imshow(ct3_val,[-400,400]);
title('Validation 3'); 

%% 15 - Center

%imshow(ct1,[-400,400]);
%center = ginput(1);
load center

%% 16 - Resample image along spokes

lSpoke = 110; %spoke length
nAng = 360; %number of angles
IM=double(ct1);
[linesI, lCoords] = SampleSpokes(IM, nAng, lSpoke, center);

%% 17 - Show resampled image

I_spoke1 = uint8(linesI); 
imshow(I_spoke1); 

% The edge is very visible, but we need to make the edge stand out (as
% dark) if we want to be able to detect it with dynamic programming. 

%% 18 - Filter image

%% Solution 1:
% % Remove white things
% SE = strel('disk',10); 
% I_spoke = imopen(I_spoke1,SE); 
% figure
% imshow(I_spoke); 
% 
% % Detect edge
% prewitt = fspecial('prewitt'); 
% BW = imfilter(I_spoke,prewitt');
% figure
% imshow(BW);
% 
% % Make edge dark
% costI = 255 - BW;
% imshow(costI);  

%% Solution 2 - threshold, smoothing and edge detection: 

%Threshold to remove bones (very high values): 
Ithr = I_spoke1;
Ithr(Ithr>150)=0;
imshow(Ithr)

%Use smoothing filter (gaussian)
h = fspecial('gaussian', 3, 1);
Igauss = imfilter(Ithr,h,'replicate');

%Use sobel filter to enhance edges
sobel = fspecial('sobel'); 
Iedge = imfilter(Igauss,sobel');
imshow(Iedge);

%Create cost image
costI = 255 - Iedge;
imshow(costI); 

%See p.76-77
%% 19 - Find path 
% The cost matrix needs to be of type double
Brd = doDP(double(costI)); %Output is column indices for each row, where the dynamic programming line goes through

%% 20 - Show path
figure; 
imshow(I_spoke1); 
hold on
plot(Brd,1:nAng,'-r','linewidth',2);

%% 21 - Show path in original image

%Convert found path into coordinates in the original image
[ix,iy] = dpConvertPolar(nAng, lCoords, Brd);

figure; 
imshow(ct1,[-400,400])
hold on
plot(ix,iy,'-r','linewidth',2);

%% 22
% Due to the attempt of preventing the path from going through the white
% things, some of the actual border was removed with the filtering as well.
% Therefore the outline is not perfect. Better filters could probably be found. 

%% 23 - everything put into a function. The function only needs the ct image and the center of the liver
im = ct3_val;

imshow(im,[-400,400]);
center = ginput(1);

[ix,iy] = findLiverOutline(im, center);

figure; 
imshow(im,[-400,400])
hold on
plot(ix,iy,'-r','linewidth',2);

