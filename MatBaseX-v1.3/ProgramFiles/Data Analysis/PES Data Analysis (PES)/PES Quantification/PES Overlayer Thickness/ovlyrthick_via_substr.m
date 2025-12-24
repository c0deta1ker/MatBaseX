function ovlyr_thickness = ovlyrthick_via_substr(alpha, lambda_ovlyr, I_substr_bulkref, I_substr)
% ovlyr_thickness = ovlyrthick_via_substr(alpha, lambda_ovlyr, I_substr_bulkref, I_substr)
%   Function that determines the thickness of an overlayer via XPS using
%   the Beer-Lambert Law (1852) [1-2] which assumes an exponential attenuation 
%   in the overlayer. The model assumes that the substrate is infinitely 
%   thick, with a uniform overlayer on top. This simple formalism works as
%   the sensitivity factors cancel out in the ratio of intensities.
%   The thickness is calculated by using only the photoelectron peaks that
%   derive from the substrate. 
%   [1] Beer, Bestimmung der Absorption des rothen Lichts in farbigen Flussigkeiten (1852)
%   [2] J. Walton et al., Film thickness measurement and contamination layer correction for quantitative XPS (2016)
%
%   IN:
%   -   alpha:              scalar or 1×M row vector of the photoelectron take-off angle relative to the surface normal (i.e. normal emission = 0) [degrees]
%   -   lambda_ovlyr:       scalar or 1×M row vector of the attenuation length of electrons in the overlayer [nm or Angstrom].
%   -   I_substr_bulkref:   scalar or N×1 column vector of the total peak area of the bulk substrate photoelectron peak.
%   -   I_substr:  	        scalar or N×1 column vector of the total peak area of the substrate photoelectron peak with an overlayer.
%
%   OUT:
%   -   ovlyr_thickness:    scalar or N×M array of the thickness of the overlayer [nm or Angstrom].

%% -- Validity check on inputs
if size(alpha, 1) >1; alpha = alpha'; end
if size(lambda_ovlyr, 1) >1; lambda_ovlyr = lambda_ovlyr'; end
if size(I_substr_bulkref, 2) >1; I_substr_bulkref = I_substr_bulkref'; end
if size(I_substr, 2) >1; I_substr = I_substr'; end
%% 1 : Determination of the overlayer thickness
ovlyr_thickness = -1 .* lambda_ovlyr .* cos(deg2rad(alpha)) .* log(I_substr ./ I_substr_bulkref);
end