function [fig, augerData] = view_auger(formula, hv, parity)
% [fig, augerData] = view_auger(formula, hv, parity)
%   This function plots the Auger binding energies of core levels for a given 
%   chemical formula. The peak heights of the Auger transitions are determined 
%   from the normalised multiplier and the binding energies are determined 
%   relative to the provided photon energy (default hv = 5000 eV). For compounds, 
%   the intensity of each element is scaled proportionally to its quantity 
%   in the compound, providing a good estimate of peak heights.
%
%   IN:
%   -   formula:        char or string of the compound formula; e.g. "Si", "SiO2", "GaAs", "Al2O3"
%   -   hv:             scalar of the incident photon energy used to estimate the peak height [eV]
%   -   parity:	        either +1 or -1; 
%                               +1 plots the binding energies as positive. 
%                               -1 plots the binding energies as negative.
%
%   OUT:
%   -   fig:            figure output
%   -   augerData:      data structure containing all the Auger data

%% Default parameters
if nargin < 2; hv = 5000;  end
if nargin < 3; parity = 1;  end
if isempty(hv); hv = 5000; end
if isempty(parity); parity = 1; end
%% Validity checks on the input parameters
formula     = string(formula);
hv          = abs(double(hv));
%% 1 - Filing through all the selected elements and extracting binding energies
% Extracting Parameters
% -- Formula Parameters
vformula            = parse_chemical_formula(formula);
elements            = {vformula(:).element};
num_of_elements     = length(elements);
% -- Auger Transiton Energies
for i = 1:num_of_elements
    [auger_energy_be{i}, auger_norm_mult{i}, auger_transition{i}] = calc_auger(elements{i}, hv, [], 0);
    auger_norm_mult_rel{i} = vformula(i).ratio .* auger_norm_mult{i};
end
% -- Relative Intensity
norm_val = cat(1, auger_norm_mult_rel{:});
norm_val = max(norm_val(:));
for i = 1:num_of_elements; auger_norm_mult_rel{i} = auger_norm_mult_rel{i} ./ norm_val; end
%% 2 - Extracting the parity of the Auger transition energies
if parity == -1
    for i = 1:numel(auger_energy_be); auger_energy_be{i} = -auger_energy_be{i}; end
end
%% 3 - Saving data to MATLAB data-structure
augerData = struct();
augerData.formula               = formula;
augerData.vformula              = vformula;
augerData.elements              = elements;
augerData.num_of_elements       = num_of_elements;
augerData.auger_transition      = auger_transition;
augerData.auger_energy_be       = auger_energy_be;
augerData.auger_norm_mult       = auger_norm_mult;
augerData.auger_norm_mult_rel   = auger_norm_mult_rel;
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
    colorList   = parula(num_of_elements+1);
    nAE         = length(auger_energy_be{i});
    for j = 1:nAE
        text(auger_energy_be{i}(j), auger_norm_mult_rel{i}(j), sprintf('%s%s(%.2f)', elements{i}, auger_transition{i}(j), auger_energy_be{i}(j)),...
                'Rotation', 90, 'FontWeight','bold', 'FontSize',8, 'color', colorList(i,:));
        stem(auger_energy_be{i}(j), auger_norm_mult_rel{i}(j), '-', 'linewidth', 1.50, 'marker', 'none', 'color', colorList(i,:)); 
    end
end
% - Labeling the x- and y-axes
text(0.02, 0.96, sprintf("%s", formula),...
    'FontSize', 12, 'color', 'k', 'Units','normalized', 'FontWeight', 'bold', 'HorizontalAlignment','left');
xlabel('Binding Energy [eV]', 'FontWeight','bold');
ylabel('Relative Intensity [arb.]', 'FontWeight','bold');
ax = gca; ax.YScale = 'linear'; ax.XScale = 'log';
if isempty(hv); xlabel('Kinetic Energy [eV]', 'FontWeight','bold');
else        
    xlabel('Binding Energy [eV]', 'FontWeight','bold');
    text(0.02, 0.925, sprintf("hv = %.i eV", hv),...
        'FontSize', 8, 'color', 'k', 'Units','normalized', 'HorizontalAlignment','left');
end
if parity == -1       
    axis([-130000, -1, 0, 1.25]);
    xline(-1*hv(1), 'r-', 'linewidth', 1.5);
elseif parity == +1  
    axis([1, 130000, 0, 1.25]);
    xline(hv(1), 'r-', 'linewidth', 1.5);
end
end