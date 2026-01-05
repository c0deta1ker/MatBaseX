function [fig, augerData] = view_auger(formula, hv, parity, energy_lims)
% [fig, augerData] = view_auger(formula, hv, parity, energy_lims)
%   This function plots the Auger binding energies of core levels for a given 
%   chemical formula. The peak heights of the Auger transitions are determined 
%   from the normalised multiplier and the binding energies are determined 
%   relative to the provided photon energy (default hv = 6000 eV). For compounds, 
%   the intensity of each element is scaled proportionally to its quantity 
%   in the compound, providing a good estimate of peak heights.
%
%   IN:
%   -   formula:        char or string of the compound formula; e.g. "Si", "SiO2", "GaAs", "Al2O3"
%   -   hv:             scalar of the incident photon energy used to estimate the peak height [eV]
%   -   parity:	        either +1 or -1; 
%                               +1 plots the binding energies as positive. 
%                               -1 plots the binding energies as negative.
% 	-   energy_lims:    [1×2] row vector of energy limits to be plotted
%
%   OUT:
%   -   fig:            figure output
%   -   augerData:      data structure containing all the Auger data

%% Default parameters
if nargin < 2; hv = [];  end
if nargin < 3; parity = 1;  end
if nargin < 4; energy_lims = [];  end
if isempty(hv); hv = []; end
if isempty(parity); parity = 1; end
if isempty(energy_lims); energy_lims = []; end
%% Validity checks on the input parameters
formula     = string(formula);
hv          = abs(double(hv));
energy_lims = sort(energy_lims);
%% 1 - Filing through all the selected elements and extracting binding energies
% Extracting Parameters
% -- Formula Parameters
vformula            = parse_chemical_formula(formula);
elements            = {vformula(:).element};
num_of_elements     = length(elements);
% -- Auger Transiton Energies
for i = 1:num_of_elements
    [auger_energy_be{i}, auger_norm_mult{i}, auger_transition{i}] = calc_auger(elements{i}, hv, [], 0);
end
%% 2 - Extracting the parity of the Auger transition energies
if parity == -1;        for i = 1:length(auger_energy_be); auger_energy_be{i} = -1 .* auger_energy_be{i}; end
elseif parity == +1;    for i = 1:length(auger_energy_be); auger_energy_be{i} = +1 .* auger_energy_be{i}; end
end
% -- Removing all entries that lies outside of the energy limits
for i = 1:num_of_elements
    if ~isempty(energy_lims)
        % -- Lower bound
        auger_transition{i}(auger_energy_be{i}<energy_lims(1)) = []; 
        auger_norm_mult{i}(auger_energy_be{i}<energy_lims(1)) = []; 
        auger_energy_be{i}(auger_energy_be{i}<energy_lims(1)) = [];
        % -- Upper bound
        auger_transition{i}(auger_energy_be{i}>energy_lims(2)) = []; 
        auger_norm_mult{i}(auger_energy_be{i}>energy_lims(2)) = []; 
        auger_energy_be{i}(auger_energy_be{i}>energy_lims(2)) = []; 
    end
end
%% 3 - Saving data to MATLAB data-structure
augerData = struct();
augerData.formula               = formula;
augerData.hv                    = hv;
augerData.parity                = parity;
augerData.energy_lims           = energy_lims;
augerData.vformula              = vformula;
augerData.elements              = elements;
augerData.num_of_elements       = num_of_elements;
augerData.avg_Z                 = calc_average_z_number(formula);
augerData.auger_transition      = auger_transition;
augerData.auger_energy_be       = auger_energy_be;
augerData.auger_norm_mult       = auger_norm_mult;
%% 4 - Plotting the data
%% 4.1    :   Create Figure & Axis
fig = figure('Name', sprintf('Auger Transition Energy Spectrum - %s (Z=%.1f)', formula, augerData.avg_Z));
fig.Position = [100, 100, 1000, 425];  % [left, bottom, width, height]
% Create tiled layout for clean spacing
t = tiledlayout(1, 1);
t.TileSpacing = 'compact';
t.Padding = 'compact';
nexttile(); hold on; grid on; grid minor;
%% 4.2    :   Plot Data
for i = 1:num_of_elements
    nAE         = length(auger_energy_be{i});
    colorList   = read_spectroscopy_colors(auger_transition{i});
    for j = 1:nAE
        text(auger_energy_be{i}(j), auger_norm_mult{i}(j), sprintf('%s%s(%.2f)', elements{i}, auger_transition{i}(j), auger_energy_be{i}(j)),...
                'Rotation', 90, 'FontWeight','normal', 'FontSize',8, 'color', colorList{j});
        stem(auger_energy_be{i}(j), auger_norm_mult{i}(j), '-',...
            'linewidth', 1.50, 'marker', 'none', 'color', colorList{j}); 
    end
end
%% 4.3    :   Formatting the Axis & Grid
% Scale and limits
ax = gca; 
ax.XScale = 'log'; ax.YScale = 'linear'; 
ax.Layer = 'top'; ax.TickDir = "in";
% Axis appearance
ax.LineWidth = 1.0;
ax.FontName = 'Helvetica';
ax.FontSize = 11;
if parity == -1
    axis([-130000, -1, 0, 1.25]);
elseif parity == +1
    axis([1, 130000, 0, 1.25]);
end
% - Labeling the x- and y-axes
ylabel('Intensity [arb.]', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Helvetica');
if isempty(hv) || hv == 0
    xlabel('Kinetic Energy [eV]', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Helvetica');
else
    xlabel('Binding Energy [eV]', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Helvetica');
    if parity == -1       
        axis([-130000, -1, 0, 1.25]);
        xline(-1*hv(1), 'k--', 'LineWidth', 1.2, 'Alpha', 0.6);
    elseif parity == +1  
        axis([1, 130000, 0, 1.25]);
        xline(hv(1), 'k--', 'LineWidth', 1.2, 'Alpha', 0.6);
    end
end
%% 4.4    :   Text Annotations
% Title section (element and atomic number)
text(0.02, 0.96, sprintf('%s(Z=%.1f)', formula, augerData.avg_Z),...
        'FontSize', 12, 'FontName', 'Helvetica', 'EdgeColor', 'none',...
        'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle',...
        'Units','normalized', 'FontWeight', 'bold');
% Photon energy (if applicable)
if ~isempty(hv) && hv ~= 0
    % Formalism (calculation method)
    text(0.02, 0.91, sprintf('h\\nu = %.0f eV', hv),...
        'FontSize', 9, 'FontName', 'Helvetica', 'EdgeColor', 'none',...
        'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle',...
        'Units','normalized');
end
end