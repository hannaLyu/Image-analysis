%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                  EXERCISE 9: Geometric transformations               %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; clc

%% Part 1: Geometric Transformations on 2D points
%% Exercise 1) Create Grid

[X,Y] = meshgrid(-6:6,-6:6);

%% Exercise 2) Rearrange
XY = [X(:) Y(:)]';

% Each column is now a point, instead of having two matrices with X and Y
% coordinates stored separately

%% Exercise 3) Plot Grid
figure;
PlotGrid(XY);

%% Exercise 4) Scaling
Sx = 0.7;
Sy = 1.3;

%XYscale = [XY(1,:)*Sx; XY(2,:)*Sy];
%eller
scaleMat = [Sx 0; 0 Sy]; %Eq. 10.4, page 140
XYscale = scaleMat*XY;

figure; 
PlotGrid(XYscale);

%% Exercise 5) Rotate
rot = 20;%degrees

rotMat = [cos(rot) -sin(rot); sin(rot) cos(rot)]; %Eq. 10.5

XYrot = rotMat*XY;

figure; 
PlotGrid(XYrot);

%% Exercise 6) Shear
Bx = 0.5; 
By = 0.1; 

shearMat = [1 Bx; By 1]; %Eq. 10.7

XYshear = shearMat*XY;

figure; PlotGrid(XYshear);

%% Exercise 7) Translation w. homogenous coordinates
%See eq. 10.9 on page 143
dX = 10;
dY = 5;
a1 = 1; a2 = 0; a3 = dX; 
b1 = 0; b2 = 1; b3 = dY;

affMat = [a1 a2 a3; b1 b2 b3; 0 0 1];

XY1 = [XY; ones(1,size(XY,2))];

XYtrans = affMat*XY1;

figure; PlotGrid(XYtrans);

%% Exercise 8) Mulitple transformations

% Change the variables a1-3 and b1-3 to get combinations
a1 = 5; a2 = 11; a3 = 5; 
b1 = 6; b2 = 5; b3 = 8;

affMat = [a1 a2 a3; b1 b2 b3; 0 0 1];
XYaff = affMat*XY1;

figure; PlotGrid(XYaff);

%% Part 2: Geometric Transformations on Images
%% Exercise 9) load
clear all; close all; clc

Im = imread('Im.png');
figure; imshow(Im);

%% Exercise 10) Forward mapping

Sx = 3; 
Sy = 2; 

[X,Y] = meshgrid(1:size(Im,2),1:size(Im,1));
XY = [X(:) Y(:)]';

scaleMat = [Sx 0; 0 Sy]; %Eq. 10.4
XYscale = scaleMat*XY;

ImScale = zeros(size(Im,1)*Sy,size(Im,2)*Sx);

for idx=1:size(XYscale,2)
    ImScale(XYscale(2,idx),XYscale(1,idx)) = Im(idx);
    %In this case it is not necessary to use interpolation as we are
    %scaling with positive integers
end

ImScale = uint8(ImScale);
figure; imagesc(ImScale); colormap('gray')
% It is evident there is holes in the image 

%% Exercise 11) Backward mapping
[X,Y] = meshgrid(1:size(Im,2),1:size(Im,1));
[Xscale,Yscale] = meshgrid(1:size(Im,2)*Sx,1:size(Im,1)*Sy);
XYscale = [Xscale(:) Yscale(:)]';

invScaleMat = [1/Sx 0; 0 1/Sy];%eq.10.1

XYinv = invScaleMat *XYscale;
Xinv = reshape(XYinv(1,:),size(Xscale));
Yinv = reshape(XYinv(2,:),size(Yscale));

Vq = interp2(X,Y,im2double(Im),Xinv,Yinv);

figure; imagesc(Vq),colormap('gray')
%pros: No holes in image
%cons:  We need to inverse the matrices and perform interpolation

%% Exercise 12) interpolation
% zero order interp - round to nearest: (2.3,1.9) -> (2,2) = 14. 
% first order interp = bilinear: eq. 10.13
10*(1-0.3)*(1-0.9) + 12*0.3*(1-0.9) + 14*(1-0.3)*0.9+15*0.3*0.9 
% = 13.93 

% The bilinear interpolation is better especially for large upsamplings
% Other alternatives: More or less advanced interpolations. 

%% PART 3: Nonlinear Geometric Transformations %% 
%% Exercise 13) 
clear all; close all; clc; 

Im = imread('Im.png');

SpecialWarp(Im)

% What does SpecialWarp do? 
% Define a point (x,y) with the mouse click 
% Make new basis-vectors based on these clicks
% Make inquery points by adding the gradient of something.. 
% Results: Non-linear transformations!!

%% Exercise 14) Optional
% One can change the basis vectors in the script (A) to obtain other
% transformations. 

