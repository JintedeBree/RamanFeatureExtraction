function [matr_for_lorentz, cell_for_lorentz, masked_for_lorentz, meancorrMatrix, Lorentzfit960, Lorentzpara960, FWHM960, FWHM960_hand, Intensity960, PeakPosition960, Lorentzbaseline, integral960, resnorm,residual] = featureslorenzfit(Data,Binairy,lower,upper)
% function featureslorenzfit: fits the Lorentzian function to the selected
% bandwidth (upper - lower) and extracts spectral features.
% 
% This function extracts spectral features by: isolating a peak region
% (bandwidth), applying the Lorantzian function as fit, and extract
% spectral features from the fit such as FWHM, intensity, area, peak
% position. Information about the fit (such as resnorm and residuals) is
% also extracted. 
% 
% INPUT:
% - Data = a 1601-column matrix with first column containing wavenumber axis and
% remaining 1600 columns containing Raman spectra for pixels in raster scan.
% - Binairy = 40x40 binary mask indicating the pixels wihtin
% microcalcifications and therefore which spectra need to be processed.
% - Lower = lower bound of Lorentzian fit
% - Upper = upper bound of Lorentzian fit
%
% OUPUT:
% - matr_for_lorentz = a 1601-column matrix trancuted to [lower, upper] 
% range.
% - cell_for_lorentz = a 40x40 cell array of the truncated spectra.
% - masked_for_lorentz = a 40x40 cell array after masking with Binary; 
% pixels with a value equal to zero in Binairy will have a trancuted Raman 
% spectrum of only zero intensities.
% - meancorrMatrix = a 40x40 cell array with each cell containing the total
% sum of squares (SST).
% - Lorentzfit960 = a 40x40 cell array with coordinates for the fitted 
% Lorentzian curves (x, y).
% - Lorentzpara960 = a 40x40 cell array containg the Lorentz fit parameters 
% [a, x0, gamma].
% - FWHM960 = a 40x40 numeric matrix with each cell containing the FWHM 
% extracted from Lorentz parameter gamma.
% - FWHM960_hand = a 40x40 numeric matrix with each cell containing the FWHM 
% computed manually (corrected from baseline).
% - Intensity960 = a 40x40 numeric matrix with each cell containing the max
% intensity of the Lorentzian fit present within the tranctued Raman spectrum
% - PeakPosition960 = a 40x40 numeric matrix with each cell containing the
% wvn position of maximum intensity of fitted Loretnzian curve.
% - Lorentzbaseline = a 40x40 cell array with each cell containing baseline 
% coordinates (wavenumber vs. intensity) for each pixel with Lorentzian fit.
% - integral960 = a 40x40 numeric matrix with each cell containing the 
% area between the Lorentizan fit and the baseline.
% - resnorm = a 40×40 numeric matrix of residual norm values (sum of 
% squared differences between lorentzian fit and original spectrum).
% - residual = a 40x40 cell array of residual vectors 
% (original spectrum minus Lorentzian fit).



    Binairy_960 = Binairy;
    % truncate Raman spectrum to region of interest (lower to upper bound)
    matr_for_lorentz = trancutecell(Data, lower, upper);
    % convert to 40x40 cell matrix
    cell_for_lorentz = convertRawDataToCell(matr_for_lorentz);
    
    for i = 1:40
        for j = 1:40

            % apply binairy mask
            masked_for_lorentz{i,j} = Binairy_960(i,j) * cell_for_lorentz{i,j};
            
            % mean-center the spectrum; calculating the total sum of
            % squares (SST) for each spectrum
            mn = mean(masked_for_lorentz{i,j});
            meancorr{i,j} = masked_for_lorentz{i,j} - mn;
            meancorrMatrix{i,j} = sum(meancorr{i,j}.^2);

            % fit the Lorentzian function to the trancuted Raman spectrum
            x = matr_for_lorentz(:,1);
            y = masked_for_lorentz{i,j};
            lb = [0, min(x), 0]; 
            ub = [Inf, max(x), Inf];
            bounds = [lb; ub];  
            [yfit, p, resnorm_val, residual_val] = lorentzfit(x, y, [], bounds, '3');

            % extract the sum of squared residuals (resnorm) and residuals
            % (residual) of the Lorentzian fit to the trancuted Raman
            % spectrum
            resnorm(i,j) = resnorm_val;
            residual{i,j} = residual_val;

            % extract the parameters (a, x0, gamma) of the Lorentzian fit
            a = p(1); % amplitude
            x0 = p(2); % peak position
            gamma = p(3); % width factor
            Lorentzpara960{i,j} = p;
           
            % create the coordinates of the Lorentzian fit
            % (high-resolution)
            xfit = lower:0.1:upper;
            yfit_highres = a./((xfit - x0).^2 + gamma);
            yfit_fun = @(x) a./((x - x0).^2 + gamma);
            yfit_integral = integral(yfit_fun,lower,upper);
            Lorentzfit960{i,j} = [xfit(:), yfit_highres(:)];
           
            % extract intensity and exact position of the peak in the
            % region of interest
            [Max,Index] = max(yfit_highres(:));
            Intensity960(i,j) = Max;
            PeakPosition960(i,j) = xfit(Index);

            % extract the area of the peak in the region of interest; area
            % is defined as the surface under the Lorentzian fit minus the
            % baseline
            y_baseline = yfit_highres(1) + ((yfit_highres(end)-yfit_highres(1))/(xfit(end)-xfit(1)))*(xfit-xfit(1));
            base_fun = @(x) yfit_highres(1) + ((yfit_highres(end)-yfit_highres(1))/(xfit(end)-xfit(1)))*(x-xfit(1));
            base_integral = integral(base_fun,lower,upper);
            Lorentzbaseline{i,j} = [xfit(:), y_baseline(:)];
            integral960(i,j) = yfit_integral - base_integral;

            % extract the FWHM from the parameters of the Lorentzian fit
            FWHM960(i,j) = 2 * sqrt(p(3));

            % extract the FWHM manually (corrects for the baseline)
            yfit_corrected = yfit_highres - y_baseline;
            [peak_height, peak_index] = max(yfit_corrected);
            half_max = peak_height / 2;

            left_idx = find(yfit_corrected(1:peak_index) < half_max, 1, 'last');
            right_idx = peak_index - 1 + find(yfit_corrected(peak_index:end) < half_max, 1, 'first');
            
            if ~isempty(left_idx) && ~isempty(right_idx)
                x_left = interp1(yfit_corrected(left_idx:left_idx+1), xfit(left_idx:left_idx+1), half_max);
                x_right = interp1(yfit_corrected(right_idx-1:right_idx), xfit(right_idx-1:right_idx), half_max);
                FWHM960_hand(i,j) = x_right - x_left;
            else
                FWHM960_hand(i,j) = NaN;
            end


        end
    end

    FWHM960(Binairy == 0) = 0;
    Intensity960(Binairy == 0) = 0;
    PeakPosition960(Binairy == 0)= 0;
    integral960(Binairy == 0) = 0;
    resnorm(Binairy == 0) = 0;
    
end