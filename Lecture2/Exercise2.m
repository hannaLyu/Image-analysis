%% Exercise 2: Cameras
clc
clear all
close all
format long

%% Exercise 1
a = 10;
b = 3;
theta = atand(b/a);

%% Exercise 2. CameraBDistance function created.
f = 15e-3;  % 15 mm 
counter = 0;

for g = [0.1,1,5,15]
    counter = counter + 1;
    CCD(counter) = CameraBDistance(f,g);
end

g = [0.1,1,5,15];
figure, plot(g,CCD)
xlabel('Object Distance (m)')
ylabel('CCD Distance')

% From the figure, we see that: the further the object distance, the
% smaller the CCD distance.

%% Exercise 3
info = imfinfo('Photo.jpg');
info.DigitalCamera

% An optical zoom should result in a larger focal length


%% Exercise 4
% f = focal length
% g = object distance
% b = CCD/image distance
% B = Image height
% G = True height of object
%(2.2) Thin lens equation: 1/g + 1/b = 1/f
%(2.3) b/B = g/G

G = 1.8;
g = 5;
f = 5e-3;

%1. Where is a focussed image of Thomas formed?
b = CameraBDistance(f,g);
% Answer = 5 mm

%2. What is the image height?

B = RealSizeOnCCD(G,g,b);
% Answer = 1. 8 mm;

%3. What is the size of a single pixel in mm?
width = 6.4/640;        % 0.01 mm
height = 4.8/480;       % 0.01 mm


%4. How tall in pixels will Thomas be?
pixelHeight = B*1000/height;    %Multiply by 1000 to convert metres to mm for B
% Answer = 181 pixels

%5. What is the horizontal field of view (in degrees)?
FOVx = 2 * atand(6.4e-3/(2*b));
% Answer = 65 deg 

%6. What is the vertical FOV? Create function.
[FOVx FOVy] = CameraFOV(6.4e-3,4.8e-3,b);
% Answer = 51 deg


%% Exam Question on Camera Geometry
clear all
f = 65e-3;
b = f;
g = 1.2;

px = 10e-3/5120;        % Pixel size in metres
radius = px * 400;      % Image radius in metres

truerad = radius * g/b;       % Real object radius in m

truearea = (truerad*1000)^2 * pi;   % True area in mm

% Answer: 1


%% Exam Question on Field-Of-View

clear all
%FOV = 15;

finger = 2 * tand(7.5)*0.315;

% Answer: 8.3 cm (answer 2)
