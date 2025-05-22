function opt_hv = mpd_calc_xasf_opt_hv(material, thickness)
% opt_hv = mpd_calc_xasf_opt_hv(material, thickness)
%   This function calculates the optimal photon energy to probe a material
%   of a given thickness (between 10 - 100,000 eV).
%   The attenuation length is defined as the depth at which the intensity 
%   of X-rays inside the material decreases to 1/e (approximately 37%) of 
%   its original value; the photon energy that is calculated is the optimal 
%   value to give this condition.
%
%   IN:
%   -   material:       char/string of the material; e.g. "Si", "SiO2", "Al2O3"...
%   -   thickness:      scalar or vector of the material thickness [μm]
%
%   OUT:
%   -   opt_hv:         scalar or vector of the incident photon energies [eV]
%
%   SEE REFERENCES:
%       [1] M. Du, Z. Di, D. Gürsoy, R. P. Xian, Y. Kozorovitskiy, and C. Jacobsen, ‘Upscaling X-ray nanoimaging to macroscopic specimens’, J Appl Crystallogr, vol. 54, no. 2, pp. 386–401, Apr. 2021, doi: 10.1107/S1600576721000194.
%       [2] Henke B.L., Gullikson E.M., Davis J.C. X-Ray Interactions: Photoabsorption, Scattering, Transmission, and Reflection at E = 50-30,000 eV, Z = 1-92, Atomic Data and Nuclear Data Tables, 54 (2), 181-342 (1993)
%       [3] https://henke.lbl.gov/optical_constants/

%% Validity checks on the input parameters
material      = string(material);
%% 1 - Calculating the Attenuation Length
% -- photon energy domain (eV)
Eph                 = logspace(1, 5, 1e5);
% -- attenuation length (μm)
mu_cm               = mpd_calc_linear_absorb_coeff(Eph, material);
att_length_um       = (1 ./ (mu_cm*100)).*1e6;
%% 2 - Determining the Optimal Photon Energy
opt_hv              = interp1(att_length_um, Eph, thickness, 'linear', 'extrap');
opt_hv              = ceil(opt_hv);

end