function [f1, f2] = calc_xasf(hv, formula, formalism, extrapolate, plot_results)
% [f1, f2] = calc_xasf(hv, formula, formalism, extrapolate, plot_results)
%   This function calculates the X-ray atomic scattering factors f1 and f2 
%   for a specified photon energy (hv) and compound formula. The calculation is based on 
%   interpolation from a given formalism database. If the input material 
%   is an element, it interpolates directly, however, if it is a compound,
%   the function computes the linear combination of the ratios scaled by 
%   the element scattering factors.
%
%   IN:
%   -   hv:             scalar or vector of the incident photon energies [eV]
%   -   formula:        char/string of the material; e.g. "H", "Si", "SiO2", "Al2O3"...
%   -   formalism:      string of the formalism to use. Default:"NIST2005" ["Henke1993", "NIST2005"]
%   -   extrapolate:    either 0 or 1; if true, it will extrapolate sigma beyond the conventional range, otherwise not
%   -   plot_results:   if 1, will plot figure summary, otherwise it wont.
%
%   OUT:
%   -   f1:             scalar or vector of the real part of atomic scattering factor (coherent scattering) [e/atom]
%   -   f2:             scalar or vector of the imaginary part of atomic scattering factor (absorption) [e/atom]
%
%       [1] Henke B.L., Gullikson E.M., Davis J.C. X-Ray Interactions: Photoabsorption, Scattering, Transmission, and Reflection at E = 50-30,000 eV, Z = 1-92, Atomic Data and Nuclear Data Tables, 54 (2), 181-342 (1993)
%       [2] https://henke.lbl.gov/optical_constants/
%       [3] https://gisaxs.com/index.php/Refractive_index
%       [4] https://physics.nist.gov/PhysRefData/FFast/html/form.html

%% Default parameters
if nargin < 3; formalism = "NIST2005";  end
if nargin < 4; extrapolate = 0;  end
if nargin < 5; plot_results = 0;  end
if isempty(formalism); formalism = "NIST2005"; end
if isempty(extrapolate); extrapolate = 0; end
if isempty(plot_results); plot_results = 0; end
%% Validity checks on the input parameters
formula     = string(formula);
formalism   = string(formalism);
ele_indx    = calc_average_z_number(formula);
%% 1 - Defining all variants of EDGE formalisms
formalism_Henke1993     = [...
    "Henke(1993)", "(1993)Henke", "Henke1993", "1993Henke",...
    "H(1993)", "(1993)H", "H1993", "H1993",...
    "Henke", "H", "1993"];
formalism_NIST2005     = [...
    "NIST(2005)", "(2005)NIST", "NIST2005", "2005NIST",...
    "NIST", "2005"];
%% 1 - Calculating the X-ray atomic scattering factors f1 and f2
vformula     = parse_chemical_formula(formula);
f1 = 0; f2 = 0;
for i = 1:length(vformula)
    % -- Henke1993 formalism
    if ~isempty(find(strcmpi(formalism_Henke1993, formalism),1))
        [f1q{i}, f2q{i}]  = calc_xasf_henke1993(hv, vformula(i).element, extrapolate);
    % -- NIST2005 formalism
    elseif ~isempty(find(strcmpi(formalism_NIST2005, formalism),1))
        [f1q{i}, f2q{i}]  = calc_xasf_nist2005(hv, vformula(i).element, extrapolate);
    else; msg = 'Formalism not found. One of the following must be used: "Henke1993" or "NIST2005".'; error(msg);
    end
    % xq{i} = vformula(i).ratio;
    xq{i} = vformula(i).quantity;
    f1 = f1 + xq{i}*f1q{i};
    f2 = f2 + xq{i}*f2q{i};
end
%% Validity check on the outputs
% -- Ensure that the output values are consistent with the input hv value
if isrow(hv); if size(f1, 2) ~= length(hv); f1 = f1'; end
elseif iscolumn(hv); if size(f1, 1) ~= length(hv); f1 = f1'; end
end
if isrow(hv); if size(f2, 2) ~= length(hv); f2 = f2'; end
elseif iscolumn(hv); if size(f2, 1) ~= length(hv); f2 = f2'; end
end
%% -- Plotting the results
if plot_results == 1
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
    lgnd_txt = {};
    nexttile(); hold on; grid on; grid minor;
    if isscalar(vformula)
        plot(hv, f1, '-', 'color', 'k', 'linewidth', 2);
        lgnd_txt{1} = 'f_1';
    else
        cols = lines(length(vformula));
        for i = 1:length(vformula)
            plot(hv, xq{i}*f1q{i}, ':', 'color', cols(i,:), 'linewidth', 1.25);
            lgnd_txt{end+1} = sprintf("%s(%.2f)", vformula(i).element, vformula(i).ratio);
        end
        lgnd_txt{end+1} = 'f_1';
        plot(hv, f1, '-', 'color', 'k', 'linewidth', 2);
    end
    % - Formatting the axis
    legend(lgnd_txt, 'location', 'southeast', 'FontSize', 8); 
    text(0.02, 0.96, sprintf("%s", formula),...
        'FontSize', 14, 'color', 'k', 'Units','normalized', 'FontWeight', 'bold', 'HorizontalAlignment','left');
    text(0.02, 0.90, sprintf("%s", formalism),...
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
    lgnd_txt = {};
    nexttile(); hold on; grid on; grid minor;
    if isscalar(vformula)
        plot(hv, f2, '-', 'color', 'k', 'linewidth', 2);
        lgnd_txt{1} = 'f_2';
    else
        cols = lines(length(vformula));
        for i = 1:length(vformula)
            plot(hv, xq{i}*f2q{i}, ':', 'color', cols(i,:), 'linewidth', 1.25);
            lgnd_txt{end+1} = sprintf("%s(%.2f)", vformula(i).element, vformula(i).ratio);
        end
        lgnd_txt{end+1} = 'f_2';
        plot(hv, f2, '-', 'color', 'k', 'linewidth', 2);
    end
    % - Formatting the axis
    legend(lgnd_txt, 'location', 'southwest', 'FontSize', 8); 
    text(0.02, 0.96, sprintf("%s", formula),...
        'FontSize', 14, 'color', 'k', 'Units','normalized', 'FontWeight', 'bold', 'HorizontalAlignment','left');
    text(0.02, 0.90, sprintf("%s", formalism),...
        'FontSize', 8, 'color', 'k', 'Units','normalized', 'HorizontalAlignment','left');
    xlabel(' Photon Energy [eV] ', 'FontWeight','bold');
    ylabel(' f_2 [e/atom] ', 'FontWeight','bold');
    ax = gca; ax.YScale = 'log'; ax.XScale = 'log';
    ax = gca; ax.YScale = 'log'; ax.XScale = 'log';
    if ele_indx < 14;   axis([5, 1e5, 1e-7, 1e3]);
    else;               axis([5, 1e5, 1e-2, 1e3]);
    end
end
end