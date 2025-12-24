close all; clear all;
% -- Initializing save path
path_matbase    = what('X-ray Nano-Imaging Illumination (XNII)'); path_matbase = string(path_matbase.path);
path_fig_save   = path_matbase + "\0_figs\";

%% 1 :  Consistency Check & Reference Figures
%% 1.1 : 20 nm Cu in Si (ph/voxel)
% -- Silicon Background
mat_bp      = "Si";                  % Bulk Material
t_bpu       = logspace(log(4.99)/log(10),log(500)/log(10),5e2);    % Bulk Underlayer thickness (μm)
t_bpo       = logspace(log(4.99)/log(10),log(500)/log(10),5e2);    % Bulk Overlayer thickness (μm)
% -- Copper Feature
mat_tf      = "Cu";                  % Feature Material
tf          = 20;                    % Feature thickness (nm)
% -- Experiment parameters
SNR         = 5;                        % Signal-To-Noise Ratio
hv          = logspace(log(200)/log(10), log(30000)/log(10), 1e3);           % Incident Photon Energy (eV)
t_tot       = t_bpu + t_bpo + 1e-3*tf;  % Total thickness (μm)
% -- Calculating the X-ray Nano Imaging Illumination Requirements
plot_results = 1;
dataStr      = mpd_calc_xrnanoimg_illumination(hv, mat_tf, tf, mat_bp, t_bpu, t_bpo, SNR, plot_results);
dataStr
%% 1.2 : Plotting Data : ph/voxel
% -- Defining the data
X           = hv;
Y           = t_tot;
Z           = log10(dataStr.nph_pixel)';
% - Creating a figure
close all;
fig = figure(); 
fig.Position(1) = 100; fig.Position(2) = 100;
fig.Position(3) = 1000; 
fig.Position(4) = 500;
% - Creating a tiled axis
t = tiledlayout(1,2);
t.TileSpacing = 'compact';
t.Padding = 'compact';
% Plotting Data : ph/voxel
% - Plotting the data
nexttile(); hold on; grid on; grid minor;
% -- Plotting the 2D image data
h = pcolor(X, Y, Z); set(h,'EdgeColor','None','FaceColor','Flat');
cmap = gray(200); cmap = cmap(1:end-30,:);
colormap(cmap); colorbar; clim([4, 10]);
% -- Plotting the relevant contours
colors = [
    1.0, 1.0, 0.8;  % Light Yellow
    1.0, 0.8, 0.5;  % Light Orange
    0.8, 0.6, 1.0;  % Light Purple
    0.5, 0.0, 0.5   % Dark Purple
];
contour(X, Y, Z, [5,5], 'r-', 'linewidth', 1.5, 'color', colors(1,:));
contour(X, Y, Z, [5.5,5.5], 'r-', 'linewidth', 1.5, 'color', colors(2,:));
contour(X, Y, Z, [6,6], 'r-', 'linewidth', 1.5, 'color', colors(3,:));
contour(X, Y, Z, [7,7], 'r-', 'linewidth', 1.5, 'color', colors(4,:));
% -- Plotting the Si 1/e absorption
plot(hv, dataStr.bp_lambda_um, 'w--', 'linewidth', 1.5); 
% -- Formatting the figure
title('20 nm Cu in Si (ph/voxel)');
xlabel('Photon Energy (keV)', 'FontWeight', 'bold', 'FontSize', 11, 'interpreter', 'none');
ylabel('Total Silicon Thickness (μm)', 'FontWeight', 'bold', 'FontSize', 11, 'interpreter', 'none');
set(gca(), 'Layer','top'); box on;
ax = gca; ax.XScale = 'log'; ax.YScale = 'log';
axis([200, 30000, 10, 1e3]);
% Plotting Data : Gray/voxel
% -- Defining the data
X           = hv;
Y           = t_tot;
Z           = log10(dataStr.Df_pixel)';
Z(isnan(Z)) = 20;
% - Plotting the data
nexttile(); hold on; grid on; grid minor;
% -- Plotting the 2D image data
h = pcolor(X, Y, Z); set(h,'EdgeColor','None','FaceColor','Flat');
cmap = gray(200); cmap = cmap(1:end-30,:);
colormap(cmap); colorbar; clim([6, 12]);
% -- Plotting the relevant contours
colors = [
    1.0, 1.0, 0.8;  % Light Yellow
    1.0, 0.8, 0.5;  % Light Orange
    0.8, 0.6, 1.0;  % Light Purple
    0.5, 0.0, 0.5   % Dark Purple
];
contour(X, Y, Z, [6.5,6.5], 'r-', 'linewidth', 1.5, 'color', colors(1,:));
contour(X, Y, Z, [7,7], 'r-', 'linewidth', 1.5, 'color', colors(2,:));
contour(X, Y, Z, [8,8], 'r-', 'linewidth', 1.5, 'color', colors(3,:));
contour(X, Y, Z, [9,9], 'r-', 'linewidth', 1.5, 'color', colors(4,:));
% -- Plotting the Si 1/e absorption
plot(hv, dataStr.bp_lambda_um, 'w--', 'linewidth', 1.5); 
% -- Formatting the figure
title('20 nm Cu in Si (Gy/voxel)');
xlabel('Photon Energy (keV)', 'FontWeight', 'bold', 'FontSize', 11, 'interpreter', 'none');
ylabel('Total Silicon Thickness (μm)', 'FontWeight', 'bold', 'FontSize', 11, 'interpreter', 'none');
set(gca(), 'Layer','top'); box on;
ax = gca; ax.XScale = 'log'; ax.YScale = 'log';
axis([200, 30000, 10, 1e3]);
% - Saving the figure
save_fullname = path_fig_save + sprintf("ref001_20nm_Cu_in_Si");
print(save_fullname,'-dpng', '-r400');
saveas(fig, save_fullname, 'fig');