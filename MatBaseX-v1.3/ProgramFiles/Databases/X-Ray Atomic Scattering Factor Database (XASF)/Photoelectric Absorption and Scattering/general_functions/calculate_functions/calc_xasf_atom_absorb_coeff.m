function mu_a = calc_xasf_atom_absorb_coeff(hv, element)
% mu_a = calc_xasf_atom_absorb_coeff(hv, element)
%   This function calculates the atomic photoabsorption cross section, mu_a, 
%   which can be calculated from the values of f_2 using the relation: 
%                       mu_a = 2*r_0*lambda*f_2, 
%   where r_0 is the classical electron radius, lambda is the photon wavelength 
%   and f_2, the imaginary part of atomic scattering factor (absorption).
%   The atomic photoabsorption cross section quantifies the likelihood that 
%   a photon will be absorbed by an atom. It's a measure of the probability 
%   that an incident photon will interact with an atom, leading to the 
%   absorption of the photon's energy.
%
%   IN:
%   -   hv:             scalar or vector of the incident photon energies [eV]
%   -   element:    	string of the element; e.g. "H", "He", "Si", "In"...
%
%   OUT:
%   -   mu_a:           scalar or vector of the atomic photoabsorption cross-section [cm^2]
%
%   SEE REFERENCES:
%       [1] Henke B.L., Gullikson E.M., Davis J.C. X-Ray Interactions: Photoabsorption, Scattering, Transmission, and Reflection at E = 50-30,000 eV, Z = 1-92, Atomic Data and Nuclear Data Tables, 54 (2), 181-342 (1993)
%       [2] https://henke.lbl.gov/optical_constants/

%% Validity checks on the input parameters
element     = string(element);
%% 1 - Calculate atomic photoabsorption cross-section
pc          = physics_constants();
[~, f2]     = calc_xasf(hv, element);
lambda      = convert_eV_to_nm(hv);
mu_a        = 2.*(100.*pc.re).*(lambda.*1e-7).*f2;
%% Validity check on the outputs
% -- Ensure that the output values are consistent with the input hv value
if isrow(hv); if size(mu_a, 2) ~= length(hv); mu_a = mu_a'; end
elseif iscolumn(hv); if size(mu_a, 1) ~= length(hv); mu_a = mu_a'; end
end
end