function RawData = convertCellToRawData(Cell, wvn)
% function convertCellToRawData: converts the 40x40 cell array into the
% original 1600-column matrix.
% 
% Cell = convertCellToRawData(RawData) reshapes the spectral data from the
% 40x40 cell array into the original 1600-column matrix. It is the inverse
% function of the convertRawDataToCell. Odd rows in Cell are read left to
% right and even rows in Cell are read right to left (snake pattern of 
% Raman system). The columns are are assigned from top to bottom.
% 
% INPUT:
% - Cell = 40x40 cell array where each cell contains a column vector of
% intensities corresponding to the spectrum at that spatial position.
% - wvn = a collumn vector representing the wavenumer axis (must be same
% lenght as the columns in Cell).
%
% OUPUT:
% - Cell = a 1601-column matrix with first column containing wavenumber axis and
% remaining columns containg Raman spectra for pixels in raster scan.

axis = length(wvn);
RawData = zeros(axis, 1600);

counter = 1;
for i = 1:40
    if mod(i,2) == 0 
        col = 40:-1:1;
    else             
        col = 1:40;
    end
    for j = col
        RawData(:, counter) = Cell{i, j};
        counter = counter + 1;
    end
end

RawData = [wvn, RawData];
end