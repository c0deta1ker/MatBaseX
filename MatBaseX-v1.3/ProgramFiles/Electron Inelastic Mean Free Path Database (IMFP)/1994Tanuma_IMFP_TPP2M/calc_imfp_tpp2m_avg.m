function imfp = calc_imfp_tpp2m_avg(ke_dat)
% imfp = calc_imfp_tpp2m_avg(ke_dat)
%   Function that determines the electron inelastic mean free path (IMFP) 
%   that is based on the average trend line of photoelectron kinetic
%   energies for multiple material systems. This method is considered
%   better than the universal method, but less precise than the TPP-2M
%   calculations, where the specific material parameters are used. No 
%   material parameters are used in this calculation. See references [1-4] 
%   for more information.
%   [1] S. Tanuma, Calculations of Electron Inelastic Mean Free Paths. V. Data for 14 Organic Compounds over the 50-2000 eV Range (1994)
%   [2] S. Tanuma, Calculation of electron inelastic mean free paths (IMFPs) VII. Reliability of the TPP-2M IMFP predictive equation (2003)
%   [3] S. Tanuma, Calculations of electron inelasticmean free paths. IX. Data for 41 elemental solids over the 50 eV to 30 keV range (2011)
%   [4] M. P. Seah, An accurate and simple universal curve for the energy-dependent electron inelastic mean free path (2011)
%
%   IN:
%   -   ke_dat:  	scalar or vector of the input electron kinetic energy (for PES; KE = BE - PHI) [eV]
%
%   OUT:
%   -   imfp:       scalar or vector of the electron IMFP values [Angstrom]

%% 1 - Determination of the IMFP
imfp = 0.01997 .* ke_dat .^ (0.6659);       % IMFP in nano-metres
imfp = 10 .* imfp;  % Convert IMFP from nm to Angstrom
%% -- Validity check on outputs
% -- Ensure that the IMFP is consistent with input size
if isrow(ke_dat); if size(imfp, 2) ~= length(ke_dat); imfp = imfp'; end
elseif iscolumn(ke_dat); if size(imfp, 1) ~= length(ke_dat); imfp = imfp'; end
end
end