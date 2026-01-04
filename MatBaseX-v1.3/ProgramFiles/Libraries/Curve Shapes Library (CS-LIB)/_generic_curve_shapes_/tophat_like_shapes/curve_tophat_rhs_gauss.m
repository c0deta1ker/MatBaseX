function y = curve_tophat_rhs_gauss(x, center, amplitude, width, fwhm)
% y = curve_tophat_rhs_gauss(x, center, amplitude, width, fwhm)
%   Function that evaluates a Top-Hat curve profile whose RHS edge is
%   modulated via a Gaussian function. The position of the centre, 
%   its amplitude, width and full-width at half-maximum (fwhm) of the Gaussian edge 
%   can be defined. 
%   For all values of x outside of the Top-Hat function, the output is the 
%   Gaussian decay function, whereas all values inside the width of the Top-Hat
%   function yield a value equal to the amplitude.
%   Used to simulate a top-hat profile that is Gaussian broadened on the
%   right-hand side only.
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
if nargin < 5; fwhm = 0; end
if isempty(center); center = 0; end
if isempty(amplitude); amplitude = 1; end
if isempty(width); width = 1; end
if isempty(fwhm); fwhm = 0; end
%% Validity check on the input parameters
if width < 0; width = 0; end        % -- Ensure width is a positive number
if fwhm < 0; fwhm = 0; end          % -- Ensure fwhm is a positive number
%% - 1 - Determination of the TopHat curve intensities
% -- Calculating the functions over the defined domain
F1      = curve_tophat(x, center, amplitude, width);
sigma   = fwhm ./ (2*sqrt(2*log(2))); 
F2      = exp(-0.5.*((x-center-0.5*width)./sigma).^2);
F2      = amplitude .* F2 / max(F2);
% -- Isolating the function over the given domains
f1      = F1(x<center+0.5*width); if size(f1, 2) > 1; f1 = f1'; end
f2      = F2(x>=center+0.5*width); if size(f2, 2) > 1; f2 = f2'; end
% -- Concatinating the data over the domain
if isrow(f1);   y    = horzcat(f1, f2);
else;           y    = vertcat(f1, f2);
end
%% Validity check on the outputs
y(isnan(y)) = 0;
if isrow(x); if size(y, 2) ~= length(x); y = y'; end
elseif iscolumn(x); if size(y, 1) ~= length(x); y = y'; end
end
end