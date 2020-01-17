function [ B ] = RealSizeOnCCD( G,g,b )
%Gives image height, given object height, object distance and CCD distance 

B = G*b/g;

end

   