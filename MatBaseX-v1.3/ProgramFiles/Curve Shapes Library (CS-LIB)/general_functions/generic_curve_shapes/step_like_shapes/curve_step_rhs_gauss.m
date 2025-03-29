function y = curve_step_rhs_gauss(x, center, amplitude, fwhm)
% y = curve_step_rhs_gauss(x, center, amplitude, fwhm)
%   Function that evaluates a LHS Step curve profile whose edge is
%   modulated via a Gaussian function. The center position of the step, 
%   its amplitude and full-width at half-maximum (fwhm) can 
%   be defined. For all values < x0, the output is the Gaussian decay 
%   function, whereas all values > x0 yield a value equal to I0.
%   Used to simulate a step-profile that has a Gaussian edge.
%
%   IN:
%   -   x:              N×1 (or 1×N) vector of the input domain
%   -   center:         scalar of the position of the step along the x-axis
%   -   amplitude:      scalar of the maximum amplitude of the step
%   -   fwhm:           scalar of the characteristic FWHM of the Gaussian edge
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
F1      = curve_step_rhs(x, center, amplitude);
sigma   = fwhm ./ (2*sqrt(2*log(2))); 
F2      = exp(-0.5.*((x-center)./sigma).^2);
F2      = amplitude .* F2 / max(F2);
% -- Isolating the function over the given domains
f1      = F1(x<center); if size(f1, 2) > 1; f1 = f1'; end
f2      = F2(x>=center); if size(f2, 2) > 1; f2 = f2'; end
% -- Concatinating the data over the domain
if isrow(f1) && length(f1) > 1;     y    = horzcat(f1, f2);
else;                               y    = vertcat(f1, f2);
end
%% Validity check on the outputs
y(isnan(y)) = 0;
if isrow(x); if size(y, 2) ~= length(x); y = y'; end
elseif iscolumn(x); if size(y, 1) ~= length(x); y = y'; end
end
end