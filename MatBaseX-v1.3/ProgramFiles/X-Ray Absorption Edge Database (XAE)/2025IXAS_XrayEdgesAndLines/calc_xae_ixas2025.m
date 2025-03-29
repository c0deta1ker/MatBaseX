function [edge_energy, edge_name, edge_width, edge_jump] = calc_xae_ixas2025(element, edgenames, plot_results)
% [edge_energy, edge_name] = calc_xae_ixas2025(element, edgenames, plot_results)
%   This is a function that extracts the electron absorption edge energies 
%   from elements with Z from 1 to 98.
%   [1] https://xraydb.xrayabsorption.org/element
%
%   IN:
%   -   element:    	string of the element; e.g. "H", "He", "Si", "In"...
%   -   edgenames:      M×1 string array of the edges to be probed; e.g. ["K", "L2"]... (If empty, will return all known edges.)
%   -   plot_results:   if 1, will plot figure summary, otherwise it wont.
%
%   OUT:
%   -   edge_energy:    M×1 vector of the absorption edge energies [eV]. Returns NaN for undefined edge energies.
%   -   edge_name:      M×1 vector of the absorption edge names.
%   -   edge_width:     M×1 vector of the absorption edge width [eV]. Returns NaN for undefined edge energies.
%   -   edge_jump:      M×1 vector of the absorption edge jump. Returns NaN for undefined edge energies.

%% Default parameters
if nargin < 2; edgenames = [];  end
if nargin < 3; plot_results = 0;  end
if isempty(edgenames); edgenames = []; end
if isempty(plot_results); plot_results = 0; end
%% Disable warning back-trace
warning('off', 'backtrace');
%% Validity checks on the input parameters
element     = string(element);
edgenames   = string(edgenames);
%% 1 - Loading the MATLAB data structure
XAE_DB_IXAS2025	    = load('XAE_DB_IXAS2025.mat'); XAE_DB_IXAS2025 = XAE_DB_IXAS2025.XAE_DB_IXAS2025;
ATOM_SYMB           = string(XAE_DB_IXAS2025.ATOM_SYMB);
%% 2 - Find the database index of the defined element
ele_indx 	= find(strcmpi(ATOM_SYMB, element), 1);
if isempty(ele_indx); msg = 'Element could not be identified. Only use atomic-symbols for elements 1 - 98; H, He, Li, Be..., Bk, Cf'; error(msg); end
ATOM_EDGE_NAME      = string(XAE_DB_IXAS2025.ATOM_EDGE_NAME{ele_indx});
ATOM_EDGE_ENERGY    = XAE_DB_IXAS2025.ATOM_EDGE_ENERGY{ele_indx};
ATOM_EDGE_WIDTH     = XAE_DB_IXAS2025.ATOM_EDGE_WIDTH{ele_indx};
ATOM_EDGE_JUMP      = XAE_DB_IXAS2025.ATOM_EDGE_JUMP{ele_indx};
%% 3 - Find the database index of the defined core-levels
% If no edge is defined, use all available ones
if isempty(edgenames); edge_indx = 1:length(ATOM_EDGE_NAME); 
% Otherwise, parse the input
else
    % - If 1 edge is entered
    if isscalar(edgenames)
        edge_indx 	= find(strcmpi(ATOM_EDGE_NAME, edgenames), 1);
        if isempty(edge_indx)
            edge_indx = 0; msg = sprintf("Absorption edge %s not found. Only the following exist for %s : %s . NaN values returned.", edgenames, element, join(string(ATOM_EDGE_NAME), ', ')); warning(msg); 
        end
    % - If a string array of edges is entered
    else
        edge_indx = zeros(size(edgenames));
        for i = 1:length(edgenames)
            ith_edge   = edgenames(i);
            idx             = find(ATOM_EDGE_NAME == ith_edge);
            % --- If the edge is not found
            if ~isempty(idx);   edge_indx(i) = idx;
            else;               edge_indx(i) = 0;
                msg = sprintf("Absorption edge %s not found. Only the following exist for %s : %s . NaN values returned.", edgenames(i), element, join(string(ATOM_EDGE_NAME), ', ')); warning(msg); 
            end
        end
    end
end
%% 4 - Extracting the relevant binding energies
edge_energy = []; edge_name = ""; edge_width = []; edge_jump = [];
for i = 1:length(edge_indx)
    if edge_indx(i) == 0
        edge_name(i)    = NaN(1);
        edge_energy(i)  = NaN(1);
        edge_width(i)   = NaN(1);
        edge_jump(i)    = NaN(1);
    else
        edge_name(i)    = ATOM_EDGE_NAME(edge_indx(i));
        edge_energy(i)  = ATOM_EDGE_ENERGY(edge_indx(i));
        edge_width(i)   = ATOM_EDGE_WIDTH(edge_indx(i));
        edge_jump(i)    = ATOM_EDGE_JUMP(edge_indx(i));
    end
end
%% Validity check on the outputs
% -- If no initial corelevel input was made, then remove all NaN entries
if isempty(edgenames)
    NaN_idx         = isnan(edge_energy);
    edge_name(NaN_idx)      = [];
    edge_energy(NaN_idx)    = [];
    edge_width(NaN_idx)     = [];
    edge_jump(NaN_idx)      = [];
% -- Otherwise, preserve the labels that were user-defined
else
    NaN_idx             = find(edge_indx == 0);
    edge_name(NaN_idx)  = edgenames(NaN_idx);
end
% -- Ensure that the outputs are in columns
if size(edge_name, 2) > 1;      edge_name = edge_name'; end
if size(edge_energy, 2) > 1;    edge_energy = edge_energy'; end
if size(edge_width, 2) > 1;     edge_width = edge_width'; end
if size(edge_jump, 2) > 1;     edge_jump = edge_jump'; end
%% Enable warning back-trace
warning('on', 'backtrace');
%% -- Plot for debugging
if plot_results == 1
    nCL         = length(edge_name);
    colorList   = read_xae_edges_color(edge_name);
    % - Creating a figure
    fig = figure(); 
    fig.Position(1) = 100; fig.Position(2) = 100;
    fig.Position(3) = 800; 
    fig.Position(4) = 350;
    % - Creating a tiled axis
    t = tiledlayout(1,1);
    t.TileSpacing = 'compact';
    t.Padding = 'compact';
    % - Plot the figure
    nexttile(); hold on; grid on; grid minor;
    % - Analytical absorption edge spectrum
    if nCL == 1
        stem(edge_energy, edge_jump, '-', 'linewidth', 1 + edge_width(i)/7, 'marker', 'none', 'color', colorList{1});
        text(edge_energy, edge_jump, sprintf('%s(%.2f)', edge_name(1), edge_energy), 'Rotation',45, 'FontWeight','bold', 'FontSize',8);
    else
        for i = 1:nCL; stem(edge_energy(i), edge_jump(i), '-', 'linewidth', 1 + edge_width(i)/7, 'marker', 'none', 'color', colorList{i});end 
        for i = 1:nCL; text(edge_energy(i), edge_jump(i), sprintf('%s(%.2f)', edge_name(i), edge_energy(i)), 'Rotation',45, 'FontWeight','bold', 'FontSize',8); end
    end
    % - Formatting the axis
    text(0.02, 0.96, sprintf("%s(Z=%i)", element, ele_indx),...
        'FontSize', 12, 'color', 'k', 'Units','normalized', 'FontWeight', 'bold', 'HorizontalAlignment','left');
    text(0.02, 0.91, sprintf("IXAS(2025)"),...
        'FontSize', 8, 'color', 'k', 'Units','normalized', 'HorizontalAlignment','left');
    xlabel('Energy [eV]', 'FontWeight','bold');
    ylabel(' Edge Jump ', 'FontWeight','bold');
    ax = gca; ax.YScale = 'linear'; ax.XScale = 'log';
    axis([0.05, 5e5, 0, ceil(1.5*max(edge_jump(:)))]);
end
end