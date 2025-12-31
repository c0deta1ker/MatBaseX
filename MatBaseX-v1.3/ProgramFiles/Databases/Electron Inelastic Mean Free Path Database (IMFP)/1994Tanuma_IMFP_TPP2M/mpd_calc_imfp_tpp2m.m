function imfp = mpd_calc_imfp_tpp2m(ke_dat, material)
% imfp = mpd_calc_imfp_tpp2m(ke_dat, material)
%   Function that determines the electron inelastic mean free path (IMFP) 
%   based on the TPP-2M energy compensation factor, which is a more
%   accurate method than the standard universal curve determination. The
%   input parameters of the materials however are now required. In this function, 
%   you can define the material as a string and it will look it up the relevant 
%   parameters in the Material Properties Database (MPD). See
%   references [1-4] for more information.
%   [1] S. Tanuma, Calculations of Electron Inelastic Mean Free Paths. V. Data for 14 Organic Compounds over the 50-2000 eV Range (1994)
%   [2] S. Tanuma, Calculation of electron inelastic mean free paths (IMFPs) VII. Reliability of the TPP-2M IMFP predictive equation (2003)
%   [3] S. Tanuma, Calculations of electron inelasticmean free paths. IX. Data for 41 elemental solids over the 50 eV to 30 keV range (2011)
%   [4] M. P. Seah, An accurate and simple universal curve for the energy-dependent electron inelastic mean free path (2011)
%
%   IN:
%   -   ke_dat:  	scalar or vector of the input electron kinetic energy (for PES; KE = BE - PHI) [eV]
%   -   material:  	string of the material whose imfp is to be determined; e.g. "Si", "SiO2", "Al2O3"...
%
%   OUT:
%   -   imfp:       scalar or vector of the electron IMFP values [Angstrom]

%% Default parameters (Parameters for Silicon)
if nargin < 2; material = "Si";  end
if isempty(material); material = "Si"; end
%% 1 - Extracting the material parameters from the materials database
material = string(material);                % Ensure the input is a string
material_props = get_mpd_props(material);   % Extracting the material properties
% - Extracting the material properties required for the TPP-2M formalism
rho     = material_props.density;
Nv      = material_props.elec_valency;
M       = material_props.atom_mass;
Egap    = material_props.elec_band_gap;
%% 2 - Determination of the IMFP via TPP-2M formalism
imfp = calc_imfp_tpp2m(ke_dat, rho, Nv, M, Egap);
end