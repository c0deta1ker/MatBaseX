function overlay_xae(elements, parity, energy_lims)
% overlay_xae(elements, parity, energy_lims)
%   This is a function that plots all the x-ray absorption edges for a 
%   particular material formula defined by the user. This can be used to quickly view 
%   all the available data for a particular element.
%
%   IN:
%   -   elements:	    1xN cell vector of strings of the element names; e.g. "H", "He", "Si", "In"...
%   -   parity:	        either 1 or -1;
%                               +1 plots the absorption edge energies are positive. 
%                               -1 plots the absorption edge energies are negative.
% 	-   energy_lims:    [1×2] row vector of energy limits of absorption edges to be plotted
%
%   OUT: (none)

%% Initializing variables
ATOM_SYMB = read_mpd_elements();
ATOM_SYMB = ATOM_SYMB(1:98);
%% Default parameters
if nargin < 1; elements = ATOM_SYMB;  end
if nargin < 2; parity = 1;  end
if nargin < 3; energy_lims = [];  end
if isempty(elements); elements = ATOM_SYMB; end
if isempty(parity); parity = 1; end
if isempty(energy_lims); energy_lims = []; end
%% Validity checks on the input parameters
elements            = string(elements);
energy_lims         = sort(energy_lims);
num_of_elements     = length(elements);
%% 1 - Filing through all the selected elements and extracting absorption edges
% -- Extracting Absorption Edge Characteristics
for i = 1:num_of_elements
    [edge_energy{i}, edge_name{i}, edge_width{i}, edge_jumps{i}] = calc_xae(elements(i));
end
% -- Relative Intensity
norm_val = cat(1, edge_jumps{:});
norm_val = max(norm_val(:));
for i = 1:num_of_elements; redge_jumps{i} = edge_jumps{i} ./ norm_val; end
%% 2 - Extracting the parity of the energies
if parity == -1;        for i = 1:length(edge_energy); edge_energy{i} = -1 .* edge_energy{i}; end
elseif parity == +1;    for i = 1:length(edge_energy); edge_energy{i} = +1 .* edge_energy{i}; end
end
% -- Removing all entries that lies outside of the energy limits
for i = 1:num_of_elements
    if ~isempty(energy_lims)
        % -- Lower bound
        edge_name{i}(edge_energy{i}<energy_lims(1)) = []; 
        edge_width{i}(edge_energy{i}<energy_lims(1)) = []; 
        edge_jumps{i}(edge_energy{i}<energy_lims(1)) = []; 
        redge_jumps{i}(edge_energy{i}<energy_lims(1)) = [];
        edge_energy{i}(edge_energy{i}<energy_lims(1)) = [];
        % -- Upper bound
        edge_name{i}(edge_energy{i}>energy_lims(2)) = []; 
        edge_width{i}(edge_energy{i}>energy_lims(2)) = []; 
        edge_jumps{i}(edge_energy{i}>energy_lims(2)) = []; 
        redge_jumps{i}(edge_energy{i}>energy_lims(2)) = [];
        edge_energy{i}(edge_energy{i}>energy_lims(2)) = [];
    end
end
%% 3 - Overlaying the binding energy lines
hold on;
ax_lims = axis;
aheight = linspace(0.60, 0.80, length(edge_name));
for i = 1:num_of_elements
    nCL         = length(edge_name{i});
    cols        = lines(length(edge_name{i}));
    yval        = aheight(i)*max(ax_lims(3:4));
    for j = 1:nCL
        edge_ij = edge_energy{i}(j);
        stem(edge_ij, yval, ':',...
            'linewidth', 1.25, 'marker', 'none', 'color', cols(i,:), 'HandleVisibility','off');
        str = sprintf('%s%s(%.2f)', elements{i}, edge_name{i}{j}, edge_energy{i}(j));
        text(edge_ij, yval, str,...
            'Rotation', 90, 'FontWeight','normal', 'FontSize', 8, 'color', cols(i,:),...
            'HorizontalAlignment','left');
    end
end
end