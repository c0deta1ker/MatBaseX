function na = mpd_calc_number_density(material)
% na = mpd_calc_number_density(material)
%   This function calculates the number density of a material using the
%   equation na = ρ*Na/Ma, where ρ is the physical density (e.g. in g/cc), 
%   Na is the Avogadro constant (6.02214129x1023 mol−1), and Ma is molar 
%   mass (e.g. in g/mol).
%
%   IN:
%   -   material:           char or string of the material; e.g. "Si", "SiO2", "GaAs", "Al2O3"
%
%   OUT:
%   -   na:                 scalar value of the number density of a material [atoms/cc]

%% Default parameters
if nargin < 1; material = []; end
if isempty(material); material = []; end
%% Validity check on the inputs
material    = string(material);
%% 1 : Calculating the number density of the material
% -- Extracting physics constants
pc          = physics_constants();
Na          = pc.NA;
% -- Extracting material properties
mat_props   = get_mpd_props(material);
rho         = mat_props.density;
Ma          = mat_props.atom_mass;
% -- Calculating the number density of the material
na          = rho*Na/Ma;
end