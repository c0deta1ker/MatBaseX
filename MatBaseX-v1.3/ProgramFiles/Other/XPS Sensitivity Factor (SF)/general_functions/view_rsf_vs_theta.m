function fig = view_rsf_vs_theta(element, corelevel)
% fig = view_rsf(element, corelevel)
%   This is a function that plots the XPS relative sensitivity factor (RSF) 
%   for a given element and core-level as a function of emission angle (theta). 
%   The Yeh & Lindau (1985) formalism are used to calculate data in the soft X-ray
%   regime (100 - 1500 eV), whereas the Cant 2022 formalisms is used to
%   calculate data in the hard X-ray regime (1500 - 10000 eV). 
%
%   IN:
%   -   element:    	string of the element; e.g. "H", "He", "Si", "In"...
%   -   corelevel:      string or string vector of the core-level to be probed; e.g. ["1s1", "2p1", "2p3", "3d5", "5f5', "5f7"]
%
%   OUT: 
%   -   fig:            figure output

%% -- Default Parameters
if nargin < 2; corelevel = []; end
if isempty(corelevel); corelevel = []; end
%% -- Validity checks on the input parameters
element     = string(element);
corelevel   = string(corelevel);
%% 1 - Extracting element properties
mpd             = get_mpd_props(element);
ATOM_ZNUM       = mpd.atom_z;
% -- Extracting relevant core-levels
if isempty(corelevel);  [~, ATOM_CL]  = calc_be(element);
else;                   ATOM_CL = corelevel;
end
nCL             = length(ATOM_CL);
color_list      = read_be_core_levels_color(ATOM_CL);
%% 2 - Initializing Experimental parameters
theta    = 0:5:90; 
phi      = 0;
P        = 0.5;
hv       = 1000;
%% 3 - Extracting the Sensitivity Factor (SF)
SF_SX = {}; SF_HX = {};
for i = 1:nCL
    SF_SX{i}    = calc_rsf(element, element, ATOM_CL(i), hv, theta, phi, P, 'Y1985', 'jtp');
    SF_HX{i}    = calc_rsf(element, element, ATOM_CL(i), hv, theta, phi, P, 'C2022', 'jtp');
end
%% 4 - Plotting the Sensitivity Factor (SF)
% - Creating a figure
fig = figure(); 
fig.Position(1) = 100; fig.Position(2) = 100;
fig.Position(3) = 700; 
fig.Position(4) = 500;
% - Creating a tiled axis
t = tiledlayout(1,1);
t.TileSpacing = 'compact';
t.Padding = 'compact';
nexttile(); hold on; grid on; grid minor;
% - Extracting sensitivity factors
for i = 1:nCL
    plot(theta, SF_SX{i}, 'x--', 'markersize', 5, 'markeredgecolor', color_list{i}, 'markerfacecolor', color_list{i}, 'color', color_list{i}, 'HandleVisibility','off'); 
end
for i = 1:nCL
    plot(theta, SF_HX{i}, '.-', 'markersize', 5, 'markeredgecolor', color_list{i}, 'markerfacecolor', color_list{i}, 'color', color_list{i}); 
end
% - Adding text
text(0.98, 0.96, sprintf("%s (Z=%i)", element, ATOM_ZNUM),...
    'FontSize', 14, 'color', 'k', 'Units','normalized', 'FontWeight', 'bold', 'HorizontalAlignment','right');
text(0.98, 0.92, sprintf("hv = %i eV, phi = %i deg., P = %.2f", hv, phi, P),...
    'FontSize', 8, 'color', 'k', 'Units','normalized', 'HorizontalAlignment','right');
% - Formatting the axis
legend(ATOM_CL, 'location', 'eastoutside', 'FontSize', 9);
xlabel(' Theta [degree] ', 'FontWeight','bold');
ylabel(' Sensitivity Factor (SF) ', 'FontWeight','bold');
ax = gca; ax.YScale = 'log'; ax.XScale = 'linear';
axis([0, 90, 1e-5, 1e5]);
end