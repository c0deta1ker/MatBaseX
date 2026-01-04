function fig = plt_result_xasf(element, formalism, hv, f1, f2, hv_data, f1_data, f2_data)
% fig = plt_result_xasf(element, formalism, hv, f1, f2, hv_data, f1_data, f2_data)
%   Plot X-ray atomic scattering factors (f1 and f2) for a specified element
%   comparing theoretical data with calculated values.Generates a 2-panel figure 
%   showing f1 (coherent scattering, linear scale) and f2 (absorption, log scale) as 
%   functions of photon energy. Reference data are plotted as continuous lines, 
%   calculated values as scatter points. Element name and formalism are displayed on 
%   each panel.
%
%   IN:
%   -   element:    (string/char) Chemical element symbol (e.g., 'Au', 'Cu')
%   -   formalism:  (string) Calculation method/formalism used
%   -   hv:         (double, scalar or vector) Photon energy value(s) to highlight [eV]
%   -   f1:         (double, scalar or vector) f1 scattering factor value(s)
%   -   f2:         (double, scalar or vector) f2 absorption factor value(s)
%   -   hv_data:    (double, vector) Photon energy grid for reference data [eV]
%   -   f1_data:    (double, vector) f1 reference data points
%   -   f2_data:    (double, vector) f2 reference data points
%
%   OUT:
%   -   fig:        - (figure object) Handle to created figure

%% INPUT VALIDATION AND PREPARATION
element         = string(element);
elementData     = get_mpd_props(element);
atomicNumber    = elementData.atom_z;
%% 1    :   CREATE FIGURE AND AXIS
fig = figure('Name', sprintf('X-ray Atomic Scattering Factors (XASF) - %s (Z=%.0f)', element, atomicNumber));
fig.Position = [100, 100, 1200, 400];  % [left, bottom, width, height]
% Create tiled layout for clean spacing
t = tiledlayout(1,2);
t.TileSpacing = 'compact';
t.Padding = 'compact';
%% 2    :   PLOT DATA #1 (f1)
nexttile(); hold on;
plot(hv_data, f1_data, '.-', 'markersize', 4, 'markeredgecolor', 'b', 'markerfacecolor', 'b', 'color', 'b'); 
scatter(hv, f1, 'SizeData', 25, 'markeredgecolor', 'b', 'markerfacecolor', 'b', 'MarkerFaceAlpha', 0.95, 'HandleVisibility','off');
yline(0, 'k-', 'LineWidth', 1, 'HandleVisibility','off');
% - FORMATTING: AXES AND GRID
% Grid setup (subtle, light gray)
grid on; grid minor; 
% Scale and limits
ax = gca;
ax.YScale = 'linear'; ax.XScale = 'log';
xlim([5, 1e6]);
ymax    = max([f1_data(:); f1(:)]);
ymin    = min([f1_data(:); f1(:)]);
if ymin < -100; ymin = -100; end
pad     = 0.25 .* (ymax - ymin);
ylim([ymin - pad, ymax + pad]);
% Axis appearance
ax.LineWidth = 1.0;
ax.FontName = 'Helvetica';
ax.FontSize = 11;
ax.Layer = 'top';
ax.TickDir = "in";
% - AXIS LABELS (on top of plot area)
xlabel('Photon Energy [eV]', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Helvetica');
ylabel('f_1 [e/atom]', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Helvetica');
% - TEXT ANNOTATIONS (Using annotation objects for consistency)
legend('f_1 (coherent scattering)', 'location', 'southeast', 'FontSize', 8); 
% Title section (element and atomic number)
text(0.03, 0.96, sprintf('%s(Z=%.0f)', element, atomicNumber),...
        'FontSize', 12, 'FontName', 'Helvetica', 'EdgeColor', 'none',...
        'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle',...
        'Units','normalized', 'FontWeight', 'bold');
% Formalism (calculation method)
text(0.03, 0.91, sprintf("%s", formalism),...
        'FontSize', 9, 'FontName', 'Helvetica', 'EdgeColor', 'none',...
        'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle',...
        'Units','normalized');
%% 3    :   PLOT DATA #2 (f2)
nexttile(); hold on;
plot(hv_data, f2_data, '.-', 'markersize', 4, 'markeredgecolor', 'r', 'markerfacecolor', 'r', 'color', 'r'); 
scatter(hv, f2, 'SizeData', 25, 'markeredgecolor', 'r', 'markerfacecolor', 'r', 'MarkerFaceAlpha', 0.95, 'HandleVisibility','off');
yline(0, 'k-', 'LineWidth', 1, 'HandleVisibility','off');
% - FORMATTING: AXES AND GRID
% Grid setup (subtle, light gray)
grid on; grid minor; 
% Scale and limits
ax = gca;
ax.YScale = 'log'; ax.XScale = 'log';
xlim([5, 1e6]);
y_log = log10([f2_data(:); f2(:)]);
y_log(isinf(y_log)) = [];
y_min_log = min(real(y_log));
y_max_log = max(real(y_log));
span_log = y_max_log - y_min_log;
pad_log = 0.75 * span_log;
y_min_new_log = y_min_log - pad_log;
y_max_new_log = y_max_log + pad_log;
ylim([10^y_min_new_log, 10^y_max_new_log]);
% Axis appearance
ax.LineWidth = 1.0;
ax.FontName = 'Helvetica';
ax.FontSize = 11;
ax.Layer = 'top';
ax.TickDir = "in";
% - AXIS LABELS (on top of plot area)
xlabel('Photon Energy [eV]', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Helvetica');
ylabel('f_2 [e/atom]', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Helvetica');
% - TEXT ANNOTATIONS (Using annotation objects for consistency)
legend('f_2 (absorption)', 'location', 'southeast', 'FontSize', 8); 
% Title section (element and atomic number)
text(0.03, 0.96, sprintf('%s(Z=%.0f)', element, atomicNumber),...
        'FontSize', 12, 'FontName', 'Helvetica', 'EdgeColor', 'none',...
        'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle',...
        'Units','normalized', 'FontWeight', 'bold');
% Formalism (calculation method)
text(0.03, 0.91, sprintf("%s", formalism),...
        'FontSize', 9, 'FontName', 'Helvetica', 'EdgeColor', 'none',...
        'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle',...
        'Units','normalized');
end