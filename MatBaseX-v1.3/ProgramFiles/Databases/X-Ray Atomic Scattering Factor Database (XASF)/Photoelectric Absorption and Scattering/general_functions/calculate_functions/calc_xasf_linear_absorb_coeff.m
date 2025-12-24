function mu = calc_xasf_linear_absorb_coeff(hv, formula, Mm, rho)
% mu = calc_xasf_linear_absorb_coeff(hv, formula, Mm, rho)
%   This function calculates the linear attenuation coefficient, mu, which 
%   is determined by the equation: 
%                           μ =  (μ/ρ) * ρ ,
%   where (μ/ρ) is the mass absorption coefficient and ρ is the mass
%   density of the material (g/cc). The linear absorption coefficient (μ) 
%   is a measure of how much a material can attenuate or absorb X-rays as 
%   they pass through it.
%
%   IN:
%   -   hv:             scalar or vector of the incident photon energies [eV]
%   -   formula:        char or string of the compound formula; e.g. "Si", "SiO2", "GaAs", "Al2O3"
%   -   Mm:             scalar value of the molar mass [g/mol]
%   -   rho:            scalar value of the mass density of the material [g/cc]
%
%   OUT:
%   -   mu:             scalar or vector of the linear attenuation coefficient [cm]
%
%   SEE REFERENCES:
%       [1] Henke B.L., Gullikson E.M., Davis J.C. X-Ray Interactions: Photoabsorption, Scattering, Transmission, and Reflection at E = 50-30,000 eV, Z = 1-92, Atomic Data and Nuclear Data Tables, 54 (2), 181-342 (1993)
%       [2] https://henke.lbl.gov/optical_constants/

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
mu =  rho*(pc.NA / Mm) .* mu_T;
%% Validity check on the outputs
% -- Ensure that the output values are consistent with the input hv value
if isrow(hv); if size(mu, 2) ~= length(hv); mu = mu'; end
elseif iscolumn(hv); if size(mu, 1) ~= length(hv); mu = mu'; end
end
end