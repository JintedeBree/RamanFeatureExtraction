function Cell = convertRawDataToCell(RawData)
% function convertRawDataToCell: converts the 1600-column matrix into a
% 40x40 cell array.
% 
% Cell = convertRawDataToCell(RawData) reshapes the spectral data from the
% 1600-column matrix into a 40x40 cell array. The columns are assigned from
% left to right, top to bottom. Every even-numbered row is flipped
% horizontally to account for the snake scanning pattern of the Raman
% system. Each cell contains a column vector of intensities corresponding
% to the wavenumber axis (first column of RawData).
% 
% INPUT:
% - RawData = matrix with first column containing wavenumber axis and
% remaining columns containg Raman spectra for pixels in raster scan.
%
% OUPUT:
% - Cell = 40x40 cell array where each cell contains a column vector
% corresponding to the spectrum at that spatial position.

Data_wthWvn = RawData(:,2:end);
Cell = cell(40, 40);
for i = 1:40
    for j = 1:40
        column = (i - 1) * 40 + j;
        Cell{i, j} = Data_wthWvn(:, column);
    end
end
for i=2:2:40
    FLIP = flip(Cell(i,:));
    Cell(i,:) = FLIP;
end
