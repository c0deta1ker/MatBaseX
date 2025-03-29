function y = curve_pseudo_voigt_sGLA_FDD(x, center, amplitude, width, mixratio, asymmetry, fdd_center, fdd_temperature, fdd_width)
% y = curve_pseudo_voigt_sGLA_FDD(x, center, amplitude, width, mixratio, asymmetry, fdd_center, fdd_temperature, fdd_width)
%   A model based on an asymmetric pseudo-sum Voigt distribution function
%   which is convolved with a Fermi-Dirac Districtuion (FDD). The model 
%   has 5 input parameters for the Voigt profile: center, amplitude, 
%   width (defined as the full-width at half-maximum (FWHM), equal to 3.6013σ), 
%   mixratio and asymmetry; an additional 3 input parameters define the
%   nature of the Fermi-Dirac Distribution. The Voigt profile is multiplied by 
%   the Fermi-Dirac Distribution FDDG(). These curve shapes are used for fitting EDCs near
%   the Fermi-edge, where the curve profiles may be chopped slightly due to
%   the close proximity of the Fermi-edge.
%
%   IN:
%   -   x:              N×1 (or 1×N) vector of the input domain
%   -   center:         scalar that defines the peak center along the x-axis
%   -   amplitude:      scalar that defines the peak amplitude
%   -   width:          scalar that defines the full-width at half-maximum (FWHM)
%   -   mixratio:       scalar that defines mixing ratio; 0 for pure Gaussian, 1 is for pure Lorentzian
%   -   asymmetry:      scalar that defines the asymmetry ratio; 0 for none, 0->1 is for LHS asymmetry, -1->0 is for RHS asymmetry
%   -   fdd_center:         scalar of the Fermi-level position (eV).
%   -   fdd_temperature:    scalar of the temperature (K).
%   -   fdd_width:          scalar of the full-width at half-maximum (FWHM) of the Gaussian broadening term (eV).
%
%   OUT:
%   -   y:              N×1 (or 1×N) vector of the output range

%% Default parameters
if nargin < 2;          center = 0; end
if nargin < 3;          amplitude = 1; end
if nargin < 4;          width = 1; end
if nargin < 5;          mixratio = 0.5;  end
if nargin < 6;          asymmetry = 0.0;  end
if nargin < 7;          fdd_center = 0; end
if nargin < 8;          fdd_temperature = 12; end
if nargin < 9;          fdd_width = 0; end
if isempty(center);             center = 0; end
if isempty(amplitude);          amplitude = 1; end
if isempty(width);              width = 1; end
if isempty(mixratio);           mixratio = 0.5; end
if isempty(asymmetry);          asymmetry = 0.0; end
if isempty(fdd_center);         fdd_center = 0; end
if isempty(fdd_temperature);    fdd_temperature = 12; end
if isempty(fdd_width);          fdd_width = 0; end
%% Validity checks on the input parameters
if width < 0; width = 0; end                % -- If the FWHM is negative, pad it to zero
if mixratio < 0; mixratio = 0; end          % -- If the MR is negative, pad it to zero
if mixratio > 1; mixratio = 1; end          % -- If the MR is >1, pad it to 1
if asymmetry < -1; asymmetry = -1; end      % -- If the ASYM is <-1, pad it to -1
if asymmetry > 1; asymmetry = 1; end        % -- If the ASYM is >1, pad it to 1
if fdd_temperature < 0; fdd_temperature = 0; end        % -- If the fdd_T is <0, pad it to 0
if fdd_width < 0; fdd_width = 0; end                    % -- If the fdd_fwhm is <0, pad it to 0
%% 1 - Determining the FDD and Gaussian functions to use
% - Extracting the intensity of the curve
int_sGLA  	= curve_pseudo_voigt_sGLA(x, center, amplitude, width, mixratio, asymmetry);
% - Extracting the intensity of the FDD curve
int_FDDG 	= curve_thermal_FDDG(x, fdd_center, fdd_temperature, fdd_width);
%% 2 - Multiplying the two functions together
if ~isequal(size(int_FDDG), size(int_sGLA)); int_FDDG = int_FDDG'; end
y        = int_FDDG .* int_sGLA; 
y        = amplitude .* y / max(y);
%% Validity check on the outputs
y(isnan(y)) = 0;
if isrow(x); if size(y, 2) ~= length(x); y = y'; end
elseif iscolumn(x); if size(y, 1) ~= length(x); y = y'; end
end
end