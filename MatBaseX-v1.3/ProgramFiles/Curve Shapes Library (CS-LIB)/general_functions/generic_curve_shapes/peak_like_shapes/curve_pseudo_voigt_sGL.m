function y = curve_pseudo_voigt_sGL(x, center, amplitude, width, mixratio)
% y = curve_pseudo_voigt_sGL(x, center, amplitude, width, mixratio)
%   A model based on a Voigt distribution function. The model has four
%   input parameters: center, amplitude, width (defined as the full-width 
%   at half-maximum (FWHM), equal to 3.6013σ), and mixratio. The function 
%   evaluates a pseudo-Voigt curve by expressing the curve profile as a SUM 
%   of Gaussian/Lorentzian curve types.
%
%   IN:
%   -   x:              N×1 (or 1×N) vector of the input domain
%   -   center:         scalar that defines the peak center along the x-axis
%   -   amplitude:      scalar that defines the peak amplitude
%   -   width:          scalar that defines the full-width at half-maximum (FWHM)
%   -   mixratio:       scalar that defines mixing ratio; 0 for pure Gaussian, 1 is for pure Lorentzian
%
%   OUT:
%   -   y:              N×1 (or 1×N) vector of the output range

%% Default parameters
if nargin < 2;      center = 0; end
if nargin < 3;      amplitude = 1; end
if nargin < 4;      width = 1; end
if nargin < 5;      mixratio = 0.5;  end
if isempty(center);         center = 0; end
if isempty(amplitude);      amplitude = 1; end
if isempty(width);          width = 1; end
if isempty(mixratio);       mixratio = 0.5; end
%% Validity checks on the input parameters
if width < 0; width = 0; end                % -- If the FWHM is negative, pad it to zero
if mixratio < 0; mixratio = 0; end          % -- If the MR is negative, pad it to zero
if mixratio > 1; mixratio = 1; end          % -- If the MR is >1, pad it to 1
%% - 1 - Determination of the Pseudo-Voigt Sum Model
% Evaluating the normalised curve profile
y    = (1-mixratio).*exp(-4.*log(2).*((x-center).^2 ./ width.^2)) + mixratio ./ (1 + 4.*((x-center).^2 ./ width.^2));
% Scaling the curve profile to match the desired amplitude
y 	= y ./ max(y(:));
y 	= amplitude .* y;
%% Validity check on the outputs
y(isnan(y)) = 0;
if isrow(x); if size(y, 2) ~= length(x); y = y'; end
elseif iscolumn(x); if size(y, 1) ~= length(x); y = y'; end
end
end