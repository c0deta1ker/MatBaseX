function y = curve_doniachsunjic(x, center, amplitude, width, asymmetry)
% y = curve_doniachsunjic(x, center, amplitude, width, asymmetry)
%   A model based on a Doniach-Sunjic asymmetric lineshape. The formula
%   is used to characterise the asymmetry in the measured XPS of metallic
%   systems and has four input parameters: amplitude, center, width and gamma.
%   The problem with this function is that it lacks proper quantification,
%   as F and E are both quantities that are related to the FWHM and peak 
%   position respectively, but not exactly equal to them.
%
%   IN:
%   -   x:              N×1 (or 1×N) vector of the input domain
%   -   center:         scalar that defines the (approximate) peak center along the x-axis
%   -   amplitude:      scalar that defines the peak amplitude
%   -   width:          scalar that defines the (approximate) full-width at half-maximum (FWHM)
%   -   asymmetry:      asymmetry ratio; 0 for none, 1 is for maximum
%
%   OUT:
%   -   y:              N×1 (or 1×N) vector of the output range

%% Default parameters
if nargin < 2;  center = 0; end
if nargin < 3;  amplitude = 1; end
if nargin < 4;  width = 1; end
if nargin < 5;  asymmetry = 0.5;  end
if isempty(center);     center = 0; end
if isempty(amplitude);  amplitude = 1; end
if isempty(width);      width = 1; end
if isempty(asymmetry);  asymmetry = 0.2; end
%% Validity checks on the input parameters
if width < 0; width = 0; end      % -- If the FWHM is negative, set it to zero
if asymmetry < 0; asymmetry = 0; end      % -- If the asym is <0, set it to zero
if asymmetry > 1; asymmetry = 1; end      % -- If the asym is >1, set it to one
%% - 1 - Determination of the Doniach-Sunjic curve intensities
% Evaluating the normalised curve profile
y     = (cos(0.5*pi*asymmetry + (1-asymmetry).*atan((x - center) / width))) ./ ((width.^2+(x-center).^2).^((1-asymmetry)/2));
% Scaling the curve profile to match the desired peak
y 	= y ./ max(y(:));
y 	= amplitude .* y;
%% Validity check on the outputs
y(isnan(y)) = 0;
if isrow(x); if size(y, 2) ~= length(x); y = y'; end
elseif iscolumn(x); if size(y, 1) ~= length(x); y = y'; end
end
end