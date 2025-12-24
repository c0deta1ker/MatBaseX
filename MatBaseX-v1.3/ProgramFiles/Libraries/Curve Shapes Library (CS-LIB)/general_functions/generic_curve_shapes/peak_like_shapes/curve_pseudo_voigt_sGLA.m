function y = curve_pseudo_voigt_sGLA(x, center, amplitude, width, mixratio, asymmetry)
% y = curve_pseudo_voigt_sGLA(x, center, amplitude, width, mixratio, asymmetry)
%   A model based on an asymmetric pseudo-sum Voigt distribution function. The model 
%   has five input parameters: center, amplitude, width (defined as the full-width 
%   at half-maximum (FWHM), equal to 3.6013σ), mixratio and asymmetry. The function 
%   evaluates a pseudo-Voigt curve by expressing the curve profile as a SUM 
%   of Gaussian/Lorentzian curve types. The curve is then modified with an 
%   asymmetric, exponential blend, where:  V'(x) = V(x) + AEB(x) * (1 - V(x)), 
%   where V(x) is the original Voigt-Curve Model.
%
%   IN:
%   -   x:              N×1 (or 1×N) vector of the input domain
%   -   center:         scalar that defines the peak center along the x-axis
%   -   amplitude:      scalar that defines the peak amplitude
%   -   width:          scalar that defines the full-width at half-maximum (FWHM)
%   -   mixratio:       scalar that defines mixing ratio; 0 for pure Gaussian, 1 is for pure Lorentzian
%   -   asymmetry:      scalar that defines the asymmetry ratio; 0 for none, 0->1 is for LHS asymmetry, -1->0 is for RHS asymmetry
%
%   OUT:
%   -   y:              N×1 (or 1×N) vector of the output range

%% Default parameters
if nargin < 2;      center = 0; end
if nargin < 3;      amplitude = 1; end
if nargin < 4;      width = 1; end
if nargin < 5;      mixratio = 0.5;  end
if nargin < 6;      asymmetry = 0.0;  end
if isempty(center);         center = 0; end
if isempty(amplitude);      amplitude = 1; end
if isempty(width);          width = 1; end
if isempty(mixratio);       mixratio = 0.5; end
if isempty(asymmetry);      asymmetry = 0.0; end
%% Validity checks on the input parameters
if width < 0;       width = 0; end              % -- If the FWHM is negative, pad it to zero
if mixratio < 0;    mixratio = 0; end           % -- If the MR is negative, pad it to zero
if mixratio > 1;    mixratio = 1; end           % -- If the MR is >1, pad it to 1
if asymmetry < -1;  asymmetry = -1; end         % -- If the ASYM is <-1, pad it to -1
if asymmetry > 1;   asymmetry = 1; end          % -- If the ASYM is >1, pad it to 1
%% - 1 - Determination of the Pseudo-Voigt Sum Model
int_sGL     = curve_pseudo_voigt_sGL(x, center, amplitude, width, mixratio);
%% - 2 - Determination of the Exponential Asymmetric Blend (AEB) intensities
int_AEB     = curve_asym_exp_blend(x, center, asymmetry);
%% - 3 - Determination of sGLA curve intensities
y        = int_sGL + int_AEB .* (max(int_sGL(:)) - int_sGL);
% Scaling the curve profile to match the desired peak
y        = y ./ max(y(:));
y        = amplitude .* y;
%% Validity check on the outputs
y(isnan(y)) = 0;
if isrow(x); if size(y, 2) ~= length(x); y = y'; end
elseif iscolumn(x); if size(y, 1) ~= length(x); y = y'; end
end
end