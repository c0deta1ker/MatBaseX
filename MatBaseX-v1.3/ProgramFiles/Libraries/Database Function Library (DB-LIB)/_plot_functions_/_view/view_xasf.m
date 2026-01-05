function [fig, ffData] = view_xasf(formula)
% [fig, ffData] = view_xasf(formula)
%   This function plots the X-ray atomic scattering factors f1 and f2 
%   versus photon energy (hv). If the input formula is an element, it interpolates 
%   directly fro teh database, however, if it is a compound,
%   the function computes the linear combination of the ratios scaled by 
%   the element scattering factors.
%
%   IN:
%   -   formula:        char/string of the material; e.g. "H", "Si", "SiO2", "Al2O3"...
%
%   OUT: 
%   -   fig:            figure output
%   -   ffData:         data structure containing all of the data within the figure plot

%% Validity checks on the input parameters
formula     = string(formula);
ele_indx    = calc_average_z_number(formula);
%% 1 - Calculating the XASF data
ffData = struct();
ffData.formalisms   = {"NIST2005","Henke1993"};
ffData.element      = formula;
ffData.avg_Z        = calc_average_z_number(formula);
ffData.hv           = logspace(1,6,5e3);
for i = 1:length(ffData.formalisms)
    [ffData.f1{i}, ffData.f2{i}] =...
        calc_xasf(ffData.hv, ffData.element, ffData.formalisms{i});
end
%% 2 - Plotting the data
%% 2.1    :   Create Figure & Axis
fig = figure('Name', sprintf('X-Ray Atomic Scattering Factors - %s (Z=%.1f)', formula, ffData.avg_Z));
fig.Position = [100, 100, 1200, 400];  % [left, bottom, width, height]
% Create tiled layout for clean spacing
t = tiledlayout(1,2);
t.TileSpacing = 'compact';
t.Padding = 'compact';
%% 2.2    :   PLOT DATA #1 (f1)
nexttile(); hold on; grid on; grid minor;
plot(ffData.hv, ffData.f1{1}, '-', 'linewidth', 1.5, 'color', 'k'); 
plot(ffData.hv, ffData.f1{2}, ':', 'linewidth', 2, 'color', 'r'); 
yline(0, 'k-', 'LineWidth', 1, 'HandleVisibility','off');
% - FORMATTING: AXES AND GRID
% Scale and limits
ax = gca;
ax.YScale = 'linear'; ax.XScale = 'log';
xlim([5, 1e6]);
ymax    = max([ffData.f1{1}(:); ffData.f1{2}(:)]);
ymin    = min([ffData.f1{1}(:); ffData.f1{2}(:)]);
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
legend(ffData.formalisms, 'location', 'southeast', 'FontSize', 9);
% Title section (element and atomic number)
text(0.03, 0.96, sprintf('%s(Z=%.1f)', formula, ffData.avg_Z),...
        'FontSize', 12, 'FontName', 'Helvetica', 'EdgeColor', 'none',...
        'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle',...
        'Units','normalized', 'FontWeight', 'bold');
%% 2.3    :   PLOT DATA #2 (f2)
nexttile(); hold on; grid on; grid minor;
plot(ffData.hv, ffData.f2{1}, '-', 'linewidth', 1.5, 'color', 'k'); 
plot(ffData.hv, ffData.f2{2}, ':', 'linewidth', 2, 'color', 'r');  
yline(0, 'k-', 'LineWidth', 1, 'HandleVisibility','off');
% - FORMATTING: AXES AND GRID
% Scale and limits
ax = gca;
ax.YScale = 'log'; ax.XScale = 'log';
xlim([5, 1e6]);
y_log = log10([ffData.f2{1}(:); ffData.f2{2}(:)]);
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
legend(ffData.formalisms, 'location', 'southwest', 'FontSize', 9);
% Title section (element and atomic number)
text(0.03, 0.96, sprintf('%s(Z=%.1f)', formula, ffData.avg_Z),...
        'FontSize', 12, 'FontName', 'Helvetica', 'EdgeColor', 'none',...
        'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle',...
        'Units','normalized', 'FontWeight', 'bold');

end