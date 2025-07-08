function Rsquared = rsqaured(resnorm,meancorrMatrix,Binairy)
% function rsquared: calculates the R squared value for each cell with
% value 1 in 'Binairy'.
% 
% Rsquared = rsqaured(resnorm,meancorrMatrix,Binairy) creates a 40x40 matrix 
% containing R squared values based on resnorm and meancorrMatrix. The higher the
% value of Rsquared in a cell, the better the Lorentzian function fits the
% Raman spectrum of the cell. R squared is calculated by: R2 = 1 -
% (resnorm/meancorrMatrix).
% 
% INPUT:
% - resnorm = a 40x40 numeric matrix with each cell containing the sum of 
% the residuals squared (of Lorentzian function fit to Ramen spectrum).
% - meancorrMatrix = a 40x40 cell array with each cell containing the total
% sum of squares (SST).
% - Binairy = a 40x40 matrix indicating cell with value 1 as cells within
% microcalcification
% 
% OUPUT:
% - Rsquared = a 40x40 numeric matrix with the R squared value for each
% cell. Cells get a value equal to zero if cells are masked out by Binairy.


Rsquared_div = resnorm ./ cell2mat(meancorrMatrix);
        for row = 1:40
            for col = 1:40
                if isnan(Rsquared_div(row,col))
                    Rsquared(row,col) = NaN;
                else
                    Rsquared(row,col) = 1 - Rsquared_div(row,col);
                end
            end
        end
        Rsquared(Binairy == 0) = 0;
end