function y = curve_tophat_lhs_erf(x, center, amplitude, width, fwhm)
% y = curve_tophat_lhs_erf(x, center, amplitude, width, fwhm)
%   Function that evaluates a Top-Hat curve profile whose edges are
%   modulated via an error-function. The position of the centre,
%   its amplitude, width and the error-function full-width at half-maximum 
%   (fwhw) can be defined. 
%   For all values of x outside of the Top-Hat function, the output is the 
%   error-functio function, whereas all values inside the width of the 
%   Top-Hat function yield a value equal to the amplitude.
%   
%   IN:
%   -   x:              N×1 (or 1×N) vector of the input domain
%   -   center:         scalar of the position of the step along the x-axis
%   -   amplitude:      scalar of the maximum amplitude of the step
%   -   width:          scalar of the total width of the top-hat function and should be a positive number
%   -   fwhm:           scalar of the characteristic FWHM of the Gaussian edge and should be a positive number
%
%   OUT:
%   -   y:              N×1 (or 1×N) vector of the output range

%% Default parameters
if nargin < 2; center = 0; end
if nargin < 3; amplitude = 1; end
if nargin < 4; width = 1; end
if nargin < 5; fwhm = 1; end
if isempty(center); center = 0; end
if isempty(amplitude); amplitude = 1; end
if isempty(width); width = 1; end
if isempty(fwhm); fwhm = 1; end
%% Validity check on the input parameters
if width < 0; width = 0; end            % -- Ensure width is a positive number
if fwhm < 0; fwhm = 0; end              % -- Ensure fwhm is a positive number
%% - 1 - Determination of the curve intensities
sigma   = fwhm ./ (2*sqrt(2*log(2))); 
% -- Calculating the functions over the defined domain
F1 = curve_tophat(x,center,amplitude,width);
F2 = amplitude.*normcdf(-x, -center-0.5*width, sigma);
F3 = amplitude.*normcdf(x, center-0.5*width, sigma);
% -- Isolating the function over the given domains
f1 = F1(x>center); if size(f1, 2) > 1; f1 = f1'; end
f3 = F3(x<=center); if size(f3, 2) > 1; f3 = f3'; end
% -- Concatinating the data over the domain
if isrow(f1);   y    = horzcat(f3, f1);
else;           y    = vertcat(f3, f1);
end
%% Validity check on the outputs
y(isnan(y)) = 0;
if isrow(x); if size(y, 2) ~= length(x); y = y'; end
elseif iscolumn(x); if size(y, 1) ~= length(x); y = y'; end
end
end