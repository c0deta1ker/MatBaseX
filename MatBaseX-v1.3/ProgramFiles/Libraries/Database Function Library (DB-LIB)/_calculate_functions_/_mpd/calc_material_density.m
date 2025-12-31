function rho = calc_material_density(na, Mm)
% rho = calc_material_density(rho, Mm)
%   This function calculates the material density in g/cc when the atomic
%   density is known.
%   IN:
%   -   na:                 scalar value of the number density of a material [atoms/cc]
%   -   Mm:                 scalar value of the molar mass [g/mol]
%
%   OUT:
%   -   rho:                scalar value of the mass density [g/cc]

%% 1 : Calculating the material density
% -- Extracting physics constants
pc  = physics_constants();
Na  = pc.NA;
% -- Calculating the number density
rho = na.*Mm./Na;
end