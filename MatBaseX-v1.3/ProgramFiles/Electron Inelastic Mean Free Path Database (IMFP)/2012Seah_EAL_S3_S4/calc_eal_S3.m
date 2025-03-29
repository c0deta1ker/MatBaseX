function eal = calc_eal_S3(ke_dat, rho, Mm, Z, stoic)
% eal = calc_eal_S3(ke_dat, rho, M, Z, stoic)
%   Function that determines the electron effective attenuation length (EAL) 
%   based on S3 formalism described by M. P. Seah [1]. The input parameters 
%   of the materials are now required and this formalism is compatible
%   for elemental or binary materials. See reference [1] for more information.
%   [1] M. P. Seah, Simple universal curve for the energy‐dependent electron attenuation length (2012)
%
%   IN:
%   -   ke_dat:  	scalar or vector of the input electron kinetic energy (for PES; KE = BE - PHI) [eV]
%   -   rho:        scalar of the density of the material (g/cc)
%   -   Mm:         scalar of the atomic or molecular weight (in amu == g/mol)
%   -   Z:          scalar of the atomic mass number of the element (or average for compound) (Z) 
%   -   stoic:      scalar of the stoiciometry of the material (e.g. for elements, stoic = 1, for molecules of the form G_gH_h, the stoiciometry is g + h)
%
%   OUT:
%   -   eal:        scalar or vector of the electron EAL values [Angstrom]

%% Default parameters (Parameters for Silicon)
if nargin < 5; stoic = 1; end
if nargin < 4; Z = 14; end
if nargin < 3; Mm = 28.085000;   end
if nargin < 2; rho = 2.3300000; end
if isempty(Z);      Z = 14; end
if isempty(Mm);      Mm = 28.085000; end      % amu == g/mol
if isempty(rho); 	rho = 2.3300000; end    % g/cc
if isempty(stoic); 	stoic = 1; end
% -- Defining the constants
pc = physics_constants(); NA  = pc.NA;    % Avogadro constant
%% 1 - Determination of the Effective Attenuation Length (EAL) based on S3 formalism
% Extracting parameters for EAL
a = ((1e21 .* Mm) ./ (rho .* NA .* stoic)).^(1./3); % nm
W = 0;  % for elements
% Calculating the EAL
eal = (5.8 + 0.0041 .*Z.^(1.7) + 0.088 .* ke_dat.^(0.93)) .* a.^(1.82) ./ (Z.^(0.38) .* (1-W));
eal = 10 .* eal;                                      % Convert eal from nm to Angstrom
%% -- Validity check on outputs
if rho == 0; eal(:) = Inf; end     % -- If density is 0, eal is infinite
% -- Ensure that the eal is consistent with input size
if isrow(ke_dat); if size(eal, 2) ~= length(ke_dat); eal = eal'; end
elseif iscolumn(ke_dat); if size(eal, 1) ~= length(ke_dat); eal = eal'; end
end
end