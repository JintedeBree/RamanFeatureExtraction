function Binairy_960 = thresholdBinaryMatrix(RamanMatrix960, threshold)
% function thresholdBinaryMatrix: creates a binary matrix based on the the
% intensity map of the 960 peak (RamanMatrix960), using a threshold
% 
% Binairy_960 = thresholdBinaryMatrix(RamanMatrix960, threshold) applies a
% threshold to the 40x40 intensity matrix of 960 peak (RamanMatrix960). If
% value in the RamanMatrix960 is equal or larger than threshold, value of 
% corresponding pixel is set to 1. If the value in RamanMatrix960 is
% smaller than threshold, value of corresponding pixel is set to 0. 
% 
% INPUT:
% - RamanMatrix960 = a 40x40 numeric matrix containing values for intensity 
% of the bandwith 955-965 cm-1
% - Threshold = a scalar value used as threshold, determined by Otsu's
% method
% 
% OUPUT:
% - Binairy_960 = a 40x40 binary matrix resulting from thresholding of
% RamanMatrix960

Binairy_960 = RamanMatrix960;
for row = 1:40
    for column = 1:40
        if RamanMatrix960(row,column) <= threshold %THRESHOLD!!
            Binairy_960(row,column) = 0;
        else
            Binairy_960(row,column) = 1;
        end
    end
end
end