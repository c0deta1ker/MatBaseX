function imfp = calc_imfp_tpp2m(ke_dat, rho, Nv, Mm, Egap)
% imfp = calc_imfp_tpp2m(ke_dat, rho, Nv, Mm, Egap)
%   Function that determines the electron inelastic mean free path (IMFP) 
%   based on the TPP-2M energy compensation factor, which is a more
%   accurate method than the standard universal curve determination. The
%   input parameters of the materials are now required. The TPP-2M equation
%   is also relativistically corrected here. See references [1-4] for more information.
%   [1] S. Tanuma, Calculations of Electron Inelastic Mean Free Paths. V. Data for 14 Organic Compounds over the 50-2000 eV Range (1994)
%   [2] S. Tanuma, Calculation of electron inelastic mean free paths (IMFPs) VII. Reliability of the TPP-2M IMFP predictive equation (2003)
%   [3] S. Tanuma, Calculations of electron inelasticmean free paths. IX. Data for 41 elemental solids over the 50 eV to 30 keV range (2011)
%   [4] M. P. Seah, An accurate and simple universal curve for the energy-dependent electron inelastic mean free path (2011)
%
%   IN:
%   -   ke_dat:  	scalar or vector of the input electron kinetic energy (for PES; KE = BE - PHI) [eV]
%   -   rho:        scalar of the density of the material (g/cc)
%   -   Nv:         scalar of the number of valence electrons per atom (for an element)
%   -   Mm:         scalar of the atomic or molecular weight (in amu == g/mol)
%   -   Egap:       scalar of the band gap energy (eV)
%
%   OUT:
%   -   imfp:       scalar or vector of the electron IMFP values [Angstrom]

%% Default parameters (Parameters for Silicon)
if nargin < 5; Egap = 1.12000; end
if nargin < 4; Mm = 28.085000;   end
if nargin < 3; Nv = 4;  end
if nargin < 2; rho = 2.3300000; end
if isempty(Egap);   Egap = 1.12000; end     % eV
if isempty(Mm);      Mm = 28.085000; end      % amu == g/mol
if isempty(Nv);     Nv = 4; end             % integer
if isempty(rho); 	rho = 2.3300000; end    % g/cc
%% 1 - Determination of the IMFP TPP-2M
% Extracting parameters for IMFP
Ep          = 28.816 .* sqrt(Nv .* rho ./ Mm); % eV
alpha       = (1 + ke_dat ./ 1021999.8) ./ (1 + ke_dat ./ 510998.9).^2;     % relativistic correction
beta        = -1.0 + 9.44 ./ sqrt(Ep.^2 + Egap.^2) + 0.69 .* rho.^(0.1);    % (eV−1 nm−1)
gamma       = 0.191 .* rho.^(-0.5);     % eV−1
U       	= (Ep ./ 28.816).^2; 
D           = 534 - 208 .* U;          % eV nm−1
C           = 19.7 - 9.1 .* U;         % nm−1
% Calculating the IMFP
imfp = alpha .* ke_dat ./ (Ep.^2 .* (beta .* log(alpha .* gamma .* ke_dat) - (C./ke_dat) + (D./(ke_dat.^2)))); % IMFP in nanometres
imfp = 10 .* imfp;  % Convert IMFP from nm to Angstrom
%% -- Validity check on outputs
if rho == 0; imfp(:) = Inf; end     % -- If density is 0, IMFP is infinite
% -- Ensure that the IMFP is consistent with input size
if isrow(ke_dat); if size(imfp, 2) ~= length(ke_dat); imfp = imfp'; end
elseif iscolumn(ke_dat); if size(imfp, 1) ~= length(ke_dat); imfp = imfp'; end
end
end