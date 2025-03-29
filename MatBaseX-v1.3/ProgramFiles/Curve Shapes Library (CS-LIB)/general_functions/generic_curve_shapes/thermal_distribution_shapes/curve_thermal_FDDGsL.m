function y = curve_thermal_FDDGsL(x, center, temperature, width, linear_slope, linear_intercept, constant_bgrnd)
% y = curve_thermal_FDDGsL(x, center, temperature, width, linear_slope, linear_intercept, constant_bgrnd)
%   A model based on the Fermi-Dirac Distribution (FDD) with Gaussian
%   broadening and a linear background.
%   The model has 3 input parameters for the FDD; center (fermi-energy), 
%   temperature and width (full-width at half-maximum of a convolved Gaussian 
%   to account for energy resolution broadening). The width parameter is used 
%   to simulate the broadening introducted by the beamline+analyzer resolution. 
%   An additional 2 parameters are used to define a linear background that is 
%   SUMMED to account for any linear distortion of the Fermi-edge; 
%   linear_slope and linear_intercept.
%   An additional constant background is also included as constant_bgrnd.
%   The parameter kt should be defined in the same units as x (kB = 8.617e-5 eV/K).
%
%   IN:
%   -   x:                  N×1 (or 1×N) vector of the input domain
%   -   center:             scalar that defines the center along the x-axis (Fermi-level position)
%   -   temperature:        scalar that defines the temperature of the system
%   -   width: 	            scalar that defines the FWHM of the Gaussian broadening term
%   -   linear_slope:       scalar of the slope of the linear background
%   -   linear_intercept:  	scalar of the y-intercept of the linear background
%   -   constant_bgrnd:  	scalar of the constant background y-offset value
%
%   OUT:
%   -   y:                  N×1 (or 1×N) vector of the output range

%% Default parameters
if nargin < 2; center = 0; end
if nargin < 3; temperature = 12; end
if nargin < 4; width = 0; end
if nargin < 5; linear_slope = 0; end
if nargin < 6; linear_intercept = 1; end
if nargin < 7; constant_bgrnd = 0; end
if isempty(center);             center = 0; end
if isempty(temperature);        temperature = 12; end
if isempty(width);              width = 0; end
if isempty(linear_slope);       linear_slope = 0; end
if isempty(linear_intercept);   linear_intercept = 1; end
if isempty(constant_bgrnd);     constant_bgrnd = 0; end
%% Validity checks on the input parameters
if temperature < 0; temperature = 0; end        % -- If the temperature is <0, pad it to 0
if width < 0; width = 0; end                    % -- If the width is <0, pad it to 0
%% 1 - Determining the FDD, linear and background intensities
% - FDD function
int_fdd     = curve_thermal_FDDG(x, center, temperature, width);
% - Linear function
int_linear	= linear_slope .* x + linear_intercept;
% - Background value
int_bgrnd  	= constant_bgrnd;
%% 2 - Combining all the functions
y        = int_bgrnd + int_linear + int_fdd;
%% Validity check on the outputs
y(isnan(y)) = 0;
if isrow(x); if size(y, 2) ~= length(x); y = y'; end
elseif iscolumn(x); if size(y, 1) ~= length(x); y = y'; end
end
end