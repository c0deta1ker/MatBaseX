function [beta, delta, alphaC, n, ne] = mpd_calc_xasf_params(hv, material)
% [beta, delta, alphaC, n, ne] = mpd_calc_xasf_params(hv, material)
%   This function calculates several parameters using X-Ray Atomic
%   Scattering Factors;
%
%   #1 - The absorptive aspect of the wave-matter interaction, β, is used 
%   in many calculations of x-ray interactions. β is calculated by:
%               β = na * re * lambda.^2. * f_2 / (2*pi)
%   where na is the number density of a material, r_0 is the classical 
%   electron radius, lambda is the photon wavelength and f_2, the imaginary 
%   part of atomic scattering factor (absorption).
%
%   #2 - The dispersive aspect of the wave-matter interaction, δ,  is used 
%   in many calculations of x-ray interactions. δ is calculated by:
%               δ = na * re * lambda.^2. * f_1 / (2*pi)
%   where na is the number density of a material, re is the classical 
%   electron radius, lambda is the photon wavelength and f_1, the real part 
%   of atomic scattering factor (coherent scattering).
%
%   #3 - The critical angle for a material,is defined as the incident angle 
%   below which one gets total external reflection of the x-rays. Below the 
%   critical angle, the beam is fully reflected from the material. The 
%   critical angle is calculated as:
%                           θ = sqrt(δ), 
%   where δ is defined as in #2.
%
%   #4 - The index of refraction for a material with na atoms per unit volume
%   is calculated by,
%                       n = 1 - δ - 1i*β,
%   where β and δ is defined as in #1 and #2 respectively.
%
%   #5 - The corresponding electron density,
%               ne = 1 - 2*pi*δ / (re*lambda.^2), 
%   where re is the classical electron radius, lambda is the photon
%   wavelength and δ is defined as in #1.
%
%   IN:
%   -   hv:             scalar or vector of the incident photon energies [eV]
%   -   material:  	    string of the material whose values are to be determined; e.g. "Si", "SiO2", "InAs", "Al2O3"...
%
%   OUT:
%   -   beta:           scalar or vector of the beta parameter
%   -   delta:          scalar or vector of the delta parameter
%   -   alphaC:         scalar or vector of the critical angle [degree]
%   -   n:              scalar or vector of the complex index of refraction
%   -   ne:             scalar or vector of the electron density [e/cc]
%
%   SEE REFERENCES:
%       [1] Henke B.L., Gullikson E.M., Davis J.C. X-Ray Interactions: Photoabsorption, Scattering, Transmission, and Reflection at E = 50-30,000 eV, Z = 1-92, Atomic Data and Nuclear Data Tables, 54 (2), 181-342 (1993)
%       [2] https://henke.lbl.gov/optical_constants/
%       [3] https://gisaxs.com/index.php/Refractive_index
%       [4] https://henke.lbl.gov/optical_constants/filter2.html

%% 1 - Defining variables
pc          = physics_constants();
lambda      = convert_eV_to_nm(hv);
na          = mpd_calc_number_density(material);
%% 2 - Calculate all parameters
[f1, f2]     = calc_xasf(hv, material);
beta        = ((na/1e-6)*(pc.re)*(lambda*1e-9).^2 .* f2) ./ (2*pi);
delta       = ((na/1e-6)*(pc.re)*(lambda*1e-9).^2 .* f1) ./ (2*pi);
alphaC      = rad2deg(sqrt(delta));
n           = 1 - delta - beta*1i;
ne          = 2*pi.* delta ./ ((100.*pc.re).*(lambda.*1e-7).^2);
end