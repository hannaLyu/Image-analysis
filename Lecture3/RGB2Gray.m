function h = RGB2Gray(I1,I2,I3)
%From given RGB temple to grayscale.
%   �˴���ʾ��ϸ˵��
A(:,:,1)=I1;
A(:,:,2)=I2;
A(:,:,3)=I3;
A=uint8(A);
h=rgb2gray(A);
h=double(h);


end

