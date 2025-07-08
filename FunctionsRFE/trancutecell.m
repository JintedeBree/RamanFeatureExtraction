function Data = trancutecell(Data,Lower,Upper)
% function trancutecell: trancutes the spectra within the range from lower to upper bound
% 
% Data = trancutecell(Data,Lower,Upper) removes all rows from matrix
% 'Data', where first column is less than or equal to the lower bound, or
% greater than or equal to the upper bound.
% 
% INPUT:
% - Data = matrix with first column containing wavenumber axis and
% remaining columns containg Raman spectra for pixels in raster scan.
% - Lower = lower bound of the range
% - Upper = upper bound of the range
% 
% OUPUT:
% - Data = the trancuted matrix 'Data' with only rows where first column values
% fall between the lower and upper bound

for i = length(Data(:,1)):-1:1
    if (Data(i,1) <= Lower) || (Data(i,1) >= Upper)
        Data(i,:) = [];
    end
end
end