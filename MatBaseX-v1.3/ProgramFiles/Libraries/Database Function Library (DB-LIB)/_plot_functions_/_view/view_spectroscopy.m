function [fig, specData] = view_spectroscopy(formula, hv, parity)
% [fig, specData] = view_spectroscopy(formula, hv, parity)
%   This function plots the binding energies of core levels for a given formula. 
%   The peak heights of the core levels are determined using data from the photoionization 
%   cross-sections database, based on the provided photon energy (default hv = 5000 eV). 
%   For compounds, the intensity of each element is scaled proportionally to its quantity 
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
%   -   specData:       data structure containing all the Spectroscopy data

%% Default parameters
if nargin < 2; hv = 6000;  end
if nargin < 3; parity = 1;  end
if isempty(hv); hv = 6000; end
if isempty(parity); parity = 1; end
%% Validity checks on the input parameters
formula     = string(formula);
hv          = abs(double(hv));
%% 1 - Extracting Spectroscopy Data
%% 1.1 - Extracting Material Properties
% -- Formula Parameters
vformula            = parse_chemical_formula(formula);
elements            = {vformula(:).element};
num_of_elements     = length(elements);
%% 1.2 - Extracting Auger & Binding Energy Tables
norm_val_AUGER = []; norm_val_BE = [];
for i = 1:num_of_elements
    % -- Binding Energy Data
    T_BE{i}            = read_spectroscopy_element_data("be",elements{i}); 
    T_BE{i}.rSIGMA     = calc_xsect_sigma(hv, elements{i}, T_BE{i}.SHELL,[],0);
    T_BE{i}            = T_BE{i}(~isnan(T_BE{i}.rSIGMA), :);
    norm_val_BE(end+1) = max(T_BE{i}.rSIGMA(:));
    % -- Auger Energy Data
    T_AUGER{i}         = read_spectroscopy_element_data("auger",elements{i});
    T_AUGER{i}(:,3)    = hv - T_AUGER{i}(:,3);
    T_AUGER{i}.Properties.VariableNames{3} = 'AUGER_BE_eV';
    T_AUGER{i}              = T_AUGER{i}(T_AUGER{i}.AUGER_BE_eV>0, :);
    norm_val_AUGER(end+1)   = max(T_AUGER{i}.AUGER_INT(:));
end
for i = 1:num_of_elements
    T_BE{i}.rSIGMA          = T_BE{i}.rSIGMA ./ max(norm_val_BE(:));
    T_AUGER{i}.AUGER_INT    = 0.25*(T_AUGER{i}.AUGER_INT ./ max(norm_val_AUGER(:)));
end
%% 2 - Extracting the parity of the binding energies
if parity == -1
    for i = 1:num_of_elements
        T_BE{i}.BE_eV = -1.*T_BE{i}.BE_eV;
        T_AUGER{i}.AUGER_BE_eV = -1.*T_AUGER{i}.AUGER_BE_eV;
    end
elseif parity == +1  
    for i = 1:num_of_elements
        T_BE{i}.BE_eV = +1.*T_BE{i}.BE_eV;
        T_AUGER{i}.AUGER_BE_eV = +1.*T_AUGER{i}.AUGER_BE_eV;
    end
end
%% 3 - Combined table forms
% -- Combined AUGER table
data                = vertcat(T_AUGER{:});
[~, sort_idx]       = sort(data{:,4}, 'descend');  % Col4 numeric asc
T_AUGER_combined    = data(sort_idx, :);
T_AUGER_combined.AUGER_TRANSITION = strcat(T_AUGER_combined.ATOM_SYMB, {'('}, T_AUGER_combined.AUGER_TRANSITION, {')'});
T_AUGER_combined.ATOM_SYMB = [];
% -- Combined BE table
data                = vertcat(T_BE{:});
[~, sort_idx]       = sort(data{:,4}, 'descend');  % Col4 numeric asc
T_BE_combined       = data(sort_idx, :);
T_BE_combined.Properties.VariableNames{2} = 'ATOM_SHELL';
T_BE_combined.ATOM_SHELL = strcat(T_BE_combined.ATOM_SYMB, {'('}, T_BE_combined.ATOM_SHELL, {')'});
T_BE_combined.ATOM_SYMB = [];
%% 4 - Saving data to MATLAB data-structure
specData = struct();
specData.formula                = formula;
specData.hv                     = hv;
specData.parity                 = parity;
specData.vformula               = vformula;
specData.elements               = elements;
specData.num_of_elements        = num_of_elements;
specData.avg_Z                  = calc_average_z_number(formula);
specData.T_BE                   = T_BE;
specData.T_AUGER                = T_AUGER;
specData.T_BE_combined          = T_BE_combined;
specData.T_AUGER_combined       = T_AUGER_combined;
%% 5 - Plotting the data
fig = uifigure('Name', sprintf('Spectroscopy - %s (hν=%.0f eV)', formula, hv), ...
               'Position', [100 100 1000 575], 'Tag', 'SpecUI');
% Main grid: 2 rows (top plot 2x, bottom tables 1x), 2 cols equal
gl_main = uigridlayout(fig, [2 2], 'RowHeight', {'2x', '1x'}, 'ColumnWidth', {'1x', '1x'},...
                       'Padding', [10 10 10 10]);
% -- Bottom-left: BE Table (direct child)
table_be = uitable(gl_main, 'Data', T_BE_combined,...
    'ColumnSortable', true, 'ColumnWidth', 'auto', 'FontSize', 11);
table_be.Layout.Row = 2; table_be.Layout.Column = 1;

% -- Bottom-right: Auger Table (direct child)
table_auger = uitable(gl_main, 'Data', T_AUGER_combined,...
    'ColumnSortable', true, 'ColumnWidth', 'auto', 'FontSize', 11);
table_auger.Layout.Row = 2; table_auger.Layout.Column = 2;

% Top: Plot (direct child, spans cols 1-2)
ax = uiaxes(gl_main);
hold(ax, 'on');
ax.Layout.Row = 1; ax.Layout.Column = [1 2];
title(ax, sprintf('%s Spectrum (hν=%.0f eV)', formula, hv));
% -- Plot stems (AUGER)
for i = 1:num_of_elements
    nCL         = length(T_AUGER{i}.AUGER_TRANSITION);
    for j = 1:nCL
        stem(ax, T_AUGER{i}.AUGER_BE_eV(j), T_AUGER{i}.AUGER_INT(j), '-',...
            'linewidth', 0.5, 'marker', 'none', 'color', [0.5 0.5 0.5]);  
    end
end
% -- Plot stems (BE)
for i = 1:num_of_elements
    nCL         = length(T_BE{i}.SHELL);
    colorList   = read_spectroscopy_colors(T_BE{i}.SHELL);
    for j = 1:nCL
        stem(ax, T_BE{i}.BE_eV(j), T_BE{i}.rSIGMA(j), '-',...
            'linewidth', 2.5, 'marker', 'none', 'color', colorList{j});  
        text(ax, T_BE{i}.BE_eV(j), T_BE{i}.rSIGMA(j), sprintf('%s%s(%.2f)', elements{i}, T_BE{i}.SHELL(j), T_BE{i}.BE_eV(j)),...
            'Rotation', 90, 'FontWeight','normal', 'FontSize', 11, 'color', colorList{j});
    end
end
% -- Formatting
grid(ax, 'on'); grid(ax, 'minor');
xlabel(ax, 'Binding Energy [eV]', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Helvetica');
ylabel(ax, 'Relative Sigma [arb.]', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Helvetica');
ax.YLim = [0, 1.4.*max(specData.T_BE_combined.rSIGMA(:))];
if parity == -1
    ax.XLim = [-1.1*hv, 5];
    if hv > 0, xline(ax, -1.*hv, 'k:', 'Photon Energy', 'LineWidth', 2, 'Alpha', 0.7); end
elseif parity == +1
    ax.XLim = [-5, 1.1*hv];
    if hv > 0, xline(ax, hv, 'k:', 'Photon Energy', 'LineWidth', 2, 'Alpha', 0.7); end
end
title(ax, sprintf('BE & Auger Transitions - %s Spectrum (hν=%.0f eV)', formula, hv));
ax.FontSize = 11;
hold(ax, 'off');

end
