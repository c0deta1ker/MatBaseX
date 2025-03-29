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
ffData.hv           = logspace(1,6,5e3);
for i = 1:length(ffData.formalisms)
    [ffData.f1{i}, ffData.f2{i}] =...
        calc_xasf(ffData.hv, ffData.element, ffData.formalisms{i});
end
%% 2 - Plotting a summary 
pad = 0.50;
% - Creating a figure
fig = figure(); 
fig.Position(1) = 100; fig.Position(2) = 100;
fig.Position(3) = 1000; 
fig.Position(4) = 350;
% - Creating a tiled axis
t = tiledlayout(1,2);
t.TileSpacing = 'compact';
t.Padding = 'compact';
% - f1
nexttile(); hold on; grid on; grid minor;
plot(ffData.hv, ffData.f1{1}, '-', 'linewidth', 1.5, 'color', 'k'); 
plot(ffData.hv, ffData.f1{2}, ':', 'linewidth', 2, 'color', 'r'); 
% - Formatting the axis
legend(ffData.formalisms, 'location', 'southeast', 'FontSize', 9);
text(0.02, 0.96, sprintf("%s", formula),...
    'FontSize', 14, 'color', 'k', 'Units','normalized', 'FontWeight', 'bold', 'HorizontalAlignment','left');
xlabel(' Photon Energy [eV] ', 'FontWeight','bold');
ylabel(' f_1 [e/atom] ', 'FontWeight','bold');
ax = gca; ax.YScale = 'linear'; ax.XScale = 'log';
yline(0, 'k-', 'LineWidth',1, 'HandleVisibility','off');
if ele_indx < 14;       axis([5, 1e5, -20, 20]);
elseif ele_indx < 29;   axis([5, 1e5, -40, 40]);
else;                   axis([5, 1e5, -100, 100]);
end
% - f2
nexttile(); hold on; grid on; grid minor;
plot(ffData.hv, ffData.f2{1}, '-', 'linewidth', 1.5, 'color', 'k'); 
plot(ffData.hv, ffData.f2{2}, ':', 'linewidth', 2, 'color', 'r');  
% - Formatting the axis
legend(ffData.formalisms, 'location', 'southwest', 'FontSize', 9);
text(0.02, 0.96, sprintf("%s", formula),...
    'FontSize', 14, 'color', 'k', 'Units','normalized', 'FontWeight', 'bold', 'HorizontalAlignment','left');
xlabel(' Photon Energy [eV] ', 'FontWeight','bold');
ylabel(' f_2 [e/atom] ', 'FontWeight','bold');
ax = gca; ax.YScale = 'log'; ax.XScale = 'log';
if ele_indx < 14;   axis([5, 1e5, 1e-7, 1e3]);
else;               axis([5, 1e5, 1e-2, 1e3]);
end
end