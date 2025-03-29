function eal = calc_eal_S4(ke_dat, Z)
% eal = calc_eal_S4(ke_dat, Z)
%   Function that determines the electron effective attenuation length (EAL) 
%   based on S4 formalism described by M. P. Seah [1]. The EAL here
%   only depends on the value of Z. See reference [1] for more information.
%   [1] M. P. Seah, Simple universal curve for the energy‐dependent electron attenuation length (2012)
%
%   IN:
%   -   ke_dat:  	scalar or vector of the input electron kinetic energy (for PES; KE = BE - PHI) [eV]
%   -   Z:          scalar of the atomic mass number (Z) (or average for compounds)
%
%   OUT:
%   -   eal:        scalar or vector of the electron EAL values [Angstrom]

%% Default parameters (Parameters for Silicon)
if nargin < 2;  Z = 14; end
if isempty(Z); 	Z = 14; end
%% 1 - Determination of the Effective Attenuation Length (EAL) based on S4 formalism
eal = (0.65 + 0.007.*ke_dat.^(0.93)) ./ Z.^(0.38);      % EAL in nm
eal = 10 .* eal;                                        % Convert to Angstrom
%% -- Validity check on outputs
% -- Ensure that the eal is consistent with input size
if isrow(ke_dat); if size(eal, 2) ~= length(ke_dat); eal = eal'; end
elseif iscolumn(ke_dat); if size(eal, 1) ~= length(ke_dat); eal = eal'; end
end
end