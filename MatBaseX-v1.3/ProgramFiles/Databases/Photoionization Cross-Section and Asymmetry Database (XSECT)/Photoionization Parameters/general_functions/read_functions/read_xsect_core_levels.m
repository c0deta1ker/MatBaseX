function core_levels = read_xsect_core_levels(element)
% core_levels = read_xsect_core_levels(element)
%   This function returns a cell array containing electron core-levels
%   that have both a finite binding energy AND photoionization
%   cross-section value from the Cant2022 database.
%
%   IN:
%   -   element:    	string of the element; e.g. "H", "He", "Si", "In"...
%
%   OUT:
%   -   core_levels:    1xN cell array of the core-levels

%% Validity checks on the input parameters
element   = string(element);
%% 1 : Defining Core-Levels
[binding_energy, core_levels] = calc_be(element);
formalism   = "C2022";
xsect_sigma = NaN(size(core_levels));
for i = 1:length(core_levels)
    hv                  = binding_energy(i) + 1000;
    xsect_sigma(i)      = calc_xsect_sigma(hv, element, core_levels(i), formalism, 1);
end
core_levels(isnan(xsect_sigma)) = [];
end