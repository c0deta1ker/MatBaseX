function FU = calc_angle_aniso_FU(beta, gamma, delta, omega)
% FU = calc_angle_aniso_FU(beta, gamma, delta, omega)
%   This function calculates the angular anisotropy factor, FU, for 
%   unpolarized light that is incident on the sample. FU depends on the 
%   experimental geometry, which is defined by spherical coordinates. 
%   The only angle needed for this function is the angle between the 
%   direction of the incoming photons and the direction of the emitted 
%   photoelectrons.
%   This formalism is common to use in the Hard X-Ray regime, where the
%   David Cant Cross-Sections are also used. This is from the original 
%   work of David J. H. Cant [1], see below.
%   [1] David J. H. Cant, Ben F. Spencer, Wendy R. Flavell, Alexander G. Shard. Surf Interface Anal. 2022; 54(4): 442-454. doi:10.1002/sia.7059
%
%   IN:
%   -   beta:  	    scalar or N×1 vector of the dipole asymmetry factor.
%   -   gamma:      scalar or N×1 vector of the first non-dipole asymmetry factor.
%   -   delta:      scalar or N×1 vector of the second non-dipole asymmetry factor.
%   -   omega:      scalar or 1xM vector of the angle between the photon momentum vector relative to the photoelectron vector [degree]
%
%   OUT:
%   -   FU:      	scalar or NxM matrix of the angular anisotropy factor for unpolarized light.

%% -- Validity check on inputs
if nargin < 4; omega = 90;  end
if isempty(omega); omega = 90; end
%% 1 : Angular anisotropy factor for unpolarized light
FU = 1 - 0.25 .*beta .* (3 .* cos(deg2rad(omega)).^2 - 1) + (delta + 0.5 .* gamma .* sin(deg2rad(omega)).^2) .* cos(deg2rad(omega));
end