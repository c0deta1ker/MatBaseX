function imfp = calc_imfp_S2(ke_dat, Z)
% imfp = calc_imfp_S2(ke_dat, Z)
%   Function that determines the electron inelastic mean free path (IMFP) 
%   based on the S2 equation described by M. P. Seah [1]. The IMFP here
%   only depends on the value of Z. See reference [1] for more information.
%   [1] M. P. Seah, An accurate and simple universal curve for the energy-dependent electron inelastic mean free path (2011)
%
%   IN:
%   -   ke_dat:  	scalar or vector of the input electron kinetic energy (for PES; KE = BE - PHI) [eV]
%   -   Z:          scalar of the atomic mass number (Z) (or average for compounds)
%
%   OUT:
%   -   imfp:       scalar or vector of the electron IMFP values [Angstrom]

%% Default parameters (Parameters for Silicon)
if nargin < 2;  Z = 14; end
if isempty(Z); 	Z = 14; end
%% - 1 - Determination of the IMFP using S2 formalism (M P Seah)
imfp = (0.73 +  0.0095.* ke_dat.^(0.872)) ./ Z.^(0.3);  % IMFP in nm
imfp = 10 .* imfp;                                      % Convert IMFP from nm to Angstrom
%% -- Validity check on outputs
% -- Ensure that the IMFP is consistent with input size
if isrow(ke_dat); if size(imfp, 2) ~= length(ke_dat); imfp = imfp'; end
elseif iscolumn(ke_dat); if size(imfp, 1) ~= length(ke_dat); imfp = imfp'; end
end
end