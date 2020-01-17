function [I,N,I_rem,N_rem] = CountCellNuclei_lriga(Im)
% CountCellNuclei Count the number of cell nuclei in an image
% specially designed for DAPI stained images from Chemometec
% Return an image (I) with cells nuclei and the number of nuclei N

% Fixex threshold
BW = (Im > 10);

% Remove objects touching border
BWc = imclearborder(BW);

% Label blobs
L = bwlabel(BWc,8);

% blob features
cellStats = regionprops(L, 'All');
 
%cellPerimeter = [cellStats.Perimeter];
%cellArea = [cellStats.Area];

% Compute circulatiry
circularity =  (4 * pi * [cellStats.Area]) ./ ([cellStats.Perimeter].^2);

% Filter based on circularity and area
idx = find(circularity > 1 & [cellStats.Area] < 150 & [cellStats.Area] > 50);

% Generate output image and number of found blobs
I = ismember(L,idx);
N = numel(idx);

%Optional: Image with cells that have been removed
idx_rem = find(circularity < 1 | [cellStats.Area] > 150 | [cellStats.Area] < 50);
I_rem = ismember(L,idx_rem);
N_rem = numel(idx);


