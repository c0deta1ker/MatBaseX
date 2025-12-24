function [be, cls] = calc_be_moulder1993(element, corelevel, plot_results)
% [be, cls] = calc_be_moulder1993(element, corelevel, plot_results)
%   This is a function that extracts the electron binding energies from elements
%   with Z from 1 to 98 of the individual subshells. This is from the original
%   work of John F. Moulder [1], which has now been digitised here for use in
%   MATLAB.
%   [1] John F. Moulder, Handbook of X-ray Photoelectron Spectroscopy, 1993.
%
%   IN:
%   -   element:    	string of the element; e.g. "H", "He", "Si", "In"...
%   -   corelevel:      M×1 string array of the core-levels to be probed; e.g. ["2s1", "5p3"]... (If empty, will return all core-levels with a known binding energy.)
%   -   plot_results:   if 1, will plot figure summary, otherwise it wont.
%
%   OUT:
%   -   be:             M×1 vector of the binding energies of the chosen core-levels [eV]. Returns NaN for undefined binding energies.
%   -   cls:            M×1 vector of the core-level labels.

%% Default parameters
if nargin < 2; corelevel = [];  end
if nargin < 3; plot_results = 0;  end
if isempty(corelevel); corelevel = []; end
if isempty(plot_results); plot_results = 0; end
%% Disable warning back-trace
warning('off', 'backtrace');
%% Validity checks on the input parameters
element     = string(element);
corelevel   = string(corelevel);
%% 1 - Loading the MATLAB data structure
BE_DB_Moulder1993	= load('BE_DB_Moulder1993.mat'); BE_DB_Moulder1993 = BE_DB_Moulder1993.BE_DB_Moulder1993;
ATOM_SYMB   = string(BE_DB_Moulder1993.ATOM_SYMB);
ATOM_CL     = string(BE_DB_Moulder1993.ATOM_CL);
ATOM_BE     = table2array(BE_DB_Moulder1993.BE);
%% 2 - Find the database index of the defined element
ele_indx 	= find(strcmpi(ATOM_SYMB, element), 1);
if isempty(ele_indx); msg = 'Element could not be identified. Only use atomic-symbols for elements 1 - 98; H, He, Li, Be..., Bk, Cf'; error(msg); end
%% 3 - Find the database index of the defined core-levels
% If no core-level is defined, use all available ones
if isempty(corelevel); cl_indx = 1:length(ATOM_CL); 
% Otherwise, parse the input
else
    % - If 1 core-level is entered
    if isscalar(corelevel)
        cl_indx 	= find(strcmpi(ATOM_CL, corelevel), 1);
        if isempty(cl_indx)
            cl_indx = 0; msg = sprintf("Core-level %s not found. Only the following exist for %s : %s . NaN values returned.", corelevel, element, join(string(ATOM_CL), ', ')); warning(msg); 
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
                msg = sprintf("Core-level %s not found. Only the following exist for %s : %s . NaN values returned.", corelevel(i), element, join(string(ATOM_CL), ', ')); warning(msg); 
            end
        end
    end
end
%% 4 - Extracting the relevant binding energies
be = []; cls = "";
for i = 1:length(cl_indx)
    if cl_indx(i) == 0
        cls(i)  = NaN(1);
        be(i)   = NaN(1);
    else
        cls(i)  = ATOM_CL(cl_indx(i));
        be(i)   = ATOM_BE(ele_indx,cl_indx(i));
    end
end
%% Validity check on the outputs
% -- If no initial corelevel input was made, then remove all NaN entries
if isempty(corelevel)
    NaN_idx         = isnan(be);
    cls(NaN_idx)    = [];
    be(NaN_idx)     = [];
% -- Otherwise, preserve the labels that were user-defined
else
    NaN_idx         = find(cl_indx == 0);
    cls(NaN_idx)    = corelevel(NaN_idx);
end
% -- Ensure that the outputs are in columns
if size(cls, 2) > 1;  cls = cls'; end
if size(be, 2) > 1;  be = be'; end
%% Enable warning back-trace
warning('on', 'backtrace');
%% -- Plot for debugging
if plot_results == 1
    nCL         = length(cls);
    colorList   = read_be_core_levels_color(cls);
    % - Creating a figure
    fig = figure(); 
    fig.Position(1) = 100; fig.Position(2) = 100;
    fig.Position(3) = 800; 
    fig.Position(4) = 350;
    % - Creating a tiled axis
    t = tiledlayout(1,1);
    t.TileSpacing = 'compact';
    t.Padding = 'compact';
    % - Plot the figure
    nexttile(); hold on; grid on; grid minor;
    if nCL == 1
        stem(be, 1, '-', 'linewidth', 1.5, 'marker', 'none', 'color', colorList{1});
        text(be, 1, sprintf('%s(%.2f)', cls, be), 'Rotation',45, 'FontWeight','bold', 'FontSize',8);
    else
        for i = 1:nCL; stem(be(i), i/nCL, '-', 'linewidth', 1.5, 'marker', 'none', 'color', colorList{i});end 
        for i = 1:nCL; text(be(i), i/nCL, sprintf('%s(%.2f)', cls(i), be(i)), 'Rotation',45, 'FontWeight','bold', 'FontSize',8); end
    end
    % - Formatting the axis
    text(0.02, 0.96, sprintf("%s(Z=%i)", element, ele_indx),...
        'FontSize', 12, 'color', 'k', 'Units','normalized', 'FontWeight', 'bold', 'HorizontalAlignment','left');
    text(0.02, 0.91, sprintf("Moulder(1993)"),...
        'FontSize', 8, 'color', 'k', 'Units','normalized', 'HorizontalAlignment','left');
    xlabel('Binding Energy [eV]', 'FontWeight','bold');
    ylabel(' Intensity [arb.] ', 'FontWeight','bold');
    ax = gca; ax.YScale = 'linear'; ax.XScale = 'log';
    axis([1, 130000, 0, 1.40]);
end
end