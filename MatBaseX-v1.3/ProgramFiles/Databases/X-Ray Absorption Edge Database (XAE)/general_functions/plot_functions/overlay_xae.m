function overlay_xae(formula, parity, energy_lims)
% overlay_xae(formula, parity, energy_lims)
%   This is a function that plots all the x-ray absorption edges for a 
%   particular material formula defined by the user. This can be used to quickly view 
%   all the available data for a particular element.
%
%   IN:
%   -   formula:        char or string of the compound formula; e.g. "Si", "SiO2", "GaAs", "Al2O3"
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
if nargin < 1; formula = ATOM_SYMB;  end
if nargin < 2; parity = 1;  end
if nargin < 3; energy_lims = [0.05, 5e5];  end
if isempty(formula); formula = ATOM_SYMB; end
if isempty(parity); parity = 1; end
if isempty(energy_lims); energy_lims = [0.05, 5e5]; end
%% Validity checks on the input parameters
formula     = string(formula);
energy_lims = sort(energy_lims);
%% 1 - Filing through all the selected elements and extracting absorption edges
% Extracting Parameters
% -- Formula Parameters
vformula            = parse_chemical_formula(formula);
elements            = {vformula(:).element};
num_of_elements     = length(elements);
% -- Extracting Absorption Edge Characteristics
for i = 1:num_of_elements
    [edge_energy{i}, edge_name{i}, edge_width{i}, edge_jumps{i}] = calc_xae(elements{i});
    edge_jumps{i} = vformula(i).ratio .* edge_jumps{i};
    % -- Removing all entries that lies outside of the energy limits
    edge_name{i}(edge_energy{i}<energy_lims(1)) = []; 
    edge_width{i}(edge_energy{i}<energy_lims(1)) = []; 
    edge_jumps{i}(edge_energy{i}<energy_lims(1)) = []; 
    edge_energy{i}(edge_energy{i}<energy_lims(1)) = [];
    edge_name{i}(edge_energy{i}>energy_lims(2)) = []; 
    edge_width{i}(edge_energy{i}>energy_lims(2)) = []; 
    edge_jumps{i}(edge_energy{i}>energy_lims(2)) = []; 
    edge_energy{i}(edge_energy{i}>energy_lims(2)) = [];
end
% -- Relative Intensity
norm_val = cat(1, edge_jumps{:});
norm_val = max(norm_val(:));
for i = 1:num_of_elements; redge_jumps{i} = edge_jumps{i} ./ norm_val; end
%% 3 - Overlaying the binding energy lines
hold on;
ax_lims = axis;
yval    = 0.75*max(ax_lims(3:4));
for i = 1:num_of_elements
    for j = 1:length(edge_energy{i})
        nCL         = length(edge_name{i});
        colorList   = read_xae_edges_color(edge_name{i});
        for k = 1:nCL; xline(edge_energy{i}(k), ':', 'linewidth', 1.2, 'color', colorList{k}, 'HandleVisibility','off');end 
        for k = 1:nCL; text(edge_energy{i}(k)+0.75, yval, sprintf('%s-%s(%.2f)', elements{i}, edge_name{i}(k), edge_energy{i}(k)), 'Rotation',90, 'FontWeight','normal', 'FontSize',8, 'color', colorList{k}); end
    end
end
end