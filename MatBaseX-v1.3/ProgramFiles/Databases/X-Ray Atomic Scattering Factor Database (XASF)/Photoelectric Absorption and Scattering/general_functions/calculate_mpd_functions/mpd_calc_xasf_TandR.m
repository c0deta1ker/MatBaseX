function [T, R] = mpd_calc_xasf_TandR(hv, material, thickness)
% [T, R] = mpd_calc_xasf_TandR(hv, material, thickness)
%   This function calculates the X-ray transmission (T) and reflectance (R)
%   of a solid film with a defined thickness in nanometers. The
%   relationship is given by R = 1 - T.
%
%   IN:
%   -   hv:             scalar or vector of the incident photon energies [eV]
%   -   material:       char/string of the material; e.g. "Si", "SiO2", "Al2O3"...
%   -   thickness:      scalar of the film thickness [nm]
%
%   OUT:
%   -   T:              scalar or vector of the x-ray transmission
%   -   R:              scalar or vector of the x-ray reflectance
%
%   SEE REFERENCES:
%       [1] Henke B.L., Gullikson E.M., Davis J.C. X-Ray Interactions: Photoabsorption, Scattering, Transmission, and Reflection at E = 50-30,000 eV, Z = 1-92, Atomic Data and Nuclear Data Tables, 54 (2), 181-342 (1993)
%       [2] https://henke.lbl.gov/optical_constants/
%       [3] https://gisaxs.com/index.php/Refractive_index
%       [4] https://henke.lbl.gov/optical_constants/filter2.html

%% Validity checks on the input parameters
material     = string(material);
%% 1 - Defining variables
mat_props   = get_mpd_props(material);
mu_m        = mpd_calc_linear_absorb_coeff(hv, material);
T           = exp(-mu_m.*mat_props.density.*(thickness*1e-7));
R           = 1 - T;
%% Validity check on the outputs
% -- Ensure that the output values are consistent with the input hv value
if isrow(hv); if size(T, 2) ~= length(hv); T = T'; end
elseif iscolumn(hv); if size(T, 1) ~= length(hv); T = T'; end
end
if isrow(hv); if size(R, 2) ~= length(hv); R = R'; end
elseif iscolumn(hv); if size(R, 1) ~= length(hv); R = R'; end
end
end