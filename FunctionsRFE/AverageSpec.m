function Average = AverageSpec(Data)
% function AverageSpec: computes average spectrum across all spectra of
% raster scan.
% 
% Average = AverageSpec(Data) calculates the average intensity ate ach
% wavenumber by avering across all spectra of the raster scan.
%
% INPUT:
% - Data = A 1601-column matrix with first column containing wavenumber axis and
% remaining columns containg Raman spectra for pixels in raster scan.
% 
% OUPUT:
% - Average = A 2-column matrix with first column containing wavenumber axis and
% the second column containing averaged intensities of all spectra.

averagedValues = mean(Data(:, 2:end), 2);
Average = [Data(:, 1), averagedValues];
end
