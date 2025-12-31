function ratio_of_interest = calc_elemental_ratio(formula, element_of_interest)
% ratio_of_interest = calc_elemental_ratio(formula, element_of_interest)
%   This function takes a compound as input and extracts the elemental 
%   ratios of a particular element. For example, Al2O3 has an elemental ratio 
%   of 2/5 for Al and 3/5 for O. Very useful for elemental analysis work.
%
%   IN:
%   -   formula:                char or string of the compound formula; e.g. "Si", "SiO2", "GaAs", "Al2O3"
%   -   element_of_interest:    char/string of the element of interest in the formula
%
%   OUT:
%   -   ratio_of_interest:      scalar value of the elemental ratio of the element of interest in the formula
%
% Examples:     Al = calc_mat_elemental_ratio("Al2O3", "Al"); O = calc_mat_elemental_ratio("Al2O3", "O");
%               Si = calc_mat_elemental_ratio("SiO2", "Si");  O = calc_mat_elemental_ratio("SiO2", "O");
%               In = calc_mat_elemental_ratio("InAs", "In");  As = calc_mat_elemental_ratio("InAs", "As");

%% Default parameters
if nargin < 2; element_of_interest = []; end
if nargin < 1; formula = []; end
if isempty(formula); formula = []; end
if isempty(element_of_interest); element_of_interest = []; end
%% Validity check on the inputs
formula             = string(formula);
element_of_interest = string(element_of_interest);
ratio_of_interest   = [];
%% 1 : Extracting the elemental ratio of interest from a formula
% -- If the formula and element are the same, return 1
if strcmpi(formula, element_of_interest) == 1; ratio_of_interest = 1;
% -- Otherwise, extract all elements in the formula
else
    vformula = parse_chemical_formula(formula);
    % --- Check that the element of interest is actually in the formula
    proceed = 0;
    for i = 1:length(vformula); if strcmpi(string(vformula(i).element), string(element_of_interest)); proceed = 1; end; end
    if proceed == 0; error('The element of interest is not in the formula defined.');
    else
        % ---- Find the total sum
        total = 0; for i = 1:length(vformula); total = vformula(i).quantity + total; end
        % ---- Output the ratio of the selected element
        for i = 1:length(vformula)
            if strcmpi(string(vformula(i).element), string(element_of_interest))
                ratio_of_interest = vformula(i).quantity ./ total; 
                break;
            end
        end
    end
end
end