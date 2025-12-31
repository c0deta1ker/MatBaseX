function Mm = calc_molar_mass(formula)
% Mm = calc_molar_mass(formula)
%   This function takes a chemical formula as input and extracts the
%   total molar mass of the compound.
%
%   IN:
%   -   formula:            char or string of the compound formula; e.g. "Si", "SiO2", "GaAs", "Al2O3"
%
%   OUT:
%   -   Mm:                 scalar value of the molar mass [g/mol]

%% Default parameters
if nargin < 1; formula = []; end
if isempty(formula); formula = []; end
%% Validity check on the inputs
formula    = string(formula);
%% 1 : Extracting the average Z number of a formula
vformula = parse_chemical_formula(formula);
Mm = zeros(length(vformula));
for i = 1:length(vformula)
    element_props   = get_mpd_props(vformula(i).element);
    Mm(i)           = vformula(i).quantity .* element_props.atom_mass;
end
Mm = sum(Mm(:));
end