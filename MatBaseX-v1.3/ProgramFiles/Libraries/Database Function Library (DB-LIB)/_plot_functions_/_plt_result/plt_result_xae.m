function fig = plt_result_xae(element, formalism, edge_energy, edge_name, edge_width, edge_jump)
% fig = plt_result_xae(element, formalism, edge_energy, edge_name, edge_width, edge_jump)
%   Plot X-ray absorption edge energies and jump strengths for multiple edges.
%   Visualizes absorption edges using stems with widths proportional to
%   edge_width and heights proportional to edge_jump. Logarithmic energy
%   scale emphasizes low-energy edges. Color-coded by edge type.
%
%   IN:
%   -   element:      (string/char) Chemical element symbol
%   -   formalism:    (string) Calculation method/formalism used
%   -   edge_energy:  (double, scalar or vector) Edge energy position(s) [eV]
%   -   edge_name:    (string or cell array) Edge designation (e.g., 'K', 'L1', {'K','L1'})
%   -   edge_width:   (double, scalar or vector) Edge width parameter(s) [eV]
%   -   edge_jump:    (double, scalar or vector) Edge jump magnitude(s) [arbitrary units]
%
%   OUT:
%   -   fig:         (figure object) Handle to created figure

%% INPUT VALIDATION AND PREPARATION
element         = string(element);
nTransitions    = length(edge_name);
% Get element atomic number and color mapping
colorList       = read_spectroscopy_colors(edge_name);
elementData     = get_mpd_props(element);
atomicNumber    = elementData.atom_z;
%% 1    :   CREATE FIGURE AND AXIS
fig = figure('Name', sprintf('X-Ray Absorption Edge (XAE) - %s (Z=%.0f)', element, atomicNumber));
fig.Position = [100, 100, 1000, 425];  % [left, bottom, width, height]
% Create tiled layout for clean spacing
t = tiledlayout(1, 1);
t.TileSpacing = 'compact';
t.Padding = 'compact';
ax = nexttile();
%% 2    :   PLOT DATA
hold on;
if nTransitions == 1
    stem(edge_energy, edge_jump, '-', 'linewidth', 1 + edge_width(1)/7, 'marker', 'none', 'color', colorList{1});
    text(edge_energy, edge_jump, sprintf('%s(%.2f)', edge_name(1), edge_energy), 'Rotation',45, 'FontWeight','bold', 'FontSize',8);
else
    for i = 1:nTransitions; stem(edge_energy(i), edge_jump(i), '-', 'linewidth', 1 + edge_width(i)/7, 'marker', 'none', 'color', colorList{i});end 
    for i = 1:nTransitions; text(edge_energy(i), edge_jump(i), sprintf('%s(%.2f)', edge_name(i), edge_energy(i)), 'Rotation',45, 'FontWeight','bold', 'FontSize',8); end
end
%% 3.1    :   FORMATTING: AXES AND GRID
% Grid setup (subtle, light gray)
grid on; grid minor; 
% Scale and limits
ax.XScale = 'log'; ax.YScale = 'linear';
axis([0.05, 5e5, 0, ceil(1.5*max(edge_jump(:)))]);
% Axis appearance
ax.LineWidth = 1.0;
ax.FontName = 'Helvetica';
ax.FontSize = 11;
%% 3.2    :   AXIS LABELS (on top of plot area)
xlabel('Binding Energy [eV]', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Helvetica');
ylabel('Edge Jump [arb.]', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Helvetica');
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