function color_list = read_xae_edges_color(edge_names)
% color_list = read_xae_edges_color(edge_names)
%   This function returns a cell array of RGB colors that consistently color 
%   the edges throughout all plot functions.
%
%   IN:
%   -   edge_names:      1xN cell array containing the edges of interest.
%
%   OUT:
%   -   color_list:       1xN cell array with the corresponding plot colors for the core levels.

%% Validity checks on the input parameters
edge_names   = string(edge_names);
%% 1 : Defining Consistent Core-Level Colors
nCL = length(edge_names);
% - Defining the color scheme for each type (s, p, d, f)
baseColors  = struct('K', [0, 0, 0], 'L', [1, 0, 0], 'M', [0, 0, 1], 'N', [0, 1, 0], 'O', [1, 0.5, 0.2], 'P', [0.5, 0.2, 1], 'Q', [0.5, 1, 0.2]);
color_list  = cell(nCL,1);
for i = 1:nCL
    entry   = char(edge_names(i));
    prefix  = str2double(entry(2));
    type    = entry(1); 
    if ~isfield(baseColors, type); baseColor = [0, 0, 0];
    else; baseColor = baseColors.(type);
    end
    shadeFactor = (prefix - 1) / 6;                                         % Prefix ranges from 1 to 7, so factor ranges from 0 to 0.5
    color = baseColor * (1 - shadeFactor) + 0.75*[1, 1, 1] * shadeFactor;   % Interpolate between base color and white
    color(isnan(color)) = 0;
    color_list{i} = color;
end
end