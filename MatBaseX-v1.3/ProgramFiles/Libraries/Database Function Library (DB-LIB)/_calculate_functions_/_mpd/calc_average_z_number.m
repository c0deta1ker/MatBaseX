function avg_Z = calc_average_z_number(formula)
% avg_Z = calc_average_z_number(formula)
%   This function takes a chemical formula as input and extracts the
%   average Z number of the compound.
%
%   IN:
%   -   formula:            char or string of the compound formula; e.g. "Si", "SiO2", "GaAs", "Al2O3"
%
%   OUT:
%   -   avg_Z:              scalar value of the average Z number

%% Default parameters
if nargin < 1; formula = []; end
if isempty(formula); formula = []; end
%% Validity check on the inputs
formula    = string(formula);
%% 1 : Extracting the average Z number of a formula
vformula = parse_chemical_formula(formula);
Z = zeros(length(vformula));
for i = 1:length(vformula)
    element_props   = get_mpd_props(vformula(i).element);
    Z(i)            = vformula(i).quantity .* element_props.atom_z;
end
avg_Z = mean(Z(:));
end