function [bckcorrspectrapixel,Cvalue] = backgroundcorr(wvn,spectrapixel,spectrabackground)
% function backgroundcorr: performs a background correction on the measured Raman
% spectrum.
% 
% [bckcorrspectrapixel,Cvalue] = backgroundcorr(wvn,spectrapixel,spectrabackground)
% perfroms a background correction based on algorithm studied by Beier et
% al. The background contaminant is substracted from the measured Raman
% spectrum (spectrapixel) using polynomial fitting. 
% 
% INPUT:
% - wvn = a column vector representing the wavenumer axis (must be same
% lenght as the columns spectrapixel and spectrabackground).
% - spectrapixel = a column vector representing the  measured Raman 
% spectrum within a microcalcification, which is contaminated with 
% background spectrum. 
% - spectrabackground = a column vector representing the background Raman
% spectrum.
% 
% OUPUT:
% - bckcorrspectrapixel = a column vector representing the background
% corrected Raman spectrum of the measurement.
% - Cvalue = estimated conribution of background spectrum to measured Raman
% spectrum.

SpectrumBCK = spectrabackground;
SpectrumMS = spectrapixel;

% Iteration properties
tic=1; % Iteration counter
X = SpectrumBCK; % Background
Bi = SpectrumMS; % Measured
Cguess = 0.6; % Guess of concentration of background, set to 0.6 acc. Beier et al.
%ftype = fittype('poly4'); % Determination of polynomial fit type
xspan=wvn; % Necessary for fit function
error=1; % High enough to stay in loop
while error > 0.01
    p = polyfit(xspan, Bi - Cguess * X, 3); % 3th-degree polynomial fit
    Pi = polyval(p, xspan); % Evaluate polynomial at each point in x
    Btemp = Cguess * X + Pi; % Estimated background
    error = norm(abs(Btemp-Bi))^2; % The error is the difference between last and current estimation
    Bi = min(Btemp,Bi); % The new estimation (Beier et al.) 
    tic=tic+1; % Count an iteration
    [Cguess,flag] = lsqr(SpectrumMS-Btemp,X); % Estimate the contribution of the contaminant with the new polynomial fit
end

Cvalue=Cguess;
bckcorrspectrapixel = spectrapixel - Cguess*spectrabackground;
end