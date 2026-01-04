function fig = plt_result_xsect_beta(element, formalism, hv, corelevel, hv_data, xsect_data, xsect_beta)
% fig = plt_result_xsect_beta(element, formalism, hv, corelevel, hv_data, xsect_data, xsect_beta)
%   Plot angular distribution parameter (beta) vs. photon energy.
%   Linear plot of angular distribution parameter beta (range typically 0–2)
%   vs. photon energy. Useful for understanding angular asymmetry in
%   photoionization. Color-coded by core-level.
%
%   IN:
%   -   element:      (string/char) Chemical element symbol
%   -   formalism:    (string) Calculation method/formalism used
%   -   hv:           (double, scalar or vector) Photon energy value(s) [eV]
%   -   corelevel:    (string or cell array) Core-level(s) (e.g., '1s', {'1s','2s'})
%   -   hv_data:      (double, vector) Photon energy grid [eV]
%   -   xsect_data:   (double, matrix) Beta parameter reference data
%   -   xsect_beta:   (double, scalar or vector) Beta value(s) at hv
%
%   OUT:
%   -   fig:          (figure object) Handle to created figure

%% INPUT VALIDATION AND PREPARATION
element         = string(element);
nTransitions    = length(corelevel);
% Get element atomic number and color mapping
colorList       = read_spectroscopy_colors(corelevel);
elementData     = get_mpd_props(element);
atomicNumber    = elementData.atom_z;
%% 1    :   CREATE FIGURE AND AXIS
fig = figure('Name', sprintf('Photoionization Parameters (XSECT-BETA) - %s (Z=%.0f)', element, atomicNumber));
fig.Position = [100, 100, 700, 500];  % [left, bottom, width, height]
% Create tiled layout for clean spacing
t = tiledlayout(1, 1);
t.TileSpacing = 'compact';
t.Padding = 'compact';
ax = nexttile();
%% 2    :   PLOT DATA
hold on;
for i = 1:nTransitions
    plot(hv_data, xsect_data(:,i),...
        'x-', 'markersize', 5, 'markeredgecolor', colorList{i},...
        'markerfacecolor', colorList{i}, 'color', colorList{i}); 
    if isscalar(hv);        scatter(hv, xsect_beta(i), 'SizeData', 25, 'markeredgecolor', colorList{i}, 'markerfacecolor', colorList{i}, 'MarkerFaceAlpha', 0.95, 'HandleVisibility','off');
    elseif isrow(hv);       scatter(hv, xsect_beta(i,:), 'SizeData', 25, 'markeredgecolor', colorList{i}, 'markerfacecolor', colorList{i}, 'MarkerFaceAlpha', 0.95, 'HandleVisibility','off');
    elseif iscolumn(hv);    scatter(hv, xsect_beta(:,i), 'SizeData', 25, 'markeredgecolor', colorList{i}, 'markerfacecolor', colorList{i}, 'MarkerFaceAlpha', 0.95, 'HandleVisibility','off');
    end
end
legend(corelevel, 'location', 'eastoutside', 'FontSize', 9);
%% 3.1    :   FORMATTING: AXES AND GRID
% Grid setup (subtle, light gray)
grid on; grid minor; 
% Scale and limits
ax = gca;
% Axis appearance
ax.LineWidth = 1.0;
ax.FontName = 'Helvetica';
ax.FontSize = 11;
ax.XScale = 'linear'; ax.YScale = 'linear'; 
% Setting axes scale based on formalism
if strcmpi("Scofield(1973)", formalism)
    axis([0.9*1000, 1.1*10000, -1, 2.75]);
elseif strcmpi("YehLindau(1985)", formalism)
    axis([0, 1550, -1, 2.55]);
elseif strcmpi("Trzhaskovskaya(2018)", formalism)
    axis([0.9*1000, 1.1*10000, -1, 2.75]);
elseif strcmpi("Cant(2022)", formalism)
    axis([0.9*1000, 1.1*10000, -1, 2.75]);
end
%% 3.2    :   AXIS LABELS (on top of plot area)
yline(0, 'k-', 'LineWidth',1, 'HandleVisibility','off');
xlabel('Photon Energy [eV]', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Helvetica');
ylabel('\beta', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Helvetica');
%% 3.3    :   TEXT ANNOTATIONS (Using annotation objects for consistency)
% Title section (element and atomic number)
text(0.98, 0.96, sprintf('%s(Z=%.0f)', element, atomicNumber),...
        'FontSize', 12, 'FontName', 'Helvetica', 'EdgeColor', 'none',...
        'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle',...
        'Units','normalized', 'FontWeight', 'bold');
% Formalism (calculation method)
text(0.98, 0.92, sprintf("%s", formalism),...
        'FontSize', 9, 'FontName', 'Helvetica', 'EdgeColor', 'none',...
        'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle',...
        'Units','normalized');
%% 3.4    :   AXIS POSITIONING (bring to top)
ax.Layer = 'top';
ax.TickDir = "in";
end