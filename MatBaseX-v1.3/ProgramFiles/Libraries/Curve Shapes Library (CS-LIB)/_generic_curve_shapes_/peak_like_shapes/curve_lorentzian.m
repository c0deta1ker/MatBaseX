function y = curve_lorentzian(x, center, amplitude, width)
% y = curve_lorentzian(x, center, amplitude, width)
%   A model based on a Lorentzian or Cauchy-Lorentz distribution function.
%   The model has three input parameters; center, amplitude and width (defined 
%   as the full-width at half-maximum (FWHM), equal to 2σ).
%
%   IN:
%   -   x:              N×1 (or 1×N) vector of the input domain
%   -   center:         scalar that defines the peak center along the x-axis of the Lorentzian
%   -   amplitude:      scalar that defines the peak amplitude of the Lorentzian
%   -   width:          scalar that defines the full-width at half-maximum (FWHM) of the Lorentzian
%
%   OUT:
%   -   y:              N×1 (or 1×N) vector of the output range

%% Default parameters
if nargin < 2; center = 0; end
if nargin < 3; amplitude = 1; end
if nargin < 4; width = 1; end
if isempty(center); center = 0; end
if isempty(amplitude); amplitude = 1; end
if isempty(width); width = 1; end
%% Validity checks on the input parameters
if width < 0; width = 0; end      % -- If the FWHM is negative, pad it to zero
%% - 1 - Determination of the Lorentzian
% Using the standard deviation as the input width so that the FWHM is correct
sigma   = 0.5*width; 
% Evaluating the curve profile
y    = (amplitude .* sigma./pi) ./ ((x - center).^2 + (sigma).^2);
% Scaling the curve profile to match the desired amplitude
y 	= y ./ max(y(:));
y 	= amplitude .* y;
%% Validity check on the outputs
y(isnan(y)) = 0;
if isrow(x); if size(y, 2) ~= length(x); y = y'; end
elseif iscolumn(x); if size(y, 1) ~= length(x); y = y'; end
end
end