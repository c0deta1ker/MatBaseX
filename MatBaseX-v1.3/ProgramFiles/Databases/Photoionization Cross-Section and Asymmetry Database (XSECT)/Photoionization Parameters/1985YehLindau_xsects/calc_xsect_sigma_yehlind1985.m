function xsect_sigma = calc_xsect_sigma_yehlind1985(hv, element, corelevel, extrapolate, plot_results)
% xsect_sigma = calc_xsect_sigma_yehlind1985(element, corelevel, hv, plot_results)
%   This is a function that calculates the atomic subshell photoionization 
%   cross sections with the Hartree-Fock-Slater one-electron central potential 
%   model (dipole approximation) for all elements Z = 1 - 103. The cross-section 
%   results are plotted for all subshells in the energy region 0 - 1500 eV,
%   and cross sections and asymmetry parameters are tabulated for selected energies in the region 10.2 -
%   8047.8 eV. These data should be particularly useful for work based on 
%   spectroscopic investigations of atomic subshells using synchrotron radiation
%   and/or discrete line sources. This is from the original work of J. J. Yeh 
%   and I. Lindau [1], which has now been digitised here for use in MATLAB.
%   [1] J.J. Yeh, I. Lindau. ATOMIC DATA AND NUCLEAR DATA TABLES 32, l-l 55 (1985). Web. doi:10.1016/0092-640X(85)90016-6
%
%   IN:
%   -   hv:             scalar or vector of the incident photon energies [eV]
%   -   element:    	string of the element; e.g. "H", "He", "Si", "In"...
%   -   corelevel:      string or vector of the core-levels to be probed; e.g. ["1s1", "2p1", "2p3", "3d3", "3d5", "5f5', "5f7"]
%   -   extrapolate:    either 0 or 1; if true, it will extrapolate sigma beyond the conventional range, otherwise not
%   -   plot_results:   if 1, will plot figure summary, otherwise it wont.
%
%   OUT:
%   -   xsect_sigma:    N×M vector of the photoionization cross-sections [barn/atom]

%% Default parameters
if nargin < 3; corelevel = [];  end
if nargin < 4; extrapolate = 0;  end
if nargin < 5; plot_results = 0;  end
if isempty(corelevel); corelevel = []; end
if isempty(extrapolate); extrapolate = 0; end
if isempty(plot_results); plot_results = 0; end
%% Disable warning back-trace
warning('off', 'backtrace');
%% Validity checks on the input parameters
element     = string(element);
corelevel   = string(corelevel);
%% 1 - Loading the MATLAB data structure
XS_DB_YehLind1985	= load('XS_DB_YehLind1985.mat'); XS_DB_YehLind1985 = XS_DB_YehLind1985.XS_DB_YehLind1985;
ATOM_SYMB   = XS_DB_YehLind1985.ATOM_SYMB;
HV          = XS_DB_YehLind1985.HV;
XSECT       = XS_DB_YehLind1985.XSECT_SIGMA;
%% 2 - Find the database index of the defined element
% - Extracting element database index
ele_indx 	= find(strcmpi(ATOM_SYMB, element), 1);
if isempty(ele_indx); msg = 'Element could not be identified. Only use atomic-symbols for elements 1 - 103; H, He, Li, Be..., No, Lr'; error(msg); end
% - Extracting  relevant tables
table_hv    = HV;
table_xs    = XSECT{ele_indx};
ATOM_CL     = string(table_xs.Properties.VariableNames);
%% 3 - Find the database index of the defined core-levels
% If no core-level is defined, use all available ones
if isempty(corelevel); cl_indx = 1:length(ATOM_CL); 
% Otherwise, parse the input
else
    % - If 1 core-level is entered
    if isscalar(corelevel)
        cl_indx 	= find(strcmpi(ATOM_CL, corelevel), 1);
        if isempty(cl_indx)
            cl_indx = 0; msg = sprintf("Core-level %s not found; NaN values returned.", corelevel); warning(msg); 
        end
    % - If a string array of core-levels is entered
    else
        cl_indx = zeros(size(corelevel));
        for i = 1:length(corelevel)
            ith_corelevel   = corelevel(i);
            idx             = find(ATOM_CL == ith_corelevel);
            % --- If the core-level is not found
            if ~isempty(idx);   cl_indx(i) = idx;
            else;               cl_indx(i) = 0;
                msg = sprintf("Core-level %s not found; NaN values returned.", corelevel(i)); warning(msg); 
            end
        end
    end
end
%% 4 - Extracting the relevant photoionization parameter
% - Extracting photon energies from database (ensure it is a column)
hv_data     = table_hv.(1); 
if size(hv_data, 2) > 1; hv_data = hv_data'; end
% - Extracting photoionization parameter from database
xsect_data = NaN(size(hv_data, 1), length(cl_indx));
cls = "";
for i = 1:length(cl_indx)
    if cl_indx(i) == 0
        cls(i)              = NaN(1);
        xsect_data(:,i)     = NaN(size(hv_data));
    else                 
        cls(i)              = ATOM_CL(cl_indx(i));
        xsect_data(:,i)     = table_xs.(cl_indx(i));
    end
end
%% 5 - Interpolating the cross section values from the database
ihv = hv; if size(ihv, 2) > 1; ihv = ihv'; end
cols_with_nan = all(isnan(xsect_data), 1);  % Identify columns that are all NaN
xsect_sigma = NaN(size(ihv, 1), length(cl_indx));
for i = 1:length(cols_with_nan)
    if cols_with_nan(i) == 1;       xsect_sigma(:,i) = NaN(size(ihv));
    else
        if extrapolate == 1;        xsect_sigma(:,i) = interp1(hv_data, xsect_data(:,i), ihv, 'pchip', 'extrap');
        elseif extrapolate == 0;    xsect_sigma(:,i) = interp1(hv_data, xsect_data(:,i), ihv, 'pchip', NaN);
        end
    end
end
%% Validity check on the outputs
% -- If no initial corelevel input was made, then remove all NaN entries
if isempty(corelevel)
    % Remove core-levels that are not identified
    NaN_idx                 = ismissing(cls);
    cls(NaN_idx)            = [];
    xsect_data(:,NaN_idx)   = [];
    xsect_sigma(:,NaN_idx)  = [];
    % Remove core-levels with full NaN data
    NaN_idx                 = all(isnan(xsect_data), 1);
    cls(NaN_idx)            = [];
    xsect_data(:,NaN_idx)   = [];
    xsect_sigma(:,NaN_idx)  = [];
% -- Otherwise, preserve the labels that were user-defined
else
    NaN_idx         = find(cl_indx == 0);
    cls(NaN_idx)    = corelevel(NaN_idx);
end
% -- Ensure that the photonionization parameter is consistent with the input hv value
if isrow(hv); if size(xsect_sigma, 2) ~= length(hv); xsect_sigma = xsect_sigma'; end
elseif iscolumn(hv); if size(xsect_sigma, 1) ~= length(hv); xsect_sigma = xsect_sigma'; end
end
% -- If the photoionization parameter is negative, make it NaN
xsect_sigma(xsect_sigma<0) = NaN;
%% Enable warning back-trace
warning('on', 'backtrace');
%% -- Plot for debugging
if plot_results == 1
    nCL         = length(cls);
    colorList   = read_be_core_levels_color(cls);
    % - Creating a figure
    fig = figure(); 
    fig.Position(1) = 100; fig.Position(2) = 100;
    fig.Position(3) = 700; 
    fig.Position(4) = 500;
    % - Creating a tiled axis
    t = tiledlayout(1,1);
    t.TileSpacing = 'compact';
    t.Padding = 'compact';
    % - Plot of SIGMA
    nexttile(); hold on; grid on; grid minor;
    for i = 1:nCL
        plot(hv_data, xsect_data(:,i),...
            'x-', 'markersize', 5, 'markeredgecolor', colorList{i},...
            'markerfacecolor', colorList{i}, 'color', colorList{i}); 
        if isscalar(hv);        scatter(hv, xsect_sigma(i), 'SizeData', 50, 'markeredgecolor', colorList{i}, 'markerfacecolor', colorList{i}, 'MarkerFaceAlpha', 0.95, 'HandleVisibility','off');
        elseif isrow(hv);       scatter(hv, xsect_sigma(i,:), 'SizeData', 50, 'markeredgecolor', colorList{i}, 'markerfacecolor', colorList{i}, 'MarkerFaceAlpha', 0.95, 'HandleVisibility','off');
        elseif iscolumn(hv);    scatter(hv, xsect_sigma(:,i), 'SizeData', 50, 'markeredgecolor', colorList{i}, 'markerfacecolor', colorList{i}, 'MarkerFaceAlpha', 0.95, 'HandleVisibility','off');
        end
    end
    % - Formatting the axis
    legend(cls, 'location', 'eastoutside', 'FontSize', 9);
    % - Labeling the x- and y-axes
    text(0.98, 0.96, sprintf("%s(Z=%i)", element, ele_indx),...
        'FontSize', 14, 'color', 'k', 'Units','normalized', 'FontWeight', 'bold', 'HorizontalAlignment','right');
    text(0.98, 0.91, sprintf("Yeh&Lindau(1985)"),...
        'FontSize', 8, 'color', 'k', 'Units','normalized', 'HorizontalAlignment','right');
    xlabel(' Photon Energy [eV] ', 'FontWeight','bold');
    ylabel(' \sigma [barn/atom] ', 'FontWeight','bold');
    ax = gca; ax.YScale = 'log'; ax.XScale = 'linear';
    % yline(0, 'k-', 'LineWidth',1, 'HandleVisibility','off');
    axis([0, 1550, 1e0, 1e8]);
end
end