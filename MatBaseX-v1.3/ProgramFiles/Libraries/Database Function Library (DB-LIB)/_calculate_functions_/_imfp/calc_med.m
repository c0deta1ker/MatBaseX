function med = calc_med(imfp, alpha)
% med = calc_med(imfp, alpha)
%   Function that calculates the mean escape depth (MED). This is a useful 
%   measure of the surface sensitivity of an XPS measurement for a particular 
%   material and instrument configuration. See below literature for more
%   information.
%   [1] C. J. Powell, Practical guide for inelastic mean free paths, effective attenuation lengths, mean escape depths, and information depths in x-ray photoelectron spectroscopy (2020)
%   [2] M. P. Seah, Quantitative electron spectroscopy of surfaces A Standard Data Base for Electron Inelastic Mean Free Paths in Solids (1979)
%
%   IN:
%   -   imfp:       scalar or N×1 column vector of the electron IMFP values [Angstrom]
%   -   alpha:      scalar or 1×M row vector of the photoelectron take-off angle relative to the surface normal (i.e. normal emission = 0) [degree]
%
%   OUT:
%   -   med:        scalar or N×M array of the electron MED [Angstrom]

%% Default parameters
if nargin < 2; alpha = 0; end
if isempty(alpha); alpha = 0; end
%% - 1 - Determination of the MED
med = imfp .* cos(deg2rad(alpha));
end