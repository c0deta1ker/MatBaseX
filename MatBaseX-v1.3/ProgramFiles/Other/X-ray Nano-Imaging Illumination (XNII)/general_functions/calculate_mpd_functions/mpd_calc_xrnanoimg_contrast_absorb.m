function absorb_contrast_beta = mpd_calc_xrnanoimg_contrast_absorb(hv, mat_bp, mat_tf, plot_results)
% phase_contrast_delta = mpd_calc_xrnanoimg_contrast_absorb(hv, mat_bp, mat_tf)
%   This function calculates the absorptive contrast of a particular feature
%   material (mat_tf) inside a bulk material (mat_bp) at a particular
%   photon energy. This is calculated as,
%                        X = | β[bulk] - β[feature] |
%   β is the absorptive aspect of the wave-matter interaction.
%
%   IN:
%   -   hv:             scalar or column vector of the incident photon energies [eV]
%   -   mat_bp:         char/string of the background material; e.g. "Si", "SiO2", "Al2O3"...
%   -   mat_tf:         char/string of the feature material; e.g. "Au", "Cu", "Al"...
%   -   plot_results:   if 1, will plot figure summary, otherwise it wont.
%
%   OUT:
%   -   absorb_contrast_beta:   scalar or column vector of the absorptive contrast

%% Default parameters
if nargin < 4; plot_results = 0; end
if isempty(plot_results); plot_results = 0; end
%% Validity checks on the input parameters
mat_tf     = string(mat_tf);
mat_bp     = string(mat_bp);
% -- Ensure vector forms are consistent
if isrow(hv); hv = hv'; end

%% 1 - Calculating Phase Contrast
% -- Extracting scattering parameters
[beta_bp, delta_bp, ~, ~, ~]    = mpd_calc_xasf_params(hv, mat_bp);
[beta_f, delta_f, ~, ~, ~]      = mpd_calc_xasf_params(hv, mat_tf);
% -- Extracting contrast from materials
dbeta   = abs(beta_bp - beta_f);
ddelta  = abs(delta_bp - delta_f);
% -- Assigning contrast
absorb_contrast_beta = (dbeta);

%% -- Plotting the results (if necessary!)
if plot_results == 1
    % - Creating a figure
    fig = figure(); 
    fig.Position(1) = 100; fig.Position(2) = 100;
    fig.Position(3) = 500; 
    fig.Position(4) = 500;
    % - Creating a tiled axis
    t = tiledlayout(1,1);
    t.TileSpacing = 'compact';
    t.Padding = 'compact';
    % -- Plotting the 2D image data (number of photons / voxel)
    nexttile(); hold on; grid on; grid minor;
    scatter(hv, absorb_contrast_beta, 'ko', 'markerfacecolor', 'k', 'markeredgecolor', 'k');
    plot(hv, absorb_contrast_beta, 'k-', 'LineWidth', 2);
    % -- Formatting the figure
    title(sprintf('Absorptive Contrast - %s in %s', mat_tf, mat_bp), 'FontSize', 13);
    xlabel('Photon Energy [eV]', 'FontWeight', 'bold', 'FontSize', 11, 'interpreter', 'none');
    ylabel('X-Ray Phase Contrast', 'FontWeight', 'bold', 'FontSize', 11, 'interpreter', 'none');
    set(gca(), 'Layer','top'); box on;
    ax = gca; ax.XScale = 'log';  ax.YScale = 'log';
end
end