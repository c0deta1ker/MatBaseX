function y = curve_step_lhs_erf(x, center, amplitude, fwhm)
% y = curve_step_lhs_erf(x, center, amplitude, fwhm)
%   Function that evaluates a LHS Step curve profile whose edge is
%   modulated via a Gaussian function. The center position of the step, 
%   its amplitude and full-width at half-maximum (fwhm) can 
%   be defined. For all values > x0, the output is the Gaussian decay 
%   function, whereas all values < x0 yield a value equal to I0.
%   Used to simulate a step-profile that has a Gaussian edge.
%
%   IN:
%   -   x:              N×1 (or 1×N) vector of the input domain
%   -   center:         scalar of the position of the step along the x-axis
%   -   amplitude:      scalar of the maximum amplitude of the step
%   -   fwhm:           scalar of the characteristic FWHM of the Gaussian edge and should be a positive number
%
%   OUT:
%   -   y:              N×1 (or 1×N) vector of the output range

%% Default parameters
if nargin < 2; center = 0; end
if nargin < 3; amplitude = 1; end
if nargin < 4; fwhm = 1; end
if isempty(center); center = 0; end
if isempty(amplitude); amplitude = 1; end
if isempty(fwhm); fwhm = 1; end
%% Validity check on the input parameters
if fwhm < 0; fwhm = 0; end      % -- Ensure fwhm is a positive number
%% - 1 - Determination of the curve intensities
% -- Calculating the functions over the defined domain
H1 = normcdf(x, center, fwhm);
% -- Scaling the curve profile to match the desired peak
y = H1;
y = y - min(y(:));
y = amplitude .* y ./ max(y);
%% Validity check on the outputs
y(isnan(y)) = 0;
if isrow(x); if size(y, 2) ~= length(x); y = y'; end
elseif iscolumn(x); if size(y, 1) ~= length(x); y = y'; end
end
end