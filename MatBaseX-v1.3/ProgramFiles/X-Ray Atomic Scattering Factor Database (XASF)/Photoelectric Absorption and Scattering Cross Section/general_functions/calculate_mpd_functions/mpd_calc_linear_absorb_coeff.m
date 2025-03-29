function mu = mpd_calc_linear_absorb_coeff(hv, material)
% mu = mpd_calc_linear_absorb_coeff(hv, material)
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
%   -   material:       char/string of the material; e.g. "Si", "SiO2", "Al2O3"...
%
%   OUT:
%   -   mu:             scalar or vector of the linear attenuation coefficient [cm]
%
%   SEE REFERENCES:
%       [1] Henke B.L., Gullikson E.M., Davis J.C. X-Ray Interactions: Photoabsorption, Scattering, Transmission, and Reflection at E = 50-30,000 eV, Z = 1-92, Atomic Data and Nuclear Data Tables, 54 (2), 181-342 (1993)
%       [2] https://henke.lbl.gov/optical_constants/

%% Validity checks on the input parameters
material     = string(material);
%% 1 - Extracting the elemental and material properties
mat_props   = get_mpd_props(material);
rho         = mat_props.density;
mu_m        = mpd_calc_mass_absorb_coeff(hv, material);
%% 2 - Calculate the linear attenuation coefficient
mu          = mu_m.*rho;
%% Validity check on the outputs
% -- Ensure that the output values are consistent with the input hv value
if isrow(hv); if size(mu, 2) ~= length(hv); mu = mu'; end
elseif iscolumn(hv); if size(mu, 1) ~= length(hv); mu = mu'; end
end
end