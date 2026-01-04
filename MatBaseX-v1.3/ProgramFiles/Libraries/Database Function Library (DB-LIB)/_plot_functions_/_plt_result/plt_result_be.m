function fig = plt_result_be(element, formalism, be, corelevel)
% fig = plt_result_be(element, formalism, be, corelevel)
%   Display binding energies as a stem plot for multiple core-levels or
%   a single level of a specified element. Plots binding energies on a logarithmic 
%   energy scale with color-coded stems representing different core-levels. 
%   Labels include energy values. Element name and formalism are annotated on the plot.
%
%   IN:
%   -   element:        (string/char) Chemical element symbol (e.g., 'Au', 'Cu')
%   -   formalism:      (string) Calculation method/formalism used
%   -   be:             (double, scalar or vector) Binding energy value(s) [eV]
%   -   corelevel:      (string or cell array) Core-level designation (e.g., '1s', '2p', {'1s','2s'})
%
%   OUT:
%   -   fig:            (figure object) Handle to created figure

%% INPUT VALIDATION AND PREPARATION
element         = string(element);
nTransitions    = length(be);
% Get element atomic number and color mapping
colorList       = read_spectroscopy_colors(corelevel);
elementData     = get_mpd_props(element);
atomicNumber    = elementData.atom_z;
%% 1    :   CREATE FIGURE AND AXIS
fig = figure('Name', sprintf('Binding Energy (BE) - %s (Z=%.0f)', element, atomicNumber));
fig.Position = [100, 100, 1000, 425];  % [left, bottom, width, height]
% Create tiled layout for clean spacing
t = tiledlayout(1, 1);
t.TileSpacing = 'compact';
t.Padding = 'compact';
ax = nexttile();
%% 2    :   PLOT DATA
hold on;
if nTransitions == 1
    stem(be, 1, '-', 'LineWidth', 1.5, 'Marker', 'none', 'Color', colorList{1});
    text(be, 1, sprintf('%s(%.2f)', corelevel, be), 'Rotation',45, 'FontWeight','bold', 'FontSize',8);
else
    for i = 1:nTransitions; stem(be(i), i/nTransitions, '-', 'LineWidth', 1.5, 'Marker', 'none', 'Color', colorList{i});end 
    for i = 1:nTransitions; text(be(i), i/nTransitions, sprintf('%s(%.2f)', corelevel(i), be(i)), 'Rotation',45, 'FontWeight','bold', 'FontSize',8); end
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
xlabel('Binding Energy [eV]', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Helvetica');
ylabel('Intensity [arb.]', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Helvetica');
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
%% 3.4    :   AXIS POSITIONING (bring to top)
ax.Layer = 'top';
ax.TickDir = "in";

end