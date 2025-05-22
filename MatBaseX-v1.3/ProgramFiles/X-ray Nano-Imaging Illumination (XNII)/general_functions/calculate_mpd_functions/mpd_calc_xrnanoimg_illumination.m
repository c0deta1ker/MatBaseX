function dataStr = mpd_calc_xrnanoimg_illumination(hv, mat_tf, tf, mat_bp, t_bpu, t_bpo, SNR, plot_results)
% dataStr = mpd_calc_xrnanoimg_illumination(hv, mat_tf, tf, mat_bp, t_bpu, t_bpo, SNR, plot_results)
%   This function calculates the number of photons and the radiation dose 
%   imparted to a 2D feature for phase contrast imaging, with a feature of 
%   thickness tf inside a thickness bp of mixed background material.
%   For Zernike phase contrast imaging of a specimen; this provides a good 
%   approximation for various forms of coherent diffraction imaging. We assume 
%   that a feature material f is within a background material b in a layer of 
%   thickness tf, with a pixel size of Dp. Over and under this plane of interest 
%   in a tomographic reconstruction, we assume that there is a thickness t_bpo
%   t_bpu of a mixed background material bp. Calculations also assume 100% 
%   efficiency of the imaging system.
%
%   IN:
%   -   hv:             scalar or column vector of the incident photon energies [eV]
%   -   mat_tf:         char/string of the feature material; e.g. "Si", "SiO2", "Al2O3"...
%   -   tf:             scalar or row vector of the feature thickness [nm]
%   -   mat_bp:         char/string of the background material; e.g. "Si", "SiO2", "Al2O3"...
%   -   t_bpu:          scalar or row vector of the background material underlayer thickness [μm]
%   -   t_bpo:          scalar or row vector of the background material underlayer thickness [μm]
%   -   SNR:            scalar of the signal-to-noise ratio, typically = 5 from previous studies.
%   -   plot_results:   if 1, will plot figure summary, otherwise it wont.
%
%   OUT:
%   -   dataStr:        MATLAB data structure that contains all the relevant output data;
%           .(nph_pixel):   required number of photons for phase contrast imaging of a feature pixel [ph/pixel]
%           .(nph_total):   total number of photons required over all pixels [ph/μm2]
%           .(Df_pixel):    calculated radiation dose imparted to the feature pixel [Gray]
%           .(Df_total):    calculated total radiation dose imparted over all pixels [Gray]
%
%   SEE REFERENCES:
%       [1] M. Du, Z. Di, D. Gürsoy, R. P. Xian, Y. Kozorovitskiy, and C. Jacobsen, ‘Upscaling X-ray nanoimaging to macroscopic specimens’, J Appl Crystallogr, vol. 54, no. 2, pp. 386–401, Apr. 2021, doi: 10.1107/S1600576721000194.
%       [2] Henke B.L., Gullikson E.M., Davis J.C. X-Ray Interactions: Photoabsorption, Scattering, Transmission, and Reflection at E = 50-30,000 eV, Z = 1-92, Atomic Data and Nuclear Data Tables, 54 (2), 181-342 (1993)
%       [3] https://henke.lbl.gov/optical_constants/

%% Default parameters
if nargin < 7; SNR = 5; end
if nargin < 8; plot_results = 1; end
if isempty(SNR); SNR = 5; end
if isempty(plot_results); plot_results = 1; end
%% Validity checks on the input parameters
mat_tf     = string(mat_tf);
mat_bp     = string(mat_bp);
% -- Ensure vector forms are consistent
if isrow(hv); hv = hv'; end
if iscolumn(tf); tf = tf'; end
if iscolumn(t_bpu); t_bpu = t_bpu'; end
if iscolumn(t_bpo); t_bpo = t_bpo'; end

%% 1 - Calculating Constants
pc          = physics_constants();
% -- Incident Photon Energy (m)
lambda_nm   = convert_eV_to_nm(hv);
lambda      = lambda_nm*1e-9;
%% 2 - Extracting Bulk Properties
t_bpo       = t_bpo * 1e-6;     % -- Overlayer thickness (m)
t_bpu       = t_bpu * 1e-6;     % -- Underlayer thickness (m)
% -- Density of the Material (kg/m^-3)
mat_bp_props            = get_mpd_props(mat_bp);
density_bp_cm           = mat_bp_props.density;
density_bp              = density_bp_cm*1000;
% -- Index of Refraction
[~, delta_b, ~, ~, ~]   = mpd_calc_xasf_params(hv, mat_bp);
% -- Linear Mass Coefficient (m⁻¹)
mu_bp_cm                = mpd_calc_linear_absorb_coeff(hv, mat_bp);
mu_bp                   = mu_bp_cm * 100;
%% 3 - Extracting Feature Properties
tf          = tf * 1e-9;    % -- Feature thickness (m)
% -- Density of the Material (kg/m^-3)
mat_f_props            = get_mpd_props(mat_tf);
density_f_cm           = mat_f_props.density;
density_f              = density_f_cm*1000;
% -- Index of Refraction
[~, delta_f, ~, ~, ~]   = mpd_calc_xasf_params(hv, mat_tf);
% -- Linear Mass Coefficient (m⁻¹)
mu_f_cm                = mpd_calc_linear_absorb_coeff(hv, mat_tf);
mu_f                   = mu_f_cm * 100;
%% 4 - Calculate total number of photons per pixel
% -- Required number of photons per pixel
nph_pixel   = (SNR.^2)*(lambda.^2).*exp(mu_bp.*(t_bpu+t_bpo))./(8.*pi.^2.*tf.^2.*(delta_f-delta_b).^2);
% Invoking dose fractionation Eq.(8) and calculating the total number of 
% photons across a cylinder of total thickness t_bpu + tf + t_bpo and a
% diameter of 1 micron
nph_total   = nph_pixel .* (2.*(t_bpu+tf+t_bpo)./tf) .* (2*1e-6./tf);
%% 5 - Calculate total radiation dose imparted to the feature
% -- Radiation dose imparted on the feature per pixel
Df_pixel    = nph_pixel .* (hv.*pc.e) .* (mu_f./(density_f.*tf.^2)) .* exp(-mu_bp.*t_bpo);
% -- Radiation dose imparted on the bulk material above and below the feature material per pixel
Db_pixel    = nph_pixel .* (hv.*pc.e) .* (mu_bp./(density_bp.*tf.*(t_bpu+tf+t_bpo)));

%% Appending the data to a MALTAB data structure
dataStr = struct();
% -- Appending all input arguments
dataStr.hv           = hv;
dataStr.mat_tf       = mat_tf;                                      % Feature Material
dataStr.tf           = tf * 1e9;                                    % Feature thickness (nm)
dataStr.mat_bp       = mat_bp;                                      % Bulk Material
dataStr.t_bpu        = t_bpu * 1e6;                                 % Bulk Underlayer thickness (μm)
dataStr.t_bpo        = t_bpo * 1e6;                                 % Bulk Overlayer thickness (μm)
dataStr.SNR          = SNR;                                         % Signal-To-Noise Ratio
% -- Appending all output arguments
dataStr.t_tot        = t_bpu * 1e6 + t_bpo * 1e6 + tf * 1e6;        % Total thickness (μm)
dataStr.Nsq          = (2.*(t_bpu+tf+t_bpo)./tf) .* (2*1e-6./tf);   % Total number of pixels across the object per viewing angle
% -- Attenuation Length through bulk material
dataStr.bp_lambda_um = (1 ./ (mu_bp_cm*100)).*1e6;
% --- Calculated number of photons
dataStr.nph_pixel    = nph_pixel;
dataStr.nph_total    = nph_total;
% --- Calculated radiation dose (Gray)
dataStr.Df_pixel     = Df_pixel;
dataStr.Db_pixel     = Db_pixel;

%% -- Plotting the results (if necessary!)
if plot_results == 1
    % - Defining the data
    X               = hv;
    Y               = t_bpu * 1e6 + t_bpo * 1e6 + tf * 1e6;
    % -- per voxel data
    Z_nph           = log10(dataStr.nph_pixel)';
    Z_Df            = log10(dataStr.Df_pixel)';
    Z_nph(isnan(Z_nph))     = max(Z_nph(~isinf(Z_nph)));
    Z_Df(isnan(Z_Df))       = max(Z_Df(~isinf(Z_Df)));
    % - Creating a figure
    fig = figure(); 
    fig.Position(1) = 100; fig.Position(2) = 100;
    fig.Position(3) = 1000; 
    fig.Position(4) = 500;
    % - Creating a tiled axis
    t = tiledlayout(1,2);
    t.TileSpacing = 'compact';
    t.Padding = 'compact';

    % -- Plotting the 2D image data (number of photons / voxel)
    nexttile(); hold on; grid on; grid minor;
    h = pcolor(X, Y, Z_nph); set(h,'EdgeColor','None','FaceColor','Flat');
    cmap1 = gray(12 - 1 + 2); cmap1 = cmap1(1:end-2,:); colormap(cmap1); 
    colorbar; clim([1, 12]);
    contour(X, Y, Z_nph, [3,3], 'c-', 'linewidth', 1, 'color', 'c');
    contour(X, Y, Z_nph, [5,5], 'y-', 'linewidth', 1, 'color', 'y');
    contour(X, Y, Z_nph, [7,7], 'r-', 'linewidth', 1.2, 'color', 'r');
    % -- Plotting the 1/e absorption line
    plot(dataStr.hv, dataStr.bp_lambda_um, 'w--', 'linewidth', 1.5); 
    % -- Formatting the figure
    title(sprintf('%.0f nm %s in %s (ph/voxel)', dataStr.tf, dataStr.mat_tf, dataStr.mat_bp));
    xlabel('Photon Energy (keV)', 'FontWeight', 'bold', 'FontSize', 11, 'interpreter', 'none');
    ylabel('Total Thickness (μm)', 'FontWeight', 'bold', 'FontSize', 11, 'interpreter', 'none');
    set(gca(), 'Layer','top'); box on;
    ax = gca; ax.XScale = 'log'; ax.YScale = 'log';
    axis([min(X(:)), max(X(:)), min(Y(:)), max(Y(:))]);

    % - Plotting the 2D image data (number of Gray / voxel)
    nexttile(); hold on; grid on; grid minor;
    % -- Plotting the 2D image data
    h = pcolor(X, Y, Z_Df); set(h,'EdgeColor','None','FaceColor','Flat');
    cmap2 = gray(12 - 1 + 2); cmap2 = cmap2(1:end-2,:); colormap(cmap2); 
    colorbar; clim([1, 12]);
    contour(X, Y, Z_Df, [3,3], 'c-', 'linewidth', 1, 'color', 'c');
    contour(X, Y, Z_Df, [6,6], 'y-', 'linewidth', 1, 'color', 'y');
    contour(X, Y, Z_Df, [9,9], 'r-', 'linewidth', 1.2, 'color', 'r');
    % -- Plotting the Si 1/e absorption
    plot(hv, dataStr.bp_lambda_um, 'w--', 'linewidth', 1.5); 
    % -- Formatting the figure
    title(sprintf('%.0f nm %s in %s (Gy/voxel)', dataStr.tf, dataStr.mat_tf, dataStr.mat_bp));
    xlabel('Photon Energy (keV)', 'FontWeight', 'bold', 'FontSize', 11, 'interpreter', 'none');
    ylabel('Total Thickness (μm)', 'FontWeight', 'bold', 'FontSize', 11, 'interpreter', 'none');
    set(gca(), 'Layer','top'); box on;
    ax = gca; ax.XScale = 'log'; ax.YScale = 'log';
    axis([min(X(:)), max(X(:)), min(Y(:)), max(Y(:))]);
end
end