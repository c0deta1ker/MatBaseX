function FP = calc_angle_aniso_FP(beta, gamma, delta, theta, phi, P)
% FP = calc_angle_aniso_FP(beta, gamma, delta, theta, phi, P)
%   This function computes the angular anisotropy factor, FP, for 
%   partially polarized light that is incident on the sample. FP depends on the 
%   experimental geometry, which is specified by two angles: theta and phi. 
%   Theta is the angle between the emitted photoelectrons and the electric field 
%   vector, and phi is the angle between the direction of the incident photons 
%   and the direction of the emitted photoelectrons. The parameter P
%   determines the degree of polarization; a value of 0.5 indicates
%   unpolarised light, and 0 or 1 indicated linear polarised light.
%   This formalism is common to use in the Hard X-Ray regime, where the
%   David Cant Cross-Sections are also used. This is from the original 
%   work of David J. H. Cant [1], see below.
%   [1] David J. H. Cant, Ben F. Spencer, Wendy R. Flavell, Alexander G. Shard. Surf Interface Anal. 2022; 54(4): 442-454. doi:10.1002/sia.7059
%
%   IN:
%   -   beta:  	    scalar or N×1 vector of the dipole asymmetry factor.
%   -   gamma:      scalar or N×1 vector of the first non-dipole asymmetry factor.
%   -   delta:      scalar or N×1 vector of the second non-dipole asymmetry factor.
%   -   theta:      scalar or 1xM vector of the polar angle between the photoelectron vector relative to electric field vector (i.e. at normal emission: LV (p-pol, E//MP) = 0, LH (s-pol, E⊥MP) = 90) [degree]
%   -   phi:        scalar of the azimuthal angle between the photon momentum vector relative to the projection of the photoelectron vector on to the plane perpendicular to the electric field vector (i.e. normal emission = 0) [degree]
%   -   P:          scalar of degree of polarization, where 1 or 0 is equivalent to full linear polarization, and 0.5 is equivalent to unpolarized light.
%
%   OUT:
%   -   FP:      	scalar or NxM matrix of the angular anisotropy factor for partially polarized light.

%% -- Validity check on inputs
if nargin < 4; theta = 0;  end
if nargin < 5; phi = 0;  end
if nargin < 6; P = 0.5;  end
if isempty(theta);      theta = 0; end
if isempty(phi);        phi = 0; end
if isempty(P);          P = 0.5; end
%% 1 : Angular anisotropy factor for partially polarized light
FP_01 = P .* (1 + 0.5 .*beta .* (3 .* cos(deg2rad(theta)).^2 - 1) + (delta + gamma .* cos(deg2rad(theta)).^2) .* sin(deg2rad(theta)) .* cos(deg2rad(phi)));
FP_02 = (1 - P).* (1 + 0.5 .*beta .* (3 .* sin(deg2rad(theta)).^2 .* sin(deg2rad(phi)).^2 - 1) + (delta + gamma .* sin(deg2rad(theta)).^2 .* sin(deg2rad(phi)).^2) .* sin(deg2rad(theta)) .* cos(deg2rad(phi)));
FP = FP_01 + FP_02;
end