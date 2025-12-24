function y = curve_tophat_rhs_gauss_trunc(x, center, amplitude, width, fwhm, cutoff)
% y = curve_tophat_rhs_gauss_trunc(x, center, amplitude, width, fwhm, cutoff)
%   Function that evaluates a Top-Hat curve profile whose RHS edge is
%   modulated via a Gaussian function. The position of the centre, 
%   its amplitude, width and full-width at half-maximum (fwhm) of the Gaussian edge 
%   can be defined. 
%   For all values of x outside of the Top-Hat function, the output is the 
%   Gaussian decay function, whereas all values inside the width of the Top-Hat
%   function yield a value equal to the amplitude.
%   Additionally, the function is truncated to zero at the 'cutoff' point.
%   Used to simulate a top-hat profile that is Gaussian broadened on the
%   right-hand side only.
%   
%   IN:
%   -   x:              N×1 (or 1×N) vector of the input domain
%   -   center:         scalar of the position of the step along the x-axis
%   -   amplitude:      scalar of the maximum amplitude of the step
%   -   width:          scalar of the total width of the top-hat function and should be a positive number
%   -   fwhm:           scalar of the characteristic FWHM of the Gaussian edge and should be a positive number
%   -   cutoff:         scalar of the x-axis position where truncation to zero occurs for x > |xtrunc|
%
%   OUT:
%   -   y:              N×1 (or 1×N) vector of the output range

%% Default parameters
if nargin < 2; center = 0; end
if nargin < 3; amplitude = 1; end
if nargin < 4; width = 1; end
if nargin < 5; fwhm = 0; end
if nargin < 6; cutoff = Inf; end
if isempty(center); center = 0; end
if isempty(amplitude); amplitude = 1; end
if isempty(width); width = 1; end
if isempty(fwhm); fwhm = 0; end
if isempty(cutoff); cutoff = Inf; end
%% Validity check on the input parameters
if width < 0; width = 0; end        % -- Ensure width is a positive number
if fwhm < 0; fwhm = 0; end          % -- Ensure fwhm is a positive number
%% - 1 - Determination of the curve intensities
y = curve_tophat_rhs_gauss(x, center, amplitude, width, fwhm);
y(x>center+0.5*width+abs(cutoff)) = 0;
%% Validity check on the outputs
y(isnan(y)) = 0;
if isrow(x); if size(y, 2) ~= length(x); y = y'; end
elseif iscolumn(x); if size(y, 1) ~= length(x); y = y'; end
end
end