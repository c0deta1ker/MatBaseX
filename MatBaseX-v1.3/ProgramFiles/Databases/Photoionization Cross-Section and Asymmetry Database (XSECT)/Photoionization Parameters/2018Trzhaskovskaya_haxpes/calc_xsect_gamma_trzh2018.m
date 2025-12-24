function xsect_gamma = calc_xsect_gamma_trzh2018(hv, element, corelevel, extrapolate, plot_results)
% xsect_gamma = calc_xsect_gamma_trzh2018(hv, element, corelevel, extrapolate, plot_results)
%   This is a function that calculates the cross sections for photoionization
%   for atomic subshells with binding energies lower than 1.5 keV of all elements with 1 ≤ Z ≤
%   100 in the photon energy range 1.5–10 keV. The calculations were performed in an effort to provide handy
%   theoretical data for experimental studies by hard X-ray photoelectron spectroscopy (HAXPES).
%   The relativistic treatment of atomic photoeffect and the Dirac–Fock method with proper consideration of
%   the electron exchange for computing the electron wave functions. The photoionization cross sections were
%   determined including all multipoles of the radiative field while the photoelectron angular distribution
%   parameters were obtained within the quadrupole approximation. The effect of the hole resulting in the
%   atomic subshell after photoionization was taken into account by the use of the frozen orbital model.
%   This is from the original work of M.B. Trzhaskovskaya and V.G. Yarzhemsky [1], 
%   which has now been digitised here for use in MATLAB.
%   [1] M.B. Trzhaskovskaya, V.G. Yarzhemsky. Atomic Data and Nuclear Data Tables 119 (2018) 99–174. Web. doi:10.1016/j.adt.2017.04.003
%
%   IN:
%   -   hv:             scalar or vector of the incident photon energies [eV]
%   -   element:    	string of the element; e.g. "H", "He", "Si", "In"...
%   -   corelevel:      string or vector of the core-levels to be probed; e.g. ["1s1", "2p1", "2p3", "3d3", "3d5", "5f5', "5f7"]
%   -   extrapolate:    either 0 or 1; if true, it will extrapolate sigma beyond the conventional range, otherwise not
%   -   plot_results:   if 1, will plot figure summary, otherwise it wont.
%
%   OUT:
%   -   xsect_gamma:    N×M vector of the photoelectron angular distribution asymmetry (non-dipole) parameter gamma.

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
XS_DB_Trzh2018	= load('XS_DB_Trzh2018.mat'); XS_DB_Trzh2018 = XS_DB_Trzh2018.XS_DB_Trzh2018;
ATOM_SYMB   = XS_DB_Trzh2018.ATOM_SYMB;
HV          = XS_DB_Trzh2018.HV;
XSECT       = XS_DB_Trzh2018.XSECT_GAMMA;
%% 2 - Find the database index of the defined element
% - Extracting element database index
ele_indx 	= find(strcmpi(ATOM_SYMB, element), 1);
if isempty(ele_indx); msg = 'Element could not be identified. Only use atomic-symbols for elements 1 - 100; H, He, Li, Be..., Es, Fm'; error(msg); end
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
xsect_gamma = NaN(size(ihv, 1), length(cl_indx));
for i = 1:length(cols_with_nan)
    if cols_with_nan(i) == 1;       xsect_gamma(:,i) = NaN(size(ihv));
    else
        if extrapolate == 1;        xsect_gamma(:,i) = interp1(hv_data, xsect_data(:,i), ihv, 'pchip', 'extrap');
        elseif extrapolate == 0;    xsect_gamma(:,i) = interp1(hv_data, xsect_data(:,i), ihv, 'pchip', NaN);
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
    xsect_gamma(:,NaN_idx)  = [];
    % Remove core-levels with full NaN data
    NaN_idx                 = all(isnan(xsect_data), 1);
    cls(NaN_idx)            = [];
    xsect_data(:,NaN_idx)   = [];
    xsect_gamma(:,NaN_idx)  = [];
% -- Otherwise, preserve the labels that were user-defined
else
    NaN_idx         = find(cl_indx == 0);
    cls(NaN_idx)    = corelevel(NaN_idx);
end
% -- Ensure that the photonionization parameter is consistent with the input hv value
if isrow(hv); if size(xsect_gamma, 2) ~= length(hv); xsect_gamma = xsect_gamma'; end
elseif iscolumn(hv); if size(xsect_gamma, 1) ~= length(hv); xsect_gamma = xsect_gamma'; end
end
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
        if isscalar(hv);        scatter(hv, xsect_gamma(i), 'SizeData', 50, 'markeredgecolor', colorList{i}, 'markerfacecolor', colorList{i}, 'MarkerFaceAlpha', 0.95, 'HandleVisibility','off');
        elseif isrow(hv);       scatter(hv, xsect_gamma(i,:), 'SizeData', 50, 'markeredgecolor', colorList{i}, 'markerfacecolor', colorList{i}, 'MarkerFaceAlpha', 0.95, 'HandleVisibility','off');
        elseif iscolumn(hv);    scatter(hv, xsect_gamma(:,i), 'SizeData', 50, 'markeredgecolor', colorList{i}, 'markerfacecolor', colorList{i}, 'MarkerFaceAlpha', 0.95, 'HandleVisibility','off');
        end
    end
    % - Formatting the axis
    legend(cls, 'location', 'eastoutside', 'FontSize', 9);
    % - Labeling the x- and y-axes
    text(0.98, 0.96, sprintf("%s(Z=%i)", element, ele_indx),...
        'FontSize', 14, 'color', 'k', 'Units','normalized', 'FontWeight', 'bold', 'HorizontalAlignment','right');
    text(0.98, 0.91, sprintf("Trzhaskovskaya(2018)"),...
        'FontSize', 8, 'color', 'k', 'Units','normalized', 'HorizontalAlignment','right');
    xlabel(' Photon Energy [eV] ', 'FontWeight','bold');
    ylabel(' \gamma  ', 'FontWeight','bold');
    ax = gca; ax.YScale = 'linear'; ax.XScale = 'linear';
    yline(0, 'k-', 'LineWidth',1, 'HandleVisibility','off');
    axis([0.9*1000, 1.1*10000, -1, 2.75]);
end
end