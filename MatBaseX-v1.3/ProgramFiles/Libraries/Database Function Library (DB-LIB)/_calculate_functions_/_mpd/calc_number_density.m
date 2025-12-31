function na = calc_number_density(rho, Mm)
% na = calc_number_density(rho, Mm)
%   This function calculates the number density of a material using the
%   equation na = ρ*Na/Ma, where ρ is the physical density (e.g. in g/cc), 
%   Na is the Avogadro constant (6.02214129x1023 mol−1), and Ma is molar 
%   mass (e.g. in g/mol).
%
%   IN:
%   -   rho:                scalar value of the mass density [g/cc]
%   -   Mm:                 scalar value of the molar mass [g/mol]
%
%   OUT:
%   -   na:                 scalar value of the number density of a material [atoms/cc]

%% 1 : Calculating the number density
% -- Extracting physics constants
pc  = physics_constants();
Na  = pc.NA;
% -- Calculating the number density
na  = rho*Na/Mm;
end