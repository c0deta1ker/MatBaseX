function color_list = read_be_core_levels_color(core_levels)
% color_list = read_be_core_levels_color(core_levels)
%   This function returns a cell array of RGB colors that consistently color 
%   the core levels throughout all plot functions.
%
%   IN:
%   -   core_levels:      1xN cell array containing the core levels of interest.
%
%   OUT:
%   -   color_list:       1xN cell array with the corresponding plot colors for the core levels.

%% Validity checks on the input parameters
core_levels   = string(core_levels);
%% 1 : Defining Consistent Core-Level Colors
nCL = length(core_levels);
% - Defining the color scheme for each type (s, p, d, f)
baseColors  = struct('s', [0, 0, 0], 'p', [1, 0, 0], 'd', [0, 0, 1], 'f', [0, 1, 0]);
color_list  = cell(nCL,1);
for i = 1:nCL
    entry   = char(core_levels(i));
    prefix  = str2double(entry(1));
    type    = entry(2); 
    if ~isfield(baseColors, type); baseColor = [0, 0, 0];
    else; baseColor = baseColors.(type);
    end
    shadeFactor = (prefix - 1) / 6;                                         % Prefix ranges from 1 to 7, so factor ranges from 0 to 0.5
    color = baseColor * (1 - shadeFactor) + 0.75*[1, 1, 1] * shadeFactor;   % Interpolate between base color and white
    color(isnan(color)) = 0;
    color_list{i} = color;
end
end