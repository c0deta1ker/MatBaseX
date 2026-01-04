function y = curve_lorentzian_split(x, center, amplitude, width_lhs, width_rhs)
% y = curve_lorentzian_split(x, center, amplitude, width_lhs, width_rhs)
%   A model based on a Lorentzian or Cauchy-Lorentz distribution function.
%   The model has four input parameters; center, amplitude, width_lhs and
%   width_rhs (defined as the full-width at half-maximum (FWHM), equal to 
%   2σ). 'Split' means that the width of the distribution is different 
%   between left and right slopes.
%
%   IN:
%   -   x:              N×1 (or 1×N) vector of the input domain
%   -   center:         scalar that defines the peak center along the x-axis of the Lorentzian
%   -   amplitude:      scalar that defines the peak amplitude of the Lorentzian
%   -   width_lhs:      scalar that defines the lhs full-width at half-maximum (FWHM) of the Lorentzian
%   -   width_rhs:      scalar that defines the rhs full-width at half-maximum (FWHM) of the Lorentzian
%
%   OUT:
%   -   y:              N×1 (or 1×N) vector of the output range

%% Default parameters
if nargin < 2; center = 0; end
if nargin < 3; amplitude = 1; end
if nargin < 4; width_lhs = 1; end
if nargin < 5; width_rhs = 1; end
if isempty(center); center = 0; end
if isempty(amplitude); amplitude = 1; end
if isempty(width_lhs); width_lhs = 1; end
if isempty(width_rhs); width_rhs = 1; end
%% Validity checks on the input parameters
if width_lhs < 0; width_lhs = 0; end      % -- If the FWHM is negative, pad it to zero
if width_rhs < 0; width_rhs = 0; end      % -- If the FWHM is negative, pad it to zero
%% - 1 - Determination of the Split Lorentzian Model
% Using the standard deviation as the input width so that the FWHM is correct
sigma_lhs   = width_lhs; 
sigma_rhs   = width_rhs; 
% Evaluating the curve profile
H1      = heaviside(x - center);
H2      = heaviside(center - x);
y_01 = (2*amplitude) ./ (pi.*(sigma_lhs + sigma_rhs));
y_02 = (sigma_lhs.^2.*H2) ./ ((x - center).^2 + (sigma_lhs).^2);
y_03 = (sigma_rhs.^2.*H1) ./ ((x - center).^2 + (sigma_rhs).^2);
y    = y_01.*(y_02 + y_03);
% Scaling the curve profile to match the desired amplitude
y 	= y ./ max(y(:));
y 	= amplitude .* y;
%% Validity check on the outputs
y(isnan(y)) = 0;
if isrow(x); if size(y, 2) ~= length(x); y = y'; end
elseif iscolumn(x); if size(y, 1) ~= length(x); y = y'; end
end
end