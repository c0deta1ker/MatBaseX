function [fig, xaeData] = view_xae(formula, parity, energy_lims)
% [fig, xaeData] = view_xae(formula, parity, energy_lims)
%   This is a function that plots the binding energies of all the core-levels 
%   for a particular element defined by the user. This can edge_energy used to 
%   quickly view all the available data for a particular element.
%
%   IN:
%   -   formula:        char or string of the compound formula; e.g. "Si", "SiO2", "GaAs", "Al2O3"
%   -   parity:	        either +1 or -1; 
%                               +1 plots the absorption edge energies are positive. 
%                               -1 plots the absorption edge energies are negative.
% 	-   energy_lims:    [1×2] row vector of energy limits of absorption edges to be plotted
%
%   OUT:
%   -   fig:	        figure output
%   -   xaeData:        data structure containing all the XAE data
%
%   SEE REFERENCES:
%   [1] https://xraydb.xrayabsorption.org/element/

%% Default parameters
if nargin < 2; parity = 1;  end
if nargin < 3; energy_lims = [];  end
if isempty(parity); parity = 1; end
if isempty(energy_lims); energy_lims = []; end
%% Validity checks on the input parameters
formula    = string(formula);
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
    if ~isempty(energy_lims)
        % -- Lower bound
        edge_name{i}(edge_energy{i}<energy_lims(1)) = []; 
        edge_width{i}(edge_energy{i}<energy_lims(1)) = []; 
        edge_jumps{i}(edge_energy{i}<energy_lims(1)) = []; 
        edge_energy{i}(edge_energy{i}<energy_lims(1)) = [];
        % -- Upper bound
        edge_name{i}(edge_energy{i}>energy_lims(2)) = []; 
        edge_width{i}(edge_energy{i}>energy_lims(2)) = []; 
        edge_jumps{i}(edge_energy{i}>energy_lims(2)) = []; 
        edge_energy{i}(edge_energy{i}>energy_lims(2)) = [];
    end
end
% -- Relative Intensity
norm_val = [];
for i = 1:num_of_elements; if ~isempty(edge_jumps{i}); norm_val = vertcat(norm_val, edge_jumps{i}); end; end
% norm_val = cat(1, edge_jumps{:});
norm_val = max(norm_val(:));
for i = 1:num_of_elements; redge_jumps{i} = edge_jumps{i} ./ norm_val; end
%% 2 - Extracting the parity of the binding energies
if parity == -1
    for i = 1:length(edge_energy); edge_energy{i} = -1 .* edge_energy{i}; end
elseif parity == +1
    for i = 1:length(edge_energy); edge_energy{i} = +1 .* edge_energy{i}; end
end
%% 3 - Saving data to MATLAB data-structure
xaeData = struct();
xaeData.formula             = formula;
xaeData.vformula            = vformula;
xaeData.elements            = elements;
xaeData.num_of_elements     = num_of_elements;
xaeData.edge_name           = edge_name;
xaeData.edge_energy         = edge_energy;
xaeData.edge_width          = edge_width;
xaeData.edge_jumps          = edge_jumps;
xaeData.redge_jumps         = redge_jumps;
%% 4 - Plotting the data
% Creating figure
fig = figure(); 
fig.Position(1) = 100; fig.Position(2) = 100;
fig.Position(3) = 1000; 
fig.Position(4) = 425;
% - Creating tiled axis
t = tiledlayout(1,1);
t.TileSpacing = 'compact';
t.Padding = 'compact';
% - Plot the figure
nexttile(); hold on; grid on; grid minor;
for i = 1:num_of_elements
    for j = 1:length(edge_energy{i})
        nCL         = length(edge_name{i});
        colorList   = read_xae_edges_color(edge_name{i});
        for k = 1:nCL; stem(edge_energy{i}(k), redge_jumps{i}(k), '-', 'linewidth', 1 + edge_width{i}(k)/7, 'marker', 'none', 'color', colorList{k});end 
        for k = 1:nCL; text(edge_energy{i}(k), redge_jumps{i}(k), sprintf('%s-%s(%.2f)', elements{i}, edge_name{i}(k), edge_energy{i}(k)), 'Rotation',90, 'FontWeight','normal', 'FontSize',8, 'color', colorList{k}); end
    end
end
% - Plotting the x- and y-axes
text(0.02, 0.96, sprintf("%s", formula),...
    'FontSize', 12, 'color', 'k', 'Units','normalized', 'FontWeight', 'bold', 'HorizontalAlignment','left');
xlabel('Energy [eV]', 'FontWeight','bold');
ylabel(' Edge Jump [arb.]', 'FontWeight','bold');
ax = gca; ax.YScale = 'linear'; ax.XScale = 'log';
if parity == -1;        axis([-5e5, -0.05, 0, 1.25]);
elseif parity == +1;    axis([0.05, 5e5, 0, 1.25]);
end
end