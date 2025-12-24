function xsect_delta = calc_xsect_delta_cant2022(hv, element, corelevel, plot_results)
% xsect_delta = calc_xsect_delta_cant2022(hv, element, corelevel, plot_results)
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
T4_XSect_Delta_Coeff = table();
T4_XSect_Delta_Coeff.Shell = {'1s1';'2s1';'3s1';'4s1';'5s1'; '2p1';'2p3';'3p1';'3p3';'4p1';'4p3';'5p1';'5p3'; '3d3';'3d5';'4d3';'4d5';'5d3';'5d5';'4f5';'4f7'};
T4_XSect_Delta_Coeff.ca_delta = [0.00E+00;0.00E+00;0.00E+00;0.00E+00;0.00E+00;5.50E-02;7.74E-03;4.17E-02;3.45E-03;4.18E-03;1.06E-02;3.49E-03;3.39E-03;5.74E-02;1.49E-01;2.85E-02;2.11E-02;1.74E-02;1.99E-02;6.41E-02;7.30E-02];
T4_XSect_Delta_Coeff.da_delta = [0.00E+00;0.00E+00;0.00E+00;0.00E+00;0.00E+00;4.27E-02;3.00E-02;1.86E-02;6.14E-03;-1.94E-03;-5.02E-03;-5.39E-03;6.73E-04;4.07E-02;7.38E-02;2.06E-02;1.13E-02;3.28E-02;4.55E-03;1.20E-02;1.18E-02];
T4_XSect_Delta_Coeff.cm_delta = [0.00E+00;0.00E+00;0.00E+00;0.00E+00;0.00E+00;2.03E-01;9.23E-03;1.34E-01;3.40E-02;2.44E-02;4.59E-02;1.51E-02;1.94E-02;7.16E-02;2.73E-01;7.84E-02;8.40E-02;6.01E-02;6.37E-02;5.80E-02;7.41E-02];
T4_XSect_Delta_Coeff.dm_delta = [0.00E+00;0.00E+00;0.00E+00;0.00E+00;0.00E+00;-2.85E-03;2.06E-03;-3.37E-03;-5.28E-03;-2.91E-03;-1.09E-02;-4.56E-03;-5.45E-03;-5.17E-03;-7.57E-03;-1.28E-02;-1.90E-02;-1.03E-02;-1.28E-02;-2.89E-02;-2.90E-02];
T4_XSect_Delta_Coeff.cn_delta = [-3.32E+16;-1.86E-03;-8.97E-04;-2.30E-02;-1.47E-02;-2.35E-03;5.40E-03;-1.70E-02;-4.82E-03;-5.72E-03;-5.26E-03;-4.88E-03;-4.82E-03;-1.54E-02;-4.74E-02;2.57E-03;2.06E-02;2.19E-02;1.89E-02;4.26E-02;4.07E-02];
T4_XSect_Delta_Coeff.dn_delta = [-2.38E+17;4.90E-06;-3.96E-04;-7.55E-03;-9.97E-03;1.35E-02;1.53E-02;1.76E-02;1.91E-02;1.93E-02;2.27E-02;2.18E-02;1.84E-02;3.32E-02;2.20E-02;3.91E-02;4.02E-02;5.70E-02;4.95E-02;1.18E-01;1.17E-01];
T4_XSect_Delta_Coeff.q_delta = [1.04E+00;8.67E-01;1.05E+00;1.82E+00;1.85E+00;-2.76E-02;-3.29E-03;8.29E-03;2.28E-02;1.94E-02;2.15E-02;2.28E-02;2.26E-02;7.46E-02;1.02E-01;7.54E-02;6.83E-02;8.45E-02;6.87E-02;-1.62E-01;-1.65E-01];
T4_XSect_Delta_Coeff.cs_delta = [9.04E-02;2.11E-01;3.04E-01;5.20E-01;5.29E-01;8.30E-02;1.03E-01;1.14E-01;1.67E-01;1.66E-01;1.83E-01;1.66E-01;1.29E-01;2.12E-01;1.02E-01;3.22E-01;3.55E-01;2.72E-01;3.68E-01;5.89E-01;6.00E-01];
T4_XSect_Delta_Coeff.ds_delta = [-1.90E-03;-3.30E-03;-1.01E-02;-1.11E-02;-1.20E-02;1.38E-02;1.10E-02;1.42E-02;7.07E-03;1.73E-02;5.48E-03;1.36E-02;6.38E-03;1.02E-02;1.90E-02;1.04E-03;2.38E-03;2.06E-03;3.12E-03;-5.41E-03;-5.79E-03];
T4_XSect_Delta_Coeff.cp_delta = [-3.27E-02;-1.43E-02;-3.27E-02;1.08E-02;1.28E-02;7.42E-02;4.91E-01;-1.78E-01;-2.18E-02;-1.56E-02;-3.16E-03;-1.90E-02;-2.21E-02;3.87E-02;4.16E-02;-7.10E-03;-7.11E-03;-7.09E-03;-7.05E-03;-1.14E-02;-1.13E-02];
T4_XSect_Delta_Coeff.dp_delta = [2.99E-02;1.12E-02;2.99E-02;2.32E-02;2.85E-02;-5.20E-02;-3.83E-01;2.87E-01;1.53E-01;2.37E-01;2.24E-01;5.35E-02;6.23E-02;-5.82E-02;-4.05E-02;2.26E-01;2.33E-01;2.96E-01;2.90E-01;-5.30E-02;-5.22E-02];
T4_XSect_Delta_Coeff.gp_delta = [-1.93E-03;-9.10E-04;-1.93E-03;-2.18E-03;-2.76E-03;4.01E-03;2.90E-02;-2.66E-02;-2.08E-02;-4.82E-02;-4.98E-02;-2.58E-02;-2.30E-02;4.69E-03;2.79E-03;-6.00E-02;-7.79E-02;-1.68E-01;-6.76E-02;-6.79E-02;-5.62E-02];
T4_XSect_Delta_Coeff.ct_delta = [9.13E-01;2.64E-01;5.18E-01;9.40E-01;1.07E+00;2.49E-01;2.66E-01;4.94E-01;5.00E-01;8.23E-01;8.65E-01;7.81E-01;8.46E-01;5.13E-01;4.97E-01;8.66E-01;9.01E-01;8.40E-01;1.08E+00;1.07E+00;1.08E+00];
T4_XSect_Delta_Coeff.dt_delta = [4.35E-01;1.88E-01;2.54E-01;1.75E-01;1.56E-01;1.90E-01;2.16E-01;2.72E-01;2.89E-01;2.77E-01;3.49E-01;3.08E-01;3.41E-01;2.92E-01;3.07E-01;3.47E-01;3.17E-01;7.18E-01;3.01E-01;3.62E-01;2.92E-01];
T4_XSect_Delta_Coeff.u_delta = [4.00E-09;8.73E-03;1.60E-02;7.13E-02;7.37E-02;2.21E-02;2.05E-02;3.23E-02;3.20E-02;5.02E-02;8.22E-02;6.88E-02;5.85E-02;5.77E-02;4.33E-02;5.43E-02;6.97E-02;7.79E-02;5.70E-02;1.07E-01;9.21E-02];
%% 3.2 - Calculating the non-dipole parameter, delta
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
            % --- Extract Coefficients
            ca = T4_XSect_Delta_Coeff.ca_delta(cl_indx(i));
            da = T4_XSect_Delta_Coeff.da_delta(cl_indx(i));
            cm = T4_XSect_Delta_Coeff.cm_delta(cl_indx(i));
            dm = T4_XSect_Delta_Coeff.dm_delta(cl_indx(i));
            cn = T4_XSect_Delta_Coeff.cn_delta(cl_indx(i));
            dn = T4_XSect_Delta_Coeff.dn_delta(cl_indx(i));
            q  = T4_XSect_Delta_Coeff.q_delta(cl_indx(i));
            cs = T4_XSect_Delta_Coeff.cs_delta(cl_indx(i));
            ds = T4_XSect_Delta_Coeff.ds_delta(cl_indx(i));
            cp = T4_XSect_Delta_Coeff.cp_delta(cl_indx(i));
            dp = T4_XSect_Delta_Coeff.dp_delta(cl_indx(i));
            gp = T4_XSect_Delta_Coeff.gp_delta(cl_indx(i));
            ct = T4_XSect_Delta_Coeff.ct_delta(cl_indx(i));
            dt = T4_XSect_Delta_Coeff.dt_delta(cl_indx(i));
            u  = T4_XSect_Delta_Coeff.u_delta(cl_indx(i));
            % --- Calculate the equation constants
            a_delta = ca + da.*log(ihv./1000);
            m_delta = cm + dm.*(ihv./1000);
            n_delta = cn + dn.*(ihv./1000);
            q_delta = q;
            s_delta = cs + ds.*(ihv./1000);
            p_delta = cp + dp.*(ihv./1000) + gp.*(ihv./1000).^2;
            t_delta = ct + dt.*log(ihv./1000);
            u_delta = u;
            % --- Calculate Delta
            temp_data = a_delta - m_delta.*(ele_indx./100) + n_delta.*((exp(-1.*((ele_indx./100 - q_delta).^2 ./ (2*s_delta.^2)))) ./ (sqrt(2*pi).*s_delta)) + p_delta./(1 + ((ele_indx/100 - t_delta) ./ u_delta).^2);
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
    % Remove core-levels with no binding energy
    [be_check, ~]                  = calc_be(element, ATOM_CL); 
    cls(isnan(be_check))           = [];
    ixsect(:,isnan(be_check))      = [];
% -- Otherwise, preserve the labels that were user-defined
else
    NaN_idx         = find(cl_indx == 0);
    cls(NaN_idx)    = corelevel(NaN_idx);
end
% -- Ensure that the photonionization parameter is consistent with the input hv value
xsect_delta = ixsect;
if isrow(hv); if size(xsect_delta, 2) ~= length(hv); xsect_delta = xsect_delta'; end
elseif iscolumn(hv); if size(xsect_delta, 1) ~= length(hv); xsect_delta = xsect_delta'; end
end
%% Enable warning back-trace
warning('on', 'backtrace');
%% -- Plot for debugging
if plot_results == 1
    % -- Loading in Cant2022 Data
    XS_DB_Cant2022	= load('XS_DB_Cant2022.mat'); XS_DB_Cant2022 = XS_DB_Cant2022.XS_DB_Cant2022;
    table_hv    = XS_DB_Cant2022.HV;
    table_xs    = XS_DB_Cant2022.XSECT_DELTA{ele_indx};
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
        if isscalar(hv);        scatter(hv, xsect_delta(i), 'SizeData', 50, 'markeredgecolor', colorList{i}, 'markerfacecolor', colorList{i}, 'MarkerFaceAlpha', 0.95, 'HandleVisibility','off');
        elseif isrow(hv);       scatter(hv, xsect_delta(i,:), 'SizeData', 50, 'markeredgecolor', colorList{i}, 'markerfacecolor', colorList{i}, 'MarkerFaceAlpha', 0.95, 'HandleVisibility','off');
        elseif iscolumn(hv);    scatter(hv, xsect_delta(:,i), 'SizeData', 50, 'markeredgecolor', colorList{i}, 'markerfacecolor', colorList{i}, 'MarkerFaceAlpha', 0.95, 'HandleVisibility','off');
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
    ylabel(' \delta  ', 'FontWeight','bold');
    ax = gca; ax.YScale = 'linear'; ax.XScale = 'linear';
    yline(0, 'k-', 'LineWidth',1, 'HandleVisibility','off');
    axis([0.9*1000, 1.1*10000, 0.0, 0.55]);
end
end