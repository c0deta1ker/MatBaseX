function Fadj = calc_angle_aniso_Fadj(beta, theta, phi, avg_Z)
% Fadj = calc_angle_aniso_Fadj(beta, theta, avg_Z)
%   This function computes the angular anisotropy factor, Fadj, for 
%   unpolarized light that is incident on the sample. Fadj depends on the 
%   experimental geometry, which is defined by spherical coordinates. 
%   The only angle needed for this function is the angle between the 
%   direction of the incoming photons and the direction of the emitted 
%   photoelectrons. First, the adjusted asymmetry factor for solid
%   materials is determined via the equation:
%       β* = β (a - bZ + cZ^2), where a = 0.781; b = 0.00514; c = 0.000031;
%   This is then used to determine the angular anisotropy via the equation:
%       L = 1 + 1/2 β* (3/2 sin^2(ω) - 1)
%   This formalism is common to use in the Soft X-Ray regime, where the
%   Yeh-Lindau Cross-Sections are also used. See reference below for more
%   information.
%   [1] Angle Resoled XPS, Thermo Scientific, Application Note: 31014
%
%   IN:
%   -   beta:  	    scalar or N×1 vector of the dipole asymmetry factor.
%   -   theta:      scalar or 1xM vector of the polar emission angle of the photoelectrons relative to the surface normal (i.e. at normal emission = 0) [degree]
%   -   avg_Z:      scalar of the average mass number of the compound.
%
%   OUT:
%   -   Fadj:      	scalar or NxM matrix of the angular anisotropy factor for unpolarised light.

%% 1 : Determine the adjusted asymmetry factor for solid materials
a = 0.781; b = 0.00514; c = 0.000031;
beta_adj = beta .* (a - b.*avg_Z + c.*avg_Z.^2);    
%% 2 : Determine the angular correction factor using the asymmetry parameter
Fadj = 1 + 0.5.*beta_adj .* (1.5.*(cos(deg2rad(theta))).^2 - 1) .*ones(size(phi));
end