function [ Io ] = GammaMap( I, G )
%GammaMap takes an image I and gamma-value G as input, and outputs a
%gamma-mapped image Io.

% Step 1: convert I to format double
Itemp = double(I);

% Step 2: scale values to [0,1];
Itemp = Itemp./255;

% Step 3: perform gamma-mapping
Itemp = Itemp.^G;

% Step 4: convert back to pixel range [0,255]
Itemp = Itemp.*255;

% Step 5: convert back to uint8 format
Io = uint8(Itemp);

end

