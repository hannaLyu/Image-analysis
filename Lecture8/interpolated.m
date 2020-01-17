function [result] = interpolated(value,dx,dy)
%value[1]=f(x0,y0),value[2]=f(x1,y0)
%value[3]=f(x0,y1),value[4]=f(x1,y1)
%  00-----10
%  10-----11
% dx:distance from 00 to point
% dy:distance from 00 to point
a1=value(1)*(1-dx)*(1-dy);
a2=value(2)*(dx)*(1-dy);
a3=value(3)*(1-dx)*(dy);
a4=value(4)*(dx)*(dy);
result=a1+a2+a3+a4;
end

