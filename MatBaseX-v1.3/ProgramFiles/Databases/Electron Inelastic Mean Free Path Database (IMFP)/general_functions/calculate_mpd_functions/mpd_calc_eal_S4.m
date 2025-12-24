function eal = mpd_calc_eal_S4(ke_dat, material)
% eal = mpd_calc_eal_S4(ke_dat, material)
%   Function that determines the electron effective attenuation length (EAL) 
%   based on S4 formalism described by M. P. Seah [1]. The EAL here
%   only depends on the value of Z. In this function, you can define the 
%   material as a string and it will look it up the relevant parameters in 
%   the Material Properties Database (MPD).
%   See reference [1] for more information.
%   [1] M. P. Seah, Simple universal curve for the energy‐dependent electron attenuation length (2012)
%
%   IN:
%   -   ke_dat:  	scalar or vector of the input electron kinetic energy (for PES; KE = BE - PHI) [eV]
%   -   Z:          scalar of the atomic mass number (Z) (or average for compounds)
%
%   OUT:
%   -   eal:        scalar or vector of the electron EAL values [Angstrom]

%% Default parameters (Parameters for Silicon)
if nargin < 2; material = "Si";  end
if isempty(material); material = "Si"; end
%% 1 - Extracting the material parameters from the materials database
material = string(material);                % Ensure the input is a string
material_props = get_mpd_props(material);   % Extracting the material properties
% - Extracting the material properties required for the S4 formalism
Z       = material_props.atom_z;
%% 2 - Determination of the IMFP via S3 formalism
eal = calc_eal_S4(ke_dat, Z);   % extract eal in Angstrom
end