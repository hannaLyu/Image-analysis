function [H,S,I] = RGB2HSI(R,G,B)
%
%   
    if (G>=B)
    H=(cos(1/2*(((R-G)+(R-B))/sqrt((R-G)*(R-G)+(R-B)*(R-B)))))^-1;
    else
    H=360-(cos(1/2*(((R-G)+(R-B))/sqrt((R-G)*(R-G)+(R-B)*(R-B)))))^-1;
    end
S=1-3*(min([R,G,B])/(R+G+B));
I=(R+G+B)/3;
   
end

