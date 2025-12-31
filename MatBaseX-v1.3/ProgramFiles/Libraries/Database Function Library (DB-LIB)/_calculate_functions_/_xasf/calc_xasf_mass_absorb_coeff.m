function mu_m = calc_xasf_mass_absorb_coeff(hv, formula, Mm)
% mu_m = calc_xasf_mass_absorb_coeff(hv, material)
%   This function calculates the mass absorption coefficient, (μ/ρ), which
%   can be calculated from the atomic photoabsorption cross sections and given 
%   by the equation: 
%               (μ/ρ) =  (Na / Mm) * SUM(xq*mu_a)
%   where Na is the Avogadro constant, Mm is the molar mass in g/mol and the 
%   quantity SUM(xq*mu_a) is the number of q-type atoms per molecule and
%   mu_a is the atomic photoabsorption cross section of the q-type atom.
%   The mass absorption coefficient (μ/ρ) is a measure of how much a material 
%   absorbs photons per unit mass. It combines the linear absorption coefficient 
%   (μ) with the material's density (ρ), making it independent of the 
%   material's physical dimensions and focused solely on its absorbing properties.
%
%   IN:
%   -   hv:             scalar or vector of the incident photon energies [eV]
%   -   formula:        char or string of the compound formula; e.g. "Si", "SiO2", "GaAs", "Al2O3"
%   -   Mm:             scalar value of the molar mass [g/mol]
%
%   OUT:
%   -   mu_m:           scalar or vector of the mass absorption coefficient (μ/ρ) [cm^2]
%
%   SEE REFERENCES:
%       [1] Henke B.L., Gullikson E.M., Davis J.C. X-Ray Interactions: Photoabsorption, Scattering, Transmission, and Reflection at E = 50-30,000 eV, Z = 1-92, Atomic Data and Nuclear Data Tables, 54 (2), 181-342 (1993)
%       [2] https://henke.lbl.gov/optical_constants/
%       [3] https://gisaxs.com/index.php/Refractive_index
%       [4] https://henke.lbl.gov/optical_constants/filter2.html

%% Validity checks on the input parameters
formula     = string(formula);
%% 1 - Extracting the elemental and material properties
pc          = physics_constants();
vformula    = parse_chemical_formula(formula);
mu_T        = zeros(size(hv));
for i = 1:length(vformula)
    mu_a         = calc_xasf_atom_absorb_coeff(hv, vformula(i).element);
    % xq           = vformula(i).ratio;
    xq           = vformula(i).quantity;
    mu_T         = mu_T + xq.*mu_a;
end
%% 2 - Calculate the mass absorption coefficient
mu_m =  (pc.NA / Mm) .* mu_T;
%% Validity check on the outputs
% -- Ensure that the output values are consistent with the input hv value
if isrow(hv); if size(mu_m, 2) ~= length(hv); mu_m = mu_m'; end
elseif iscolumn(hv); if size(mu_m, 1) ~= length(hv); mu_m = mu_m'; end
end
end