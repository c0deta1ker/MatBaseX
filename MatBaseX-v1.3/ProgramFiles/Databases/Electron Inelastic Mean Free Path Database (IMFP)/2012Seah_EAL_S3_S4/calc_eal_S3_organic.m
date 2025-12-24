function eal = calc_eal_S3_organic(ke_dat)
% eal = calc_eal_S3_organic(ke_dat)
%   Function that determines the electron effective attenuation length (EAL) 
%   based on S3 formalism described by M. P. Seah [1] for organic materials.
%   This approximation is good for all organic matter.
%   See reference [1] for more information.
%   [1] M. P. Seah, Simple universal curve for the energy‐dependent electron attenuation length (2012)
%
%   IN:
%   -   ke_dat:  	scalar or vector of the input electron kinetic energy (for PES; KE = BE - PHI) [eV]
%
%   OUT:
%   -   eal:        scalar or vector of the electron EAL values [Angstrom]

%% 1 - Determination of the Effective Attenuation Length (ELA) based on S3 formalism
eal = 0.00837 .* ke_dat.^(0.842);   % IMFP in nm
eal = 10 .* eal;                    % Convert IMFP to Angstrom
%% -- Validity check on outputs
% -- Ensure that the eal is consistent with input size
if isrow(ke_dat); if size(eal, 2) ~= length(ke_dat); eal = eal'; end
elseif iscolumn(ke_dat); if size(eal, 1) ~= length(ke_dat); eal = eal'; end
end
end