function fig = plt_result_xsect_angle_aniso(element, formalism, hv, corelevel, theta, phi, P, FP)
% fig = plt_result_xsect_angle_aniso(element, formalism, hv, corelevel, theta, phi, P, FP)
%   Plot angular anisotropy parameters vs. photon energy, polar angle, or azimuth angle.
%   Complex multi-purpose function for visualizing angular anisotropy.
%   Automatically adapts plot axes and labels based on input dimensions:
%   - If hv is scalar: plots vs. theta (if phi scalar) or vs. phi (if phi vector)
%   - If hv is vector: plots vs. photon energy
%   Supports four formalism types affecting axis labels and ranges:
%   - FP:  Angular momentum coupling parameter (includes P)
%   - FL:  Legendre polynomial expansion parameter
%   - FU:  Alternative parameterization (omega angle)
%   - Fadj: Adjusted/fitted parameter
%
%   IN:
%   -   hv:           - (double, scalar or vector) Photon energy [eV]; scalar for fixed hv, vector for energy scan
%   -   element:      - (string/char) Chemical element symbol
%   -   corelevel:    - (string or cell array) Core-level(s) (e.g., '1s', {'1s','2s'})
%   -   theta:        - (double, scalar or vector) Polar angle [degrees]; if scalar, plot vs. phi
%   -   phi:          - (double, scalar or vector) Azimuth angle [degrees]; if scalar, plot vs. theta
%   -   formalism:    - (string) Anisotropy type: identifies FP, FL, FU, or Fadj parameters
%   -   P:            - (double, scalar) Linear polarization parameter (0–1); used for FP formalism only
%   -   FP:           - (double, 4D array) Angular anisotropy tensor [hv × corelevel × theta × phi]
%
%   OUT:
%   -   fig:          - (figure object) Handle to created figure

%% INPUT VALIDATION AND PREPARATION
element         = string(element);
nTransitions    = length(corelevel);
% Get element atomic number and color mapping
colorList       = read_spectroscopy_colors(corelevel);
elementData     = get_mpd_props(element);
atomicNumber    = elementData.atom_z;
formalismList   = read_formalisms('xsect-angleaniso');
if ~isempty(find(strcmpi(formalismList{1}, formalism),1));      F_type = "FP";
elseif ~isempty(find(strcmpi(formalismList{2}, formalism),1));  F_type = "FL";
elseif ~isempty(find(strcmpi(formalismList{3}, formalism),1));  F_type = "FU";
elseif ~isempty(find(strcmpi(formalismList{4}, formalism),1));  F_type = "Fadj";
end

%% 1    :   CREATE FIGURE AND AXIS
fig = figure('Name', sprintf('Photoionization Parameters (XSECT-ANGULAR ANISOTROPY-%s) - %s (Z=%.0f)', F_type, element, atomicNumber));
fig.Position = [100, 100, 700, 500];  % [left, bottom, width, height]
% Create tiled layout for clean spacing
t = tiledlayout(1, 1);
t.TileSpacing = 'compact';
t.Padding = 'compact';
%% 2    :   PLOT DATA
nexttile(); hold on;
% - If a single photon energy is defined
if isscalar(hv)
% - Plot versus theta
    if isscalar(phi) || isempty(phi)
        for i = 1:nTransitions
            plot(theta, squeeze(FP(1,i,:,1)),...
                'x-', 'markersize', 5, 'markeredgecolor', colorList{i},...
                'markerfacecolor', colorList{i}, 'color', colorList{i}); 
        end
        axis([0, 90, 0, 3.75]);
        switch F_type
            case "Fadj"
                xlabel('Theta [degree]', 'FontWeight','bold');
                ylabel('Angular Anisotropy (Fadj)', 'FontWeight','bold');
                text(0.98, 0.88, sprintf("hv = %.0f eV, phi = %.0f deg.", hv(1), phi(1)),...
                    'FontSize', 9, 'color', 'k', 'Units','normalized', 'HorizontalAlignment','right', 'FontName', 'Helvetica');
            case "FP"
                xlabel('Theta [degree]', 'FontWeight','bold');
                ylabel('Angular Anisotropy (FP)', 'FontWeight','bold');
                text(0.98, 0.88, sprintf("P = %.2f, hv = %.0f eV, phi = %.0f deg.", P, hv(1), phi(1)),...
                    'FontSize', 9, 'color', 'k', 'Units','normalized', 'HorizontalAlignment','right', 'FontName', 'Helvetica');
            case "FL"
                xlabel('Theta [degree]', 'FontWeight','bold');
                ylabel('Angular Anisotropy (FL)', 'FontWeight','bold');
                text(0.98, 0.88, sprintf("hv = %.0f eV, phi = %.0f deg.", hv(1), phi(1)),...
                    'FontSize', 9, 'color', 'k', 'Units','normalized', 'HorizontalAlignment','right', 'FontName', 'Helvetica');
            case "FU"
                xlabel('Omega [degree]', 'FontWeight','bold');
                ylabel('Angular Anisotropy (FU)', 'FontWeight','bold');
                text(0.98, 0.88, sprintf("hv = %.0f eV", hv(1)),...
                    'FontSize', 9, 'color', 'k', 'Units','normalized', 'HorizontalAlignment','right', 'FontName', 'Helvetica');
        end
% - Plot versus phi
    else
        for i = 1:nTransitions
            plot(phi, squeeze(FP(1,i,1,:)),...
                'x-', 'markersize', 5, 'markeredgecolor', colorList{i},...
                'markerfacecolor', colorList{i}, 'color', colorList{i}); 
        end
        axis([0, 180, 0, 3.75]);
        switch F_type
            case "Fadj"
                xlabel('Phi [degree]', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Helvetica');
                ylabel('Angular Anisotropy (Fadj)', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Helvetica');
                text(0.98, 0.88, sprintf("hv = %.0f eV, theta = %.0f deg.", hv(1), theta(1)),...
                    'FontSize', 9, 'color', 'k', 'Units','normalized', 'HorizontalAlignment','right', 'FontName', 'Helvetica');
            case "FP"
                xlabel('Phi [degree] ', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Helvetica');
                ylabel('Angular Anisotropy (FP) ', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Helvetica');
                text(0.98, 0.88, sprintf("P = %.2f, hv = %.0f eV, theta = %.0f deg.", P, hv(1), theta(1)),...
                    'FontSize', 9, 'color', 'k', 'Units','normalized', 'HorizontalAlignment','right', 'FontName', 'Helvetica');
            case "FL"
                xlabel('Phi [degree]', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Helvetica');
                ylabel('Angular Anisotropy (FL)', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Helvetica');
                text(0.98, 0.88, sprintf("hv = %.0f eV, theta = %.0f deg.", hv(1), theta(1)),...
                    'FontSize', 9, 'color', 'k', 'Units','normalized', 'HorizontalAlignment','right', 'FontName', 'Helvetica');
            case "FU"
                xlabel('Omega [degree]', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Helvetica');
                ylabel('Angular Anisotropy (FU)', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Helvetica');
                text(0.98, 0.88, sprintf("hv = %.0f eV", hv(1)),...
                    'FontSize', 9, 'color', 'k', 'Units','normalized', 'HorizontalAlignment','right', 'FontName', 'Helvetica');
        end
    end
else
% - Otherwise, plot versus photon energy
    for i = 1:nTransitions
        plot(hv, squeeze(FP(:,i,1,1)),...
            'x-', 'markersize', 5, 'markeredgecolor', colorList{i},...
            'markerfacecolor', colorList{i}, 'color', colorList{i}); 
    end
    axis([850, 10150, 0, 3.75]);
    switch F_type
        case "Fadj"
            xlabel(' Photon Energy [eV] ', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Helvetica');
            ylabel(' Angular Anisotropy (Fadj) ', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Helvetica');
            axis([5, 1600, 0, 3.75]);
                text(0.98, 0.88, sprintf("theta = %.0f deg., phi = %.0f deg.", theta(1), phi(1)),...
                    'FontSize', 9, 'color', 'k', 'Units','normalized', 'HorizontalAlignment','right', 'FontName', 'Helvetica');
        case "FP"
            xlabel(' Photon Energy [eV] ', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Helvetica');
            ylabel(' Angular Anisotropy (FP) ', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Helvetica');
            text(0.98, 0.88, sprintf("P = %.2f, theta = %.0f deg., phi = %.0f deg.", P, theta(1), phi(1)),...
                'FontSize', 9, 'color', 'k', 'Units','normalized', 'HorizontalAlignment','right', 'FontName', 'Helvetica');
        case "FL"
            xlabel(' Photon Energy [eV] ', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Helvetica');
            ylabel(' Angular Anisotropy (FL) ', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Helvetica');
            text(0.98, 0.88, sprintf("theta = %.0f deg., phi = %.0f deg.", theta(1), phi(1)),...
                'FontSize', 9, 'color', 'k', 'Units','normalized', 'HorizontalAlignment','right', 'FontName', 'Helvetica');
        case "FU"
            xlabel(' Photon Energy [eV] ', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Helvetica');
            ylabel(' Angular Anisotropy (FU) ', 'FontSize', 11, 'FontWeight', 'bold', 'FontName', 'Helvetica');
            text(0.98, 0.88, sprintf("omega = %.2f deg.", omega(1)),...
                'FontSize', 9, 'color', 'k', 'Units','normalized', 'HorizontalAlignment','right', 'FontName', 'Helvetica');
    end
end
legend(corelevel, 'location', 'eastoutside', 'FontSize', 9);
%% 3.1    :   FORMATTING: AXES AND GRID
% Grid setup (subtle, light gray)
grid on; grid minor; 
% Scale and limits
ax = gca;
% Axis appearance
ax.LineWidth = 1.0;
ax.FontName = 'Helvetica';
ax.FontSize = 11;
ax.XScale = 'linear'; ax.YScale = 'linear'; 
%% 3.2    :   AXIS LABELS (on top of plot area)
xline(0, 'k-', 'LineWidth',1, 'HandleVisibility','off');
yline(0, 'k-', 'LineWidth',1, 'HandleVisibility','off');
%% 3.3    :   TEXT ANNOTATIONS (Using annotation objects for consistency)
% Title section (element and atomic number)
text(0.98, 0.96, sprintf('%s(Z=%.0f)', element, atomicNumber),...
        'FontSize', 12, 'FontName', 'Helvetica', 'EdgeColor', 'none',...
        'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle',...
        'Units','normalized', 'FontWeight', 'bold');
% Formalism (calculation method)
text(0.98, 0.92, sprintf("%s", formalism),...
        'FontSize', 9, 'FontName', 'Helvetica', 'EdgeColor', 'none',...
        'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle',...
        'Units','normalized');
%% 3.4    :   AXIS POSITIONING (bring to top)
ax.Layer = 'top';
ax.TickDir = "in";
end