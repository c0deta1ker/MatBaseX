function y = curve_thermal_FDDG(x, center, temperature, width)
% y = curve_thermal_FDDG(x, center, temperature, width)
%   A model based on the Fermi-Dirac Distribution (FDD) with Gaussian broadening. 
%   The model has 3 input parameters; center (fermi-energy), temperature and 
%   width (full-width at half-maximum of a convolved Gaussian to account for 
%   energy resolution broadening). The width parameter is used to simulate the broadening 
%   introducted by the beamline+analyzer resolution. The parameter kt should 
%   be defined in the same units as x (kB = 8.617e-5 eV/K).
%
%   IN:
%   -   x:              N×1 (or 1×N) vector of the input domain
%   -   center:         scalar that defines the center along the x-axis (Fermi-level position)
%   -   temperature:    scalar that defines the temperature of the system
%   -   width: 	        scalar that defines the FWHM of the Gaussian broadening term
%
%   OUT:
%   -   y:              N×1 (or 1×N) vector of the output range

%% Default parameters
if nargin < 2; center = 0; end
if nargin < 3; temperature = 12;  end
if nargin < 4; width = 0;  end
if isempty(center); center = 0; end
if isempty(temperature); temperature = 12; end
if isempty(width); width = 0; end
%% Validity checks on the input parameters
if temperature < 0; temperature = 0; end        % -- If the temperature is <0, pad it to 0
if width < 0; width = 0; end                    % -- If the width is <0, pad it to 0
%% 1 - Determining the FDD and Gaussian functions to use
% - Defining a large domain that spans the desired domain
x_large = linspace(min(x(:)) - 2, max(x(:)) + 2, 1e4)';
% - FDD function
int_fdd     = curve_thermal_FDD(x_large, center, temperature);
% - Gaussian function
int_Gauss  	= curve_gaussian(x_large, center, 1, width);
%% 2 - Convolving the FDD and Gaussian functions
y_conv      = conv(int_fdd, int_Gauss, 'same'); 
y_conv      = y_conv / max(y_conv);
% - Eliminate edge effects of the convolution
for i = 0:size(y_conv, 1)-1
    y_conv_val = y_conv(end-i); if y_conv_val == 1; y_conv(1:end-i) = 1; break; end
end
% - Validity check that the Fermi-level is the same
[~, indx]       = min(abs(y_conv - 0.5));
ef_shift        = x_large(indx) - center;
% - Assigning the best fit Fermi function
fdd_fit         = fit(x_large-ef_shift, y_conv, 'linearinterp');  
%% 3 - Defining the final intensity array
y = fdd_fit(x);
if ~isequal(size(x), size(y)); y = y'; end
%% Validity check on the outputs
y(isnan(y)) = 0;
if isrow(x); if size(y, 2) ~= length(x); y = y'; end
elseif iscolumn(x); if size(y, 1) ~= length(x); y = y'; end
end
end