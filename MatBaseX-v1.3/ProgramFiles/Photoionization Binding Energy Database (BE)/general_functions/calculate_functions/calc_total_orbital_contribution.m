function scale_factors = calc_total_orbital_contribution(core_levels)
% scale_factors = calc_total_orbital_contribution(core_levels)
%   This function calculates the scaling factor for the total area beneath
%   a photoelectron curve in XPS, if only one sub-shell orbital is known.
%   The s-subshell has one orbital, the p-subshell has three orbitals, 
%   the d-subshell has five orbitals, and the f-subshell has seven orbitals.
%   Thus, the following ratios are known: 
%                   s-orbitals : 1
%                   p-orbitals : 1:2 ratio of np1 : np3
%                   d-orbitals : 2:3 ratio of nd3 : nd5
%                   f-orbitals : 3:4 ratio of nf5 : nf7
%
%   IN:
%   -   core_levels:      1xN cell array containing the core levels of interest.
%
%   OUT:
%   -   scale_factors:     1xN cell array with the corresponding scale factors.

%% Validity checks on the input parameters
core_levels   = string(core_levels);
%% 1 : Defining constant scaling Factors for the total orbitals
nCL = length(core_levels);
% - Defining the total contribution to orbital (s, p, d, f)
scale_factor_list   = struct('s1', 0, 'p3', 1/2, 'p1', 2/1, 'd5', 2/3, 'd3', 3/2,'f7', 3/4, 'f5', 4/3);
scale_factors       = cell(nCL,1);
for i = 1:nCL
    entry           = char(core_levels(i));
    if length(entry) == 3; entry = entry(2:3); end
    orbital_type    = entry(1);
    orbital_number  = str2double(entry(2:end)); 
    key = strcat(orbital_type, num2str(orbital_number));
    if isfield(scale_factor_list, key)
        scale_factors{i} = scale_factor_list.(key);
    else
        scale_factors{i} = 0;
    end
    scale_factors{i} = 1 + scale_factors{i};
end
end