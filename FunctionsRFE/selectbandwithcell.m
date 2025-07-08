function [Cell_BW, Cell_BWavr] = selectbandwithcell(Cell,RawData,lower,upper)
% function selectbandwithcell: extracts and averages the peak intensity
% within a spectrum bandwidth
% 
% [Cell_BW, Cell_BWavr] = selectbandwithcell(Cell,RawData,lower,upper)
% takes the 40x40 array with each cell containing a spectrum of a pixel.
% In each cell, it selects the spectral values within the spectrum bandwidth 
% between lower and upper bound. Then, in all cells, the remaining 
% spectral values are averaged. Lastly, in all cells, the average value is
% multiplied by the bandwidth of the selected spectrum (upper - lower).
% 
% INPUT:
% - Cell = a 40x40 cell array with each cell containing a spectrum of a
% pixel. Rows correspond spectral values to spectral points on wavenumer
% axis.
% - RawData = a matrix in which the first column contains wavenumber axis and
% remaining columns containg Raman spectra for pixels in raster scan. The
% amount of rows in RawData must correspond to amount of rows of Cell,
% since the rows correspond to specific wavenumbers
% - Lower = lower bound of the range
% - Upper = upper bound of the range
% 
% OUPUT:
% - Cell_BWavr = a 40x40 numeric array containing the average of the
% spectral values within the spectrum bandwidth (lower to upper bound) for each
% cell
% - Cell-BW = the same 40x40 numeric array as Cell_BWavr, but multiplied by
% the spectral bandwidth (upper - lower)

Cell_BWavr = Cell;

inrange = RawData(:,1) > lower & RawData(:,1) < upper;
bandwidth = RawData(inrange, 1);
maxVal = max(bandwidth);
minVal = min(bandwidth);

for i=length(RawData(:,1)):-1:1
    if (RawData(i,1)<=lower) || (RawData(i,1)>=upper)
        for row=1:40
            for column=1:40
                Cell_BWavr{row,column}(i,:)=[];
            end
        end
    else
        continue
    end
end

for row=1:40
    for col=1:40
        Cell_BWavr{row,col}=mean(Cell_BWavr{row,col});
    end
end

Cell_BWavr = cell2mat(Cell_BWavr);
Cell_BW = Cell_BWavr*(maxVal-minVal);
end
