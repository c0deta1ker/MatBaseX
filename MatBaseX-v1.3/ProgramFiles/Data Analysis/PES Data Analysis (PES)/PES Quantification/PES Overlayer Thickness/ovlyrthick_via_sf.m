function ovlyr_thickness = ovlyrthick_via_sf(alpha, lambda_ovlyr, I_ovlyr, SF_ovlyr, I_substr, SF_substr)
% ovlyr_thickness = ovlyrthick_via_sf(alpha, lambda_ovlyr, I_ovlyr, SF_ovlyr, I_substr, SF_substr)
%   Function that determines the thickness of an overlayer via XPS using
%   the Hill (1976) formalism [1]. The thickness is calculated from the
%   relative photoelectron intensity of the overlayer and substrate. The
%   model assumes that the substrate is infinitely thick, with a uniform
%   overlayer on top. The sensitivity factors correspond to the intensities that
%   one would measure from pure specimens of the overlayer and substrate materials,
%   respectively, given exactly the same instrumental conditions and primary beam.
%   [1] J. M. Hill, Properties of oxidized silicon as determined by angular-dependent X-ray photoelectron spectroscopy (1976)
%   [2] A. G. Shard, Practical guides for x-ray photoelectron spectroscopy: Quantitative XPS (2020)
%
%   IN:
%   -   alpha:              scalar or 1×M row vector of the photoelectron take-off angle relative to the surface normal (i.e. normal emission = 0) [degrees]
%   -   lambda_ovlyr:       scalar or 1×M row vector of the attenuation length of electrons in the overlayer [nm or Angstrom].
%   -   I_ovlyr:  	        scalar or N×1 column vector of the total peak area of the overlayer photoelectron peak.
%   -   SF_ovlyr:           scalar or N×1 column vector of the sensitivity factor of the overlayer (or the total peak area of a bulk overlayer reference).
%   -   I_substr:           scalar or N×1 column vector of the total peak area of the substrate photoelectron peak.
%   -   SF_substr:          scalar or N×1 column vector of the sensitivity factor of the substrate (or the total peak area of a bulk substrate reference).
%
%   OUT:
%   -   ovlyr_thickness:    scalar or N×M array of the thickness of the overlayer [nm or Angstrom].

%% -- Validity check on inputs
if size(alpha, 1) >1; alpha = alpha'; end
if size(lambda_ovlyr, 1) >1; lambda_ovlyr = lambda_ovlyr'; end
if size(I_ovlyr, 2) >1; I_ovlyr = I_ovlyr'; end
if size(SF_ovlyr, 2) >1; SF_ovlyr = SF_ovlyr'; end
if size(I_substr, 2) >1; I_substr = I_substr'; end
if size(SF_substr, 2) >1; SF_substr = SF_substr'; end
%% 1 : Determination of the overlayer thickness
ovlyr_thickness = -1.* lambda_ovlyr .* cos(deg2rad(alpha)) .* log(1 + (I_ovlyr ./ SF_ovlyr) ./ (I_substr ./ SF_substr));
end