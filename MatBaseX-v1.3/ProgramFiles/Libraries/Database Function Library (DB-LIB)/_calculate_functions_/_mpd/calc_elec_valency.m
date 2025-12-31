function elec_valency = calc_elec_valency(formula)
% elec_valency = calc_elec_valency(formula)
%   This function takes a chemical formula as input and extracts the
%   electron valency of the material. This is calculated as the total sum
%   of the electron valency for all constituent elements in the compound.
%
%   IN:
%   -   formula:            char or string of the compound formula; e.g. "Si", "SiO2", "GaAs", "Al2O3"
%
%   OUT:
%   -   elec_valency:       scalar value of the electron valency

%% Default parameters
if nargin < 1; formula = []; end
if isempty(formula); formula = []; end
%% Validity check on the inputs
formula     = string(formula);
%% 1 : Extracting the average Z number of a material
vformula     = parse_chemical_formula(formula);
elec_valency = zeros(length(vformula));
for i = 1:length(vformula)
    element_props       = get_mpd_props(vformula(i).element);
    elec_valency(i)     = vformula(i).quantity .* element_props.elec_valency;
end
elec_valency = sum(elec_valency(:));
end