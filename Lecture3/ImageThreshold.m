function [ Io] = ImageThreshold( I, T )
%ImageThreshold takes image I and threshold T as an input. It outputs a binary image,
%where pixels below value T have value 0 and pixels above T have value 1. 

% find places where pixels are smaller than threshold T and set them to 0.
Itemp = I;
% Itemp(Itemp<T) = 0;
% Itemp(Itemp>0) = 1;

Itemp(Itemp>=T) = 1;
%Itemp(Itemp<93) = 1;

    

Io = Itemp;

end
