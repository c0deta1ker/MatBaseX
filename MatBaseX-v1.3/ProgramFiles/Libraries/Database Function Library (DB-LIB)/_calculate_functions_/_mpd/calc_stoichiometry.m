function stoichiometry = calc_stoichiometry(formula)
% stoichiometry = calc_stoichiometry(formula)
%   This function takes a chemical formula as input and extracts the
%   stoichiometry of the compound.
%
%   IN:
%   -   formula:            char or string of the compound formula; e.g. "Si", "SiO2", "GaAs", "Al2O3"
%
%   OUT:
%   -   stoichiometry:      scalar value of the stoichiometry

%% Default parameters
if nargin < 1; formula = []; end
if isempty(formula); formula = []; end
%% Validity check on the inputs
formula    = string(formula);
%% 1 : Extracting the average Z number of a formula
vformula = parse_chemical_formula(formula);
stoichiometry = zeros(length(vformula));
for i = 1:length(vformula)
    stoichiometry(i)    = vformula(i).quantity;
end
stoichiometry = sum(stoichiometry(:));
end