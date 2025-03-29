function fig = nlayer2pes_full_theta_solver_view_fit(fitStr)
% fig = nlayer2pes_full_theta_solver_view_fit(fitStr)
%   This function is used to plot the initial, model XPS curve PRIOR to
%   curve fitting with 'pes2ncurve_solver()'. The plot consists of 3 subplots; (1) The
%   background that is determined from the fit; (2) A plot showing all of
%   the fitted curve components, as well as the final model fit and
%   experimental data; (3) A plot of the residuals, showing the quality of
%   the experimental and model fit. This is used as an informative plot
%   that allows you to view and create a better initial guess of the XPS
%   model prior to running the fitting algorithm.
%   This function requires that the user has XPS data on the full sample
%   stack, with photoelectron intensites that originate from all layers in
%   the sample stack.
%
%   IN:
%   -   fitStr:         MATLAB data-structure that contains all the fit parameters / variables / information
%
%   OUT:
%   -   fig:  	        output MATLAB figure.

%% 1    :   Extracting all data and information
% -- Extracting the xps data
X               = fitStr.X;
D               = fitStr.D;
% -- Extracting the defined model sample
lyr_mat         = fitStr.opt_pes_model.lyr_mat;
lyr_ele         = fitStr.opt_pes_model.lyr_ele;
lyr_cls         = fitStr.opt_pes_model.lyr_cls;
hv              = fitStr.opt_pes_model.hv;
theta           = fitStr.opt_pes_model.theta;
phi             = fitStr.opt_pes_model.phi;
P               = fitStr.opt_pes_model.P;
formalism_xsect = fitStr.opt_pes_model.formalism_xsect;
formalism_imfp  = fitStr.opt_pes_model.formalism_imfp;
% -- Extracting the layer thicknesses
lyr_thick       = fitStr.lyr_thick;
% -- Extracting the PES model data
M               = fitStr.M;
XX              = fitStr.XX;
MM              = fitStr.MM;
%% 2    :   Determination of the residuals and chi-squared
R               = fitStr.R;             % Residuals
MINFUN          = fitStr.MINFUN;	    % Chi-squared
%% 3    :   Creating a figure object
fig = figure(); 
fig.Position(1) = 100; fig.Position(2) = 100;
fig.Position(3) = 950; 
fig.Position(4) = 550;
% -- Creating a tiled axis
t = tiledlayout(4,4);
t.TileSpacing = 'compact';
t.Padding = 'compact';
% -- Defining the layer colours
lyr_cols    = flipud(num2cell([0.25,0.25,0.25;lines(fitStr.Nlyrs-1)], 2));
%% 4    :    Plotting the the material stack
nexttile([4,1]); hold on;
% -- Extracting the extent of each layer
x_width	= 5;
bulk_thickness = 5;
if fitStr.Nlyrs == 1
    y_cum   = cell2mat(fitStr.opt_pes_model.lyr_thick);
else
    y_cum   = cumsum(cell2mat(fitStr.opt_pes_model.lyr_thick));
    y_cum(isinf(y_cum)) = y_cum(end-1) + bulk_thickness;
end
% -- Plotting each layer from bottom-to-up
for i = fitStr.Nlyrs:-1:1
    patch([-1, -1, 1, 1, -1].*x_width, [0, y_cum(i), y_cum(i), 0, 0].*-1,...
        lyr_cols{i}, 'edgecolor', [0 0 0]);
end
% -- Adding text for each material type
for i = 1:fitStr.Nlyrs
    if i == 1;  y_loc = 0 - 0.5*(y_cum(i) - 0);
    else;       y_loc = -y_cum(i-1) - 0.5*(y_cum(i) - y_cum(i-1));
    end
    if i == fitStr.Nlyrs
        text(0, y_loc, "(Bulk) "+string(fitStr.opt_pes_model.lyr_mat{i}),...
        'color', 'k', 'horizontalalignment', 'center', 'verticalalignment', 'middle', 'FontWeight','bold', 'FontSize',9);
    else
        text(0, y_loc, sprintf("(L%i) %s [%.2f nm]",i, fitStr.opt_pes_model.lyr_mat{i}, fitStr.opt_pes_model.lyr_thick{i}),...
        'color', 'k', 'horizontalalignment', 'center', 'verticalalignment', 'middle', 'FontWeight','bold', 'FontSize',9); 
    end
end
% -- Box Styling and Axis properties
ylabel('Depth From Surface [nm]', 'fontweight', 'bold');
axis([-x_width, x_width, -1*max(y_cum(:)), 0]);
ax = gca; ax.FontName = 'Segoe UI'; ax.FontSize = 10; 
%% 5    :    Plotting the intensity profiles for each layer
nexttile([3,3]); hold on; grid on; grid minor;
% -- Plotting the XPS data
for i = 1:fitStr.Nlyrs
    scatter(X, D(i,:), 'color', lyr_cols{i}, 'markerfacecolor', lyr_cols{i}, 'MarkerFaceAlpha', 0.5, 'markeredgecolor', lyr_cols{i});
end
% -- Plotting the PES model data
for i = 1:fitStr.Nlyrs
    plot(XX, MM(i,:), 'k.-', 'color', lyr_cols{i}, 'markerfacecolor', lyr_cols{i}, 'linewidth', 2.5);
    leg_labels{i}   = string(fitStr.opt_pes_model.lyr_mat{i})+"("+string(fitStr.opt_pes_model.lyr_cls{i})+")";
    leg_cols{i}     = plot(nan, 'k.-', 'color', lyr_cols{i}, 'markerfacecolor', lyr_cols{i}, 'linewidth', 2.5);
end
% -- Adding a value of ChiSq
text(0.04, 0.95, "$$ \chi^2 = $$ " + string(MINFUN),...
    'interpreter', 'latex', 'fontsize', 16, 'color', 'k', 'Units','normalized');
% -- Box Styling and Axis properties
legend([leg_cols{:}], leg_labels, 'location', 'northeast');
title('Photoelectron intensities vs photon energy');
xlabel('Emission Angle [deg.]', 'Interpreter', 'none', 'FontWeight', 'bold');
ylabel('Relative Contribution', 'Interpreter', 'none', 'FontWeight', 'bold');
xlim([0, 90]);ylim([0, 1.00]);
ax = gca; ax.FontName = 'Segoe UI'; ax.FontSize = 10; 
%% 6    :    Plotting the residuals
nexttile([1,3]); hold on; grid on; grid minor;
for i = 1:fitStr.Nlyrs; bar(X, R(i,:), 'facecolor', lyr_cols{i}); end
grid on;
ylabel(' Resid. ', 'Interpreter', 'none', 'FontWeight', 'bold');
xlabel('Emission Angle [deg.]', 'Interpreter', 'none', 'FontWeight', 'bold');
xlim([0, 90]);
ax = gca; ax.FontName = 'Segoe UI'; ax.FontSize = 10; 
end