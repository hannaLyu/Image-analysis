function [ Io ] = HistStretch( I )
%HistStretch takes image I and returns image Io where the pixel values are
%stretched to the interval [0, 255]
%using double input

Itemp = double(I);          % Convert to double so that we can perform stretching

I_min = min(Itemp(:));
I_max = max(Itemp(:));

Io_min = 0;
Io_max = 255;

Io = (((Io_max - Io_min)/(I_max - I_min)) .* (Itemp - I_min)) + Io_min;     % Equation 1 in exercise instructions

Io = uint8(Io);             % Convert back to integer format
end
