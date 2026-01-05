function fig = plt_result_auger(element, formalism, hv, auger_transition, auger_energy, auger_yield)
% fig = plt_result_auger(element, formalism, hv, auger_transition, auger_energy, auger_yield)
%   Plot Auger transition energies and normalized yields for a specified element.
%   Stem plot of Auger transition yields vs. energy (binding or kinetic).
%   When hv is provided, plots binding energy and adds a reference line.
%   When hv is 0 or empty, plots kinetic energy. Color-coded by transition
%   type, where K (Black), L (red), M (blue), N(green), O (orange). Labels
%   are not overlaid in text due to the large amount of transitions that obscures
%   the figure.
%
%   IN:
%   -   element:            (string/char) Chemical element symbol
%   -   formalism:          (string) Calculation method/formalism used
%   -   hv:                 (double, scalar) Photon energy reference [eV]; 
%                               use 0 or [] to display kinetic energy instead of binding energy
%   -   auger_transition:   (string or cell array) Auger transition designations (e.g., 'KL1L1')
%   -   auger_energy:       (double, vector) Auger transition energy or kinetic energy [eV]
%   -   auger_yield:        (double, vector) Normalized yield or intensity [arbitrary units]
%
%   OUT:
%   -   fig:                (figure object) Handle to created figure

%% INPUT VALIDATION AND PREPARATION
element = string(element);
hv = abs(double(hv));
nTransitions = length(auger_energy);
% Get element atomic number and color mapping
colorList = read_spectroscopy_colors(auger_transition);
elementData = get_mpd_props(element);
atomicNumber = elementData.atom_z;
%% 1    :   CREATE FIGURE AND AXIS
fig = figure('Name', sprintf('Auger Transition Energies (AE) - %s (Z=%.0f)', element, atomicNumber));
fig.Position = [100, 100, 1000, 425];  % [left, bottom, width, height]
% Create tiled layout for clean spacing
t = tiledlayout(1, 1);
t.TileSpacing = 'compact';
t.Padding = 'compact';
ax = nexttile();
%% 2    :   PLOT DATA
hold on;
% for i = 1:nTransitions
%     text(auger_energy(i), auger_yield(i), sprintf('%s-%.2f', strrep(auger_transition(i), ',', ''), auger_energy(i)),...
%         'Rotation', 45, 'FontName', 'Helvetica', 'FontSize',8, 'color', colorList{i}, 'HorizontalAlignment', 'left');
% end
for i = 1:nTransitions
    stem(auger_energy(i), auger_yield(i), ...
        'LineStyle', '-', 'LineWidth', 1.25, 'Marker', 'none', ...
        'Color', colorList{i});
end
%% 3.1    :   FORMATTING: AXES AND GRID
% Grid setup (subtle, light gray)
grid on; grid minor; 
% Scale and limits
ax.YScale = 'linear'; ax.XScale = 'log';
axis([1, 130000, 0, 1.45]);
% Axis appearance
ax.LineWidth = 1.0;
ax.FontName = 'Helvetica';
ax.FontSize = 11;
%% 3.2    :   AXIS LABELS (on top of plot area)
ylabel('Intensity [arb.]', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Helvetica');
if isempty(hv) || hv == 0
    xlabel('Kinetic Energy [eV]', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Helvetica');
else
    xlabel('Binding Energy [eV]', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Helvetica');
    xline(hv, 'k--', 'LineWidth', 1.2, 'Alpha', 0.6);
end
%% 3.3    :   TEXT ANNOTATIONS (Using annotation objects for consistency)
% Title section (element and atomic number)
text(0.02, 0.96, sprintf('%s(Z=%.0f)', element, atomicNumber),...
        'FontSize', 12, 'FontName', 'Helvetica', 'EdgeColor', 'none',...
        'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle',...
        'Units','normalized', 'FontWeight', 'bold');
% Formalism (calculation method)
text(0.02, 0.91, sprintf("%s", formalism),...
        'FontSize', 9, 'FontName', 'Helvetica', 'EdgeColor', 'none',...
        'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle',...
        'Units','normalized');
% Photon energy (if applicable)
if ~isempty(hv) && hv ~= 0
    % Formalism (calculation method)
    text(0.02, 0.87, sprintf('h\\nu = %.0f eV', hv),...
            'FontSize', 9, 'FontName', 'Helvetica', 'EdgeColor', 'none',...
            'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle',...
            'Units','normalized');
end
%% 3.4    :   AXIS POSITIONING (bring to top)
ax.Layer = 'top';
ax.TickDir = "in";

end