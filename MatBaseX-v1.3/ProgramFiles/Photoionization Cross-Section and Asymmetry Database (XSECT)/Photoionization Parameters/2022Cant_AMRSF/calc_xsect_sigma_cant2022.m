function xsect_sigma = calc_xsect_sigma_cant2022(hv, element, corelevel, plot_results)
% xsect_sigma = calc_xsect_sigma_cant2022(hv, element, corelevel, plot_results)
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
%   -   xsect_sigma:    N×M vector of the photoionization cross-sections [barn/atom]

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
ATOM_CL = {'1s1','2s1','3s1','4s1','5s1','2p1','2p3','3p1','3p3','4p1','4p3','5p1','5p3','3d3','3d5','4d3','4d5','4f5','4f7'};
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
T1_XSect_Sigma_Coeff = table();
T1_XSect_Sigma_Coeff.Shell = {'1s1';'2s1';'3s1';'4s1';'5s1'; '2p1';'2p3';'3p1';'3p3';'4p1';'4p3';'5p1';'5p3'; '3d3';'3d5';'4d3';'4d5';'4f5';'4f7'};
T1_XSect_Sigma_Coeff.a_sig = [-1.63E-10;-2.66E-11;2.76E-12;-1.02E-13;9.46E-14;-1.27E-08;-2.87E-08;9.83E-10;5.22E-09;-1.02E-10;-1.05E-10;7.97E-14;-6.01E-13;-2.10E-06;-3.90E-06;1.29E-06;1.78E-06;-3.48E-05;-4.39E-05];
T1_XSect_Sigma_Coeff.m_sig = [1.07E-10;4.30E-12;-1.61E-14;4.61E-15;-9.44E-16;1.70E-09;3.76E-09;7.18E-11;6.28E-11;3.69E-12;2.89E-12;3.79E-15;2.91E-14;8.48E-08;1.56E-07;-8.41E-09;-1.08E-08;1.20E-06;1.52E-06];
T1_XSect_Sigma_Coeff.b_sig = [2.42E+02;9.08E+01;6.42E+02;1.26E+03;8.87E+02;2.74E+02;1.91E+02;8.73E+02;3.51E+02;3.08E+03;-1.64E+02;1.29E+03;2.30E+03;9.90E+01;5.37E+01;2.70E+02;3.36E+02;1.01E+02;1.01E+02];
T1_XSect_Sigma_Coeff.n_sig = [-1.14E+01;1.07E+01;-1.48E+01;-3.90E+01;-5.51E+00;-3.46E+00;4.87E+00;-3.31E+01;5.98E-01;-1.03E+02;1.20E+01;-3.33E+01;-3.96E+01;5.18E+00;8.05E+00;5.20E-02;5.21E-02;3.79E+00;3.74E+00];
T1_XSect_Sigma_Coeff.p_sig = [1.17E+00;8.79E-01;6.05E-01;6.61E-01;-4.97E-02;6.46E-01;4.61E-01;9.51E-01;5.94E-01;1.10E+00;3.08E-01;6.30E-01;5.13E-01;3.36E-01;2.70E-01;4.84E-01;4.52E-01;2.23E-01;2.16E-01];
T1_XSect_Sigma_Coeff.q_sig = [-2.37E+00;-2.28E+00;-1.82E+00;-1.97E+00;-1.49E+00;-2.42E+00;-2.64E+00;-2.70E+00;-2.52E+00;2.10E-01;7.94E-01;-1.97E+00;-2.01E+00;-2.96E+00;-3.05E+00;-1.84E+00;-1.68E+00;-4.09E+00;-4.09E+00];
T1_XSect_Sigma_Coeff.r_sig = [-2.63E+00;-2.14E+00;-1.76E+00;-1.43E+00;-7.56E-01;-5.82E+00;-5.47E+00;-2.00E+00;-6.45E+00;-9.01E+00;-7.06E+00;-2.12E+00;-1.67E+00;-7.90E+00;-8.49E+00;-1.66E+01;-1.70E+01;-2.17E+04;-2.16E+04];
T1_XSect_Sigma_Coeff.s_sig = [4.88E+00;7.42E+00;3.14E+01;1.64E+01;9.62E+01;3.80E+00;3.37E+00;2.92E+01;4.42E+00;3.05E+01;2.10E+03;4.21E+01;5.45E+01;4.55E+00;3.44E+00;2.12E+00;1.69E+00;2.88E-02;2.87E-02];
T1_XSect_Sigma_Coeff.t_sig = [3.62E-01;3.78E-01;6.52E-01;6.14E-01;4.52E+00;2.61E-01;2.85E-01;7.78E-01;3.48E-01;1.18E-01;1.02E-01;1.01E+00;9.84E-01;3.00E-01;2.93E-01;2.20E-01;1.99E-01;3.03E-01;3.03E-01];
%% 3.2 - Calculating the photoionization cross-section, sigma
cm22barn = 1e+24;
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
            a       = T1_XSect_Sigma_Coeff.a_sig(cl_indx(i));
            m       = T1_XSect_Sigma_Coeff.m_sig(cl_indx(i));
            b       = T1_XSect_Sigma_Coeff.b_sig(cl_indx(i));
            n       = T1_XSect_Sigma_Coeff.n_sig(cl_indx(i));
            p       = T1_XSect_Sigma_Coeff.p_sig(cl_indx(i));
            q       = T1_XSect_Sigma_Coeff.q_sig(cl_indx(i));
            r       = T1_XSect_Sigma_Coeff.r_sig(cl_indx(i));
            s       = T1_XSect_Sigma_Coeff.s_sig(cl_indx(i));
            t       = T1_XSect_Sigma_Coeff.t_sig(cl_indx(i));
            % --- Calculate Sigma
            if ele_indx == 1;   temp_data = 0.035*(a + m*2).*(ihv + b + n*2 + (p*2).^2).^(q + r.*exp(-(2/s).^t)) .* cm22barn; % For H(Z=1): 1/2 He cross-section so it is not empty
            else;               temp_data = (a + m*ele_indx).*(ihv + b + n*ele_indx + (p*ele_indx).^2).^(q + r.*exp(-(ele_indx/s).^t)) .* cm22barn;
            end
        end
        temp_data(ihv<Ebe) = NaN; temp_data(temp_data<0) = NaN;
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
xsect_sigma = ixsect;
if isrow(hv); if size(xsect_sigma, 2) ~= length(hv); xsect_sigma = xsect_sigma'; end
elseif iscolumn(hv); if size(xsect_sigma, 1) ~= length(hv); xsect_sigma = xsect_sigma'; end
end
% -- If the photoionization parameter is negative, make it NaN
xsect_sigma(xsect_sigma<0) = NaN;
%% Enable warning back-trace
warning('on', 'backtrace');
%% -- Plot for debugging
if plot_results == 1
    % -- Loading in Cant2022 Data
    XS_DB_Cant2022	= load('XS_DB_Cant2022.mat'); XS_DB_Cant2022 = XS_DB_Cant2022.XS_DB_Cant2022;
    table_hv    = XS_DB_Cant2022.HV;
    table_xs    = XS_DB_Cant2022.XSECT_SIGMA{ele_indx};
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
    text(0.98, 0.91, sprintf("Cant(2022)"),...
        'FontSize', 8, 'color', 'k', 'Units','normalized', 'HorizontalAlignment','right');
    xlabel(' Photon Energy [eV] ', 'FontWeight','bold');
    ylabel(' \sigma [barn/atom] ', 'FontWeight','bold');
    ax = gca; ax.YScale = 'log'; ax.XScale = 'linear';
    % yline(0, 'k-', 'LineWidth',1, 'HandleVisibility','off');
    axis([0.9*1000, 1.1*10000, 1e-3, 1e6]);
end
end