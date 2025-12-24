function imfp = mpd_calc_imfp_S1(ke_dat, material)
% imfp = mpd_calc_imfp_S1(ke_dat, material)
%   Function that determines the electron inelastic mean free path (IMFP) 
%   based on the S1 equation described by M. P. Seah [1]. The IMFP here
%   additionally depends on the value of Z and this formalism is compatible
%   for elemental or binary materials. In this function, you can define the 
%   material as a string and it will look it up the relevant parameters in 
%   the Material Properties Database (MPD).
%   See reference [1] for more information.
%   [1] M. P. Seah, An accurate and simple universal curve for the energy-dependent electron inelastic mean free path (2011)
%
%   IN:
%   -   ke_dat:  	scalar or vector of the input electron kinetic energy (for PES; KE = BE - PHI) [eV]
%   -   material:  	string of the material whose imfp is to be determined; e.g. "Si", "SiO2", "InAs", "Al2O3"...
%
%   OUT:
%   -   imfp:       scalar or vector of the electron IMFP values [Angstrom]

%% Default parameters (Parameters for Silicon)
if nargin < 2; material = "Si";  end
if isempty(material); material = "Si"; end
%% 1 - Extracting the material parameters from the materials database
material = string(material);                % Ensure the input is a string
material_props = get_mpd_props(material);   % Extracting the material properties
% - Extracting the material properties required for the S1 formalism
rho     = material_props.density;
M       = material_props.atom_mass;
Egap    = material_props.elec_band_gap;
Z       = material_props.atom_z;
stoic   = material_props.atom_stoic;
%% 2 - Determination of the IMFP via S1 formalism
imfp = calc_imfp_S1(ke_dat, rho, M, Egap, Z, stoic);   % extract imfp in Angstrom
end