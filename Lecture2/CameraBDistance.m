function [ b ] = CameraBDistance( f,g )
% CameraBDistance returns the distance (b) where the CCD should be placed
% when the object distance (g) and the focal length (f) are given

b = ((1/f) - (1/g)) ^-1;
end

