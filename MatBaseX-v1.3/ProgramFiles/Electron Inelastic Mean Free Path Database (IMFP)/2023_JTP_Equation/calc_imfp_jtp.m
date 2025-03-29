function imfp = calc_imfp_jtp(ke_dat, rho, Nv, Mm, Egap)
% imfp = calc_imfp_jtp(ke_dat, rho, Nv, M, Egap)
%   Function that determines the electron inelastic mean free path (IMFP) 
%   based on the JTP method, which is a more accurate method than the 
%   standard universal curve and TPP-2M determination. The input parameters of 
%   the materials are now required. See references [1] for more information.
%   [1] Jablonski A, Tanuma S, Powell CJ. Surf Interface Anal. 2023; 55(8): 609-637. doi:10.1002/sia.7217
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
if isempty(Mm);      Mm = 28.085000; end    % amu == g/mol
if isempty(Nv);     Nv = 4; end             % integer
if isempty(rho); 	rho = 2.3300000; end    % g/cc
%% 1 - Determination of the IMFP TPP-2M
% Extracting parameters for IMFP
Ep          = 28.816 .* sqrt(Nv .* rho ./ Mm); % eV
alpha       = (1 + ke_dat ./ 1021999.8) ./ (1 + ke_dat ./ 510998.9).^2;     % relativistic correction
beta        = 0.0539 + 17 ./ (Ep.^2 + Egap.^2).^(0.639) - 0.252 .* rho.^(-0.463);    % (eV−1 nm−1)
gamma       = 0.115 .* rho.^(-0.253);     % eV−1
U       	= (Ep ./ 28.816).^2; 
D           = 97.5 + 223 .* U;          % eV nm−1
C           = 9.76 + 2.09 .* U;         % nm−1
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