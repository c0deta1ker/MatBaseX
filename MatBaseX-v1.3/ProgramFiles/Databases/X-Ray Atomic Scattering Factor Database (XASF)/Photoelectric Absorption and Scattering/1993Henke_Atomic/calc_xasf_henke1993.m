function [f1, f2] = calc_xasf_henke1993(hv, element, extrapolate, plot_results)
% [f1, f2] = calc_xray_ff_henke1993(hv, element, extrapolate, plot_results)
%   This is a function that calculates the atomic scattering factors for
%   all elements with 1 ≤ Z ≤ 92 in the photon energy range 50 - 30,000 eV. 
%   This is from the original work of B.L.Henke [1] which has now been 
%   digitised here for use in MATLAB.
%   [1] B.L. Henke, E.M. Gullikson, J.C. Davis, X-Ray Interactions: Photoabsorption, Scattering, Transmission, and 
%       Reflection at E = 50-30,000 eV, Z = 1-92, Atomic Data and Nuclear Data Tables, 
%       181-342, 54 (2), 1993, https://doi.org/10.1006/adnd.1993.1013.
%
%   IN:
%   -   hv:             scalar or vector of the incident photon energies [eV]
%   -   element:    	string of the element; e.g. "H", "He", "Si", "In"...
%   -   extrapolate:    either 0 or 1; if true, it will extrapolate sigma beyond the conventional range, otherwise not
%   -   plot_results:   if 1, will plot figure summary, otherwise it wont.
%
%   OUT:
%   -   f1:             scalar or vector of the real part of atomic scattering factor (coherent scattering)
%   -   f2:             scalar or vector of the imaginary part of atomic scattering factor (absorption)

%% Default parameters
if nargin < 3; extrapolate = 0;  end
if nargin < 4; plot_results = 0;  end
if isempty(extrapolate); extrapolate = 0; end
if isempty(plot_results); plot_results = 0; end
%% Validity checks on the input parameters
element     = string(element);
%% 1 - Loading the MATLAB data structure
XASF_DB_Henke1993	= load('XASF_DB_Henke1993.mat'); XASF_DB_Henke1993 = XASF_DB_Henke1993.XASF_DB_Henke1993;
ATOM_SYMB   = XASF_DB_Henke1993.ATOM_SYMB;
%% 2 - Find the database index of the defined element
% - Extracting element database index
ele_indx 	= find(strcmpi(ATOM_SYMB, element), 1);
if isempty(ele_indx); msg = 'Element could not be identified. Only use atomic-symbols for elements 1 - 92; H, He, Li, Be..., Pa, U'; error(msg); end
% - Extracting  relevant tables
hv_data    = XASF_DB_Henke1993.HV{ele_indx};
f1_data    = XASF_DB_Henke1993.F1{ele_indx};
f2_data    = XASF_DB_Henke1993.F2{ele_indx};
% - Ensure they are all columns
if isrow(hv_data); hv_data = hv_data'; end
if isrow(f1_data); f1_data = f1_data'; end
if isrow(f2_data); f2_data = f2_data'; end
%% 3 - Interpolating the cross section values from the database
ihv = hv; if size(ihv, 2) > 1; ihv = ihv'; end
if extrapolate == 1      
    if1 = interp1(hv_data, f1_data, ihv, 'pchip', 'extrap');
    if2 = interp1(hv_data, f2_data, ihv, 'pchip', 'extrap');
elseif extrapolate == 0   
    if1 = interp1(hv_data, f1_data, ihv, 'pchip', NaN);
    if2 = interp1(hv_data, f2_data, ihv, 'pchip', NaN);
end
%% Validity check on the outputs
% -- Ensure that the output values are consistent with the input hv value
if isrow(hv); if size(if1, 2) ~= length(hv); if1 = if1'; end
elseif iscolumn(hv); if size(if1, 1) ~= length(hv); if1 = if1'; end
end
if isrow(hv); if size(if2, 2) ~= length(hv); if2 = if2'; end
elseif iscolumn(hv); if size(if2, 1) ~= length(hv); if2 = if2'; end
end
% -- Assingning final outputs
f1 = if1;
f2 = if2;
%% -- Plot for debugging
if plot_results == 1
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
    plot(hv_data, f1_data, '.-', 'markersize', 4, 'markeredgecolor', 'b', 'markerfacecolor', 'b', 'color', 'b'); 
    scatter(hv, f1, 'SizeData', 50, 'markeredgecolor', 'b', 'markerfacecolor', 'b', 'MarkerFaceAlpha', 0.95, 'HandleVisibility','off');
    % - Formatting the axis
    lgnd_txt = {'f_1 (coherent scattering)'};
    legend(lgnd_txt, 'location', 'southeast', 'FontSize', 9);
    text(0.02, 0.96, sprintf("%s (Z=%i)", element, ele_indx),...
        'FontSize', 14, 'color', 'k', 'Units','normalized', 'FontWeight', 'bold', 'HorizontalAlignment','left');
    text(0.02, 0.90, sprintf("Henke(1993)"),...
        'FontSize', 8, 'color', 'k', 'Units','normalized', 'HorizontalAlignment','left');
    xlabel(' Photon Energy [eV] ', 'FontWeight','bold');
    ylabel(' f_1 [e/atom] ', 'FontWeight','bold');
    ax = gca; ax.YScale = 'linear'; ax.XScale = 'log';
    if ele_indx < 14;       axis([5, 1e5, -20, 20]);
    elseif ele_indx < 29;   axis([5, 1e5, -40, 40]);
    else;                   axis([5, 1e5, -100, 100]);
    end
    yline(0, 'k-', 'LineWidth',1, 'HandleVisibility','off');
    % - f2
    nexttile(); hold on; grid on; grid minor;
    plot(hv_data, f2_data, '.-', 'markersize', 4, 'markeredgecolor', 'r', 'markerfacecolor', 'r', 'color', 'r'); 
    scatter(hv, f2, 'SizeData', 50, 'markeredgecolor', 'r', 'markerfacecolor', 'r', 'MarkerFaceAlpha', 0.95, 'HandleVisibility','off');
    % - Formatting the axis
    lgnd_txt = {'f_2 (absorption)'};
    legend(lgnd_txt, 'location', 'southwest', 'FontSize', 9);
    text(0.02, 0.96, sprintf("%s (Z=%i)", element, ele_indx),...
        'FontSize', 14, 'color', 'k', 'Units','normalized', 'FontWeight', 'bold', 'HorizontalAlignment','left');
    text(0.02, 0.90, sprintf("Henke(1993)"),...
        'FontSize', 8, 'color', 'k', 'Units','normalized', 'HorizontalAlignment','left');
    xlabel(' Photon Energy [eV] ', 'FontWeight','bold');
    ylabel(' f_2 [e/atom] ', 'FontWeight','bold');
    ax = gca; ax.YScale = 'log'; ax.XScale = 'log';
    if ele_indx < 14;   axis([5, 1e5, 1e-7, 1e3]);
    else;               axis([5, 1e5, 1e-2, 1e3]);
    end
end
end