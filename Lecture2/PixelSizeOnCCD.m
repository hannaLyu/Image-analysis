function [FOV] =  PixelSizeOnCCD(G,g)
%UNTITLED3 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
% if(horizontal==false)
    v_half=atan2(g,G);
    FOV=atan2(1-v_half^2,2*v_half);
% else
%     v_half=atan2(G/g);
%     FOV=atan2((2*v_half)/1-v_half^2);
% end
FOV=FOV*180/pi;
    
end

