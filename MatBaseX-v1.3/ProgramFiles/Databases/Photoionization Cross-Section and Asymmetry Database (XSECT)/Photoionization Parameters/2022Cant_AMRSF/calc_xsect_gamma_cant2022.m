function xsect_gamma = calc_xsect_gamma_cant2022(hv, element, corelevel, plot_results)
% xsect_gamma = calc_xsect_gamma_cant2022(hv, element, corelevel, plot_results)
%   This is a function that calculates the cross sections for photoionization 
%   from elements with Z from 3 to 98 and for photon energies from 1.5 to 10 keV. 
%   This is an empirical functions used to describe discrete theoretically 
%   calculated values for photoemission cross sections and asymmetry parameters
%   from the individual subshells are determined. This is from the original
%   work of David J. H. Cant [1], which has now been digitised here for use in
%   MATLAB.
%   [1] David J. H. Cant, Ben F. Spencer, Wendy R. Flavell, Alexander G. Shard. Surf Interface Anal. 2022; 54(4): 442-454. doi:10.1002/sia.7059
%
%   IN:
%   -   hv:             scalar or vector of the incident photon energies [eV]
%   -   element:    	string of the element; e.g. "H", "He", "Si", "In"...
%   -   corelevel:      string or vector of the core-levels to be probed; e.g. ["1s1", "2p1", "2p3", "3d3", "3d5", "5f5', "5f7"]
%   -   plot_results:   if 1, will plot figure summary, otherwise it wont.
%
%   OUT:
%   -   xsect_delta:     N×M vector of the photoelectron angular distribution asymmetry (non-dipole) parameter delta.

%% Default parameters
if nargin < 3; corelevel = [];  end
if nargin < 4; plot_results = 0;  end
if isempty(corelevel); corelevel = []; end
if isempty(plot_results); plot_results = 0; end
%% Disable warning back-trace
warning('off', 'backtrace');
%% Validity checks on the input parameters
hv          = sort(unique(hv)); 
element     = string(element);
corelevel   = string(corelevel);
%% 1 - Find the database index of the defined element
% - Extracting element database index
ATOM_SYMB   = read_mpd_elements();
ele_indx 	= find(strcmpi(ATOM_SYMB, element), 1);
if isempty(ele_indx); msg = 'Element could not be identified. Only use atomic-symbols for elements 1 - 100; H, He, Li, Be..., Es, Fm'; error(msg); end
ATOM_CL = {'1s1','2s1','3s1','4s1','5s1','2p1','2p3','3p1','3p3','4p1','4p3','5p1','5p3','3d3','3d5','4d3','4d5','5d3','5d5','4f5','4f7'};
%% 2 - Find the database index of the defined core-levels
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
cls = "";
for i = 1:length(cl_indx)
    if cl_indx(i) == 0; cls(i) = NaN(1);
    else;               cls(i) = ATOM_CL(cl_indx(i));
    end
end
%% 3 - Calculating photoionization parameter
%% 3.1 - Defining the table of coefficients
% -- Table of S core-level coefficients
T3_XSect_GammaS_Coeff = table();
T3_XSect_GammaS_Coeff.Shell = {'1s1';'2s1';'3s1';'4s1';'5s1'};
T3_XSect_GammaS_Coeff.a_gamma = [1.06E+00;2.31E+00;2.58E+00;1.22E+00;1.12E+00];
T3_XSect_GammaS_Coeff.b_gamma = [4.68E-01;4.23E-01;4.46E-01;3.39E-01;3.20E-01];
T3_XSect_GammaS_Coeff.m_gamma = [5.09E-01;2.21E-01;2.36E-01;1.18E-02;1.07E-02];
T3_XSect_GammaS_Coeff.n_gamma = [2.41E+00;3.40E+00;1.78E+00;2.84E+00;3.74E+00];
T3_XSect_GammaS_Coeff.q_gamma = [1.83E+00;3.06E+00;3.04E+00;-4.69E-01;-1.96E+00];
T3_XSect_GammaS_Coeff.r_gamma = [-4.71E-01;3.90E-03;3.90E-03;1.92E-03;9.29E-03];
T3_XSect_GammaS_Coeff.p_gamma = [2.54E+00;2.18E+00;1.16E+00;5.53E-01;4.33E-01];
T3_XSect_GammaS_Coeff.s_gamma = [1.62E-01;5.98E-01;3.27E-01;4.47E-03;-2.38E-04];
% -- Table of all other core-level coefficients
T3_XSect_Gamma_Coeff = table();
T3_XSect_Gamma_Coeff.Shell = {'2p1';'2p3';'3p1';'3p3';'4p1';'4p3';'5p1';'5p3'; '3d3';'3d5';'4d3';'4d5';'5d3';'5d5';'4f5';'4f7'};
T3_XSect_Gamma_Coeff.da_gamma = [1.42E-03;1.42E-03;2.79E-03;5.94E-03;1.71E-03;1.81E-03;1.94E-01;2.76E-01;4.45E-01;3.63E-01;8.61E+05;8.61E+05;7.98E-04;8.98E-04;8.38E+05;8.62E+05];
T3_XSect_Gamma_Coeff.ga_gamma = [-1.28E+00;-1.28E+00;5.93E-01;5.09E-01;6.35E-01;6.34E-01;1.66E-01;1.61E-01;-5.08E-01;-8.37E-01;-2.10E+00;-2.13E+00;8.64E-01;7.79E-01;-2.18E+00;-2.10E+00];
T3_XSect_Gamma_Coeff.dm_gamma = [6.23E-02;5.35E-02;1.24E-02;7.02E-03;3.64E-03;3.19E-03;3.52E-01;1.42E-01;1.35E-02;1.63E-02;2.40E-03;2.56E-03;1.23E-03;1.38E-03;3.19E-03;3.91E-03];
T3_XSect_Gamma_Coeff.gm_gamma = [3.60E-01;3.82E-01;4.53E-01;5.21E-01;5.83E-01;6.10E-01;9.49E-02;1.91E-01;5.14E-01;4.91E-01;6.67E-01;6.59E-01;8.14E-01;7.36E-01;6.31E-01;6.09E-01];
T3_XSect_Gamma_Coeff.du_gamma = [3.41E+01;3.12E+01;1.76E+02;2.07E+02;1.62E+02;1.22E+02;2.26E+01;2.81E+01;9.48E+01;9.61E+01;1.18E+02;1.12E+02;6.32E+01;8.99E+01;8.40E+01;8.54E+01];
T3_XSect_Gamma_Coeff.gu_gamma = [-2.34E-01;-2.27E-01;-3.91E-01;-4.13E-01;-3.96E-01;-3.82E-01;-1.92E-01;-2.24E-01;-3.70E-01;-3.83E-01;-3.90E-01;-3.97E-01;-4.01E-01;-4.33E-01;-3.91E-01;-3.95E-01];
T3_XSect_Gamma_Coeff.cw_gamma = [4.29E-01;4.41E-01;-2.29E-01;-1.33E-01;-6.99E-02;4.91E-01;1.36E+00;1.47E+00;6.04E+00;6.22E+00;5.81E+00;6.11E+00;1.91E+00;1.42E+00;5.89E+00;5.88E+00];
T3_XSect_Gamma_Coeff.dw_gamma = [-2.82E-05;-3.20E-05;1.11E-06;-1.46E-05;9.50E-06;-1.60E-05;-8.81E-05;-9.26E-05;-7.39E-06;-6.97E-06;-2.18E-06;-1.26E-05;2.52E-02;2.51E-02;-1.17E-05;-9.40E-06];
T3_XSect_Gamma_Coeff.n_gamma = [-8.11E-01;-8.89E-01;2.40E+00;9.20E-01;5.45E+00;4.38E+00;9.22E-01;6.96E-01;8.41E-01;5.72E-01;2.97E+00;2.80E+00;2.20E-01;2.32E-01;2.55E+00;3.10E+00];
T3_XSect_Gamma_Coeff.cr_gamma = [8.98E+02;6.79E+02;6.75E+01;8.18E+01;-1.12E+02;1.52E+01;1.51E+03;1.33E+03;2.48E+02;2.49E+02;-5.22E+02;-4.92E+02;1.23E+03;1.22E+03;-4.94E+02;-4.66E+02];
T3_XSect_Gamma_Coeff.dr_gamma = [3.15E-01;3.90E-01;1.45E-01;1.70E-01;2.71E-01;2.71E-01;-1.51E-01;-1.33E-01;4.21E-02;7.04E-03;6.04E-01;5.85E-01;-1.19E-01;-1.22E-01;7.87E-01;7.21E-01];
T3_XSect_Gamma_Coeff.p_gamma = [-2.06E-01;-2.08E-01;-2.90E+00;-1.63E+00;-7.62E+00;-5.61E+00;-2.96E+01;-3.85E+01;-2.50E-01;-8.86E-03;-7.01E+00;-6.82E+00;-1.07E-01;-1.05E-01;-7.43E+00;-5.67E+00];
T3_XSect_Gamma_Coeff.cs_gamma = [-3.60E+03;-3.55E+03;1.18E+02;7.67E+01;-3.01E+01;7.64E+01;1.30E+02;2.82E+01;3.45E+02;1.01E+02;-1.34E+02;-1.43E+02;-3.36E+01;-3.36E+01;-1.22E+02;-1.22E+02];
T3_XSect_Gamma_Coeff.ds_gamma = [2.40E+00;2.37E+00;3.73E-02;3.73E-02;1.74E-01;1.91E-01;1.09E-01;2.08E-01;-3.00E-02;-1.01E-02;2.42E-01;2.31E-01;4.08E-01;3.98E-01;3.14E-01;3.60E-01];
%% 3.1 - Calculating the non-dipole parameter, gamma
ihv = hv; if size(ihv, 2) > 1; ihv = ihv'; end
ixsect = NaN(size(ihv, 1), length(cl_indx));
for i = 1:length(cl_indx)
    temp_data = [];
    % -- If the binding energy does not exist, return NaN
    if cl_indx(i) == 0; temp_data = NaN(size(ihv));
    % -- Otherwise, calculate the xsect data
    else
        Ebe = calc_be(element, ATOM_CL{cl_indx(i)}); 
        if isempty(Ebe) || isnan(Ebe); temp_data = NaN(size(ihv));
        else
            % --- For all S core levels, user the Beta table of coefficients
            if cl_indx(i) < 6
                % --- Extract the coefficients
                a = T3_XSect_GammaS_Coeff.a_gamma(cl_indx(i));
                b = T3_XSect_GammaS_Coeff.b_gamma(cl_indx(i));
                m = T3_XSect_GammaS_Coeff.m_gamma(cl_indx(i));
                n = T3_XSect_GammaS_Coeff.n_gamma(cl_indx(i));
                q = T3_XSect_GammaS_Coeff.q_gamma(cl_indx(i));
                r = T3_XSect_GammaS_Coeff.r_gamma(cl_indx(i));
                p = T3_XSect_GammaS_Coeff.p_gamma(cl_indx(i));
                s = T3_XSect_GammaS_Coeff.s_gamma(cl_indx(i));
                % --- Calculate the equation constants
                Zadj = ele_indx ./ (a.*ihv.^b);
                % --- Calculate GAMMA
                temp_data = (m .* sin((n.*Zadj.^p + q)) + s .* Zadj.^p + r).*sqrt(ihv);
            else
                % --- Extract the coefficients
                da = T3_XSect_Gamma_Coeff.da_gamma(cl_indx(i)-5);
                ga = T3_XSect_Gamma_Coeff.ga_gamma(cl_indx(i)-5);
                dm = T3_XSect_Gamma_Coeff.dm_gamma(cl_indx(i)-5);
                gm = T3_XSect_Gamma_Coeff.gm_gamma(cl_indx(i)-5);
                du = T3_XSect_Gamma_Coeff.du_gamma(cl_indx(i)-5);
                gu = T3_XSect_Gamma_Coeff.gu_gamma(cl_indx(i)-5);
                cw = T3_XSect_Gamma_Coeff.cw_gamma(cl_indx(i)-5);
                dw  = T3_XSect_Gamma_Coeff.dw_gamma(cl_indx(i)-5);
                n  = T3_XSect_Gamma_Coeff.n_gamma(cl_indx(i)-5);
                cr = T3_XSect_Gamma_Coeff.cr_gamma(cl_indx(i)-5);
                dr = T3_XSect_Gamma_Coeff.dr_gamma(cl_indx(i)-5);
                p  = T3_XSect_Gamma_Coeff.p_gamma(cl_indx(i)-5);
                cs = T3_XSect_Gamma_Coeff.cs_gamma(cl_indx(i)-5);
                ds = T3_XSect_Gamma_Coeff.ds_gamma(cl_indx(i)-5);
                % --- Calculate the equation constants
                a_gamma = da.*(ihv).^ga;
                m_gamma = dm.*(ihv).^gm;
                u_gamma = du.*(ihv).^gu;
                w_gamma = cw + dw.*(ihv);
                n_gamma = n;
                Ek = ihv - Ebe;
                r_gamma = Ek ./ (cr + dr.*ihv);
                p_gamma = p;
                s_gamma = Ek ./ (cs + ds.*ihv);
                % --- Calculate GAMMA
                temp_data = a_gamma + m_gamma.*sin((u_gamma .* (ele_indx/100) + w_gamma)) + n_gamma .*exp(-1.*r_gamma) + p_gamma.*exp(-1.*(s_gamma));
            end
        end
        temp_data(ihv<Ebe) = NaN; 
    end
    ixsect(:,i) = temp_data;
end
%% Validity check on the outputs
% -- If no initial corelevel input was made, then remove all NaN entries
if isempty(corelevel)
    % Remove core-levels that are not identified
    NaN_idx                 = ismissing(cls);
    cls(NaN_idx)            = [];
    ixsect(:,NaN_idx)       = [];
    cl_indx(NaN_idx)        = [];
    % Remove core-levels with full NaN data
    [be_check, ~]                  = calc_be(element, ATOM_CL); 
    cls(isnan(be_check))           = [];
    ixsect(:,isnan(be_check))      = [];
% -- Otherwise, preserve the labels that were user-defined
else
    NaN_idx         = find(cl_indx == 0);
    cls(NaN_idx)    = corelevel(NaN_idx);
end
% -- Ensure that the photonionization parameter is consistent with the input hv value
xsect_gamma = ixsect;
if isrow(hv); if size(xsect_gamma, 2) ~= length(hv); xsect_gamma = xsect_gamma'; end
elseif iscolumn(hv); if size(xsect_gamma, 1) ~= length(hv); xsect_gamma = xsect_gamma'; end
end
%% Enable warning back-trace
warning('on', 'backtrace');
%% -- Plot for debugging
if plot_results == 1
    % -- Loading in Cant2022 Data
    XS_DB_Cant2022	= load('XS_DB_Cant2022.mat'); XS_DB_Cant2022 = XS_DB_Cant2022.XS_DB_Cant2022;
    table_hv    = XS_DB_Cant2022.HV;
    table_xs    = XS_DB_Cant2022.XSECT_GAMMA{ele_indx};
    hv_data     = table_hv.(1); if size(hv_data, 2) > 1; hv_data = hv_data'; end
    xsect_data  = NaN(size(hv_data, 1), length(cls));
    for i = 1:length(cls)
        idx = find(contains(ATOM_CL, cls(i), 'IgnoreCase',true), 1);
        if idx == 0;    xsect_data(:,i)     = NaN(size(hv_data));
        else;           xsect_data(:,i)     = table_xs.(ATOM_CL{idx});
        end
    end
    % -- Plotting Data
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
    text(0.98, 0.91, sprintf("Cant(2022)"),...
        'FontSize', 8, 'color', 'k', 'Units','normalized', 'HorizontalAlignment','right');
    xlabel(' Photon Energy [eV] ', 'FontWeight','bold');
    ylabel(' \gamma  ', 'FontWeight','bold');
    ax = gca; ax.YScale = 'linear'; ax.XScale = 'linear';
    yline(0, 'k-', 'LineWidth',1, 'HandleVisibility','off');
    axis([0.9*1000, 1.1*10000, -1, 2.75]);
end
end