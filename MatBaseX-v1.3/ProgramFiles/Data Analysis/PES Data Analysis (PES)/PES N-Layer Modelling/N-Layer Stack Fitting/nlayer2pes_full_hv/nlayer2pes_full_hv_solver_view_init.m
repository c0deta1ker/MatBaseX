function fig = nlayer2pes_full_hv_solver_view_init(xpsDat, modelDat, iparams)
% fig = nlayer2pes_full_hv_solver_view_init(xpsDat, modelDat, iparams)
%   This function plots the initial, model PES photoelectron intensities
%   superimposed on an XPS dataset prior to any fitting using the 
%   'nlayer2pes_solver()'. The plot includes 3 subplots: (1) The sample stack, 
%   displaying each material layer and its thickness; (2) A plot illustrating 
%   the photoelectron intensities against photon energy; (3) A plot of the 
%   residuals, which indicates the quality of the match between the experimental 
%   data and the model fit. 
%   This function serves as a useful tool for visualizing and improving the 
%   initial guess of the XPS model before executing the fitting algorithm.
%   This function requires that the user has XPS data on the full sample
%   stack, with photoelectron intensites that originate from all layers in
%   the sample stack.
%
%   IN:
%   -   xpsDat:         data structure that contains the XPS data.
%           .xdat                   Nx1 column vector of the XPS photon energy domain (eV).
%           .ydat                   Nx1 column vector of the XPS normalised photoelectron intensities.
%   -   modelDat:       data structure that contains the Model PES data from a defined sample stack.
%           .lyr_mat:  	            Mx1 cell-vector of the material for each layer in the stack; e.g. "Si", "SiO2", "Al2O3"...
%           .lyr_thick:	            Mx1 cell-vector of the thickness of each layer in the stack (nm)
%           .lyr_ele:               Mx1 cell-vector of strings of the element to be probed; e.g. "H", "He", "Si", "In"...
%           .lyr_cls:  	            Mx1 cell-vector of strings of the core-level to be probed; e.g. "5s1", "5p1", "5p3", "5d3", "5d5", "5f5', "5f7"...
%           .hv:                    scalar or N×1 vector of the incident photon energies [eV]
%           .theta:                 scalar of the polar angle between the photoelectron vector relative to electric field vector (i.e. at normal emission: LV (p-pol, E//MP) = 0, LH (s-pol, E⊥MP) = 90) [degree]
%           .phi:                   scalar of the azimuthal angle between the photon momentum vector relative to the projection of the photoelectron vector on to the plane perpendicular to the electric field vector (i.e. normal emission = 0) [degree]
%           .P:                     scalar of degree of polarization, where 1 or 0 is equivalent to full linear polarization, and 0.5 is equivalent to unpolarized light.
%           .formalism_xsect:       string of the photoionization cross-section formalism to use. Default:"Cant2022" ["Cant2022","YehLindau1985","Trzhaskovskaya2018","Cant2022"]
%           .formalism_imfp:        string for imfp calculator formalism. Default:"S2" ["Universal","TPP2M","TPP2M-avg","Optical","S1","S2","S3","S3-organic","S4"]
%   -   iparams:        3 cells {x0}{lb}{ub} with Mx1 vectors of the initial guess layer thicknesses (nm)
%
%   OUT:
%   -   fig:            output MATLAB figure.

%% 1    :   Extracting all data and information
% -- Extracting the xps data
X               = xpsDat.xdat;
D               = xpsDat.ydat;
% -- Extracting the defined model sample
lyr_mat         = modelDat.lyr_mat;
lyr_ele         = modelDat.lyr_ele;
lyr_cls         = modelDat.lyr_cls;
hv              = modelDat.hv;
theta           = modelDat.theta;
phi             = modelDat.phi;
P               = modelDat.P;
formalism_xsect = modelDat.formalism_xsect;
formalism_imfp  = modelDat.formalism_imfp;
% -- Extracting the layer thicknesses
lyr_thick       = [iparams{1}, Inf];    lyr_thick(lyr_thick < 0) = 0;
lyr_thick_lb    = [iparams{2}, Inf];    lyr_thick_lb(lyr_thick_lb < 0) = 0;
lyr_thick_ub    = [iparams{3}, Inf];    lyr_thick_ub(lyr_thick_ub < 0) = 0;
% -- Extracting the PES model data on the same domain as the XPS data
pes_model       = nlayer_pes_model(lyr_mat, lyr_thick, lyr_ele, lyr_cls, X, theta, phi, P, formalism_xsect, formalism_imfp);
M               = cell2mat(pes_model.lyr_Inorm);
% -- Extracting the PES model data on the user-defined grid-size
XX  = hv;
pes_model       = nlayer_pes_model(lyr_mat, lyr_thick, lyr_ele, lyr_cls, XX, theta, phi, P, formalism_xsect, formalism_imfp);
MM              = cell2mat(pes_model.lyr_Inorm);
% -- Extracting the lower- and upper-bound limits on the constraints
lyr_thick_all   = {lyr_thick_lb(1:end-1), lyr_thick(1:end-1), lyr_thick_ub(1:end-1)};
lyr_combs       = combinations(lyr_thick_all{:});
lyr_combs       = table2array(lyr_combs);

%% 2    :   Determination of the residuals and chi-squared
R           = M - D;                        % Residuals
MINFUN      = sum(sum(R.^2) ./ std(R).^2);	% Chi-squared
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
lyr_cols    = flipud(num2cell([0.25,0.25,0.25;lines(pes_model.Nlyrs-1)], 2));
%% 4    :    Plotting the the material stack
nexttile([4,1]); hold on;
% -- Extracting the extent of each layer
x_width	= 5;
bulk_thickness = 5;
if pes_model.Nlyrs == 1
    y_cum   = cell2mat(pes_model.lyr_thick);
else
    y_cum   = cumsum(cell2mat(pes_model.lyr_thick));
    y_cum(isinf(y_cum)) = y_cum(end-1) + bulk_thickness;
end
% -- Plotting each layer from bottom-to-up
for i = pes_model.Nlyrs:-1:1
    patch([-1, -1, 1, 1, -1].*x_width, [0, y_cum(i), y_cum(i), 0, 0].*-1,...
        lyr_cols{i}, 'edgecolor', [0 0 0]);
end
% -- Adding text for each material type
for i = 1:pes_model.Nlyrs
    if i == 1;  y_loc = 0 - 0.5*(y_cum(i) - 0);
    else;       y_loc = -y_cum(i-1) - 0.5*(y_cum(i) - y_cum(i-1));
    end
    if i == pes_model.Nlyrs
        text(0, y_loc, "(Bulk) "+string(pes_model.lyr_mat{i}),...
        'color', 'k', 'horizontalalignment', 'center', 'verticalalignment', 'middle', 'FontWeight','bold', 'FontSize',9);
    else
        text(0, y_loc, sprintf("(L%i) %s [%.2f nm]",i, pes_model.lyr_mat{i}, pes_model.lyr_thick{i}),...
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
for i = 1:pes_model.Nlyrs
    scatter(X, D(:,i), 'color', lyr_cols{i}, 'markerfacecolor', lyr_cols{i}, 'MarkerFaceAlpha', 0.5, 'markeredgecolor', lyr_cols{i});
end
% -- Plotting the PES model data
for i = 1:pes_model.Nlyrs
    plot(XX, MM(:,i), 'k.-', 'color', lyr_cols{i}, 'markerfacecolor', lyr_cols{i}, 'linewidth', 2.5);
    leg_labels{i}   = string(pes_model.lyr_mat{i})+"("+string(pes_model.lyr_cls{i})+")";
    leg_cols{i}     = plot(nan, 'k.-', 'color', lyr_cols{i}, 'markerfacecolor', lyr_cols{i}, 'linewidth', 2.5);
end
% -- Adding a value of ChiSq
text(0.04, 0.95, "$$ \chi^2 = $$ " + string(MINFUN),...
    'interpreter', 'latex', 'fontsize', 16, 'color', 'k', 'Units','normalized');
% -- Box Styling and Axis properties
legend([leg_cols{:}], leg_labels, 'location', 'northeast');
title('Photoelectron intensities vs photon energy');
xlabel('Photon energy [eV]', 'Interpreter', 'none', 'FontWeight', 'bold');
ylabel('Relative Contribution', 'Interpreter', 'none', 'FontWeight', 'bold');
xlim([mean(XX(:))-0.55.*range(XX), mean(XX(:))+0.55.*range(XX)]);
ylim([0, 1.00]);
ax = gca; ax.FontName = 'Segoe UI'; ax.FontSize = 10; 
%% 6    :    Plotting the residuals
nexttile([1,3]); hold on; grid on; grid minor;
for i = 1:pes_model.Nlyrs; bar(X, R(:,i), 'facecolor', lyr_cols{i}); end
grid on;
ylabel(' Resid. ', 'Interpreter', 'none', 'FontWeight', 'bold');
xlabel('Photon energy [eV]', 'Interpreter', 'none', 'FontWeight', 'bold');
xlim([mean(XX(:))-0.55.*range(XX), mean(XX(:))+0.55.*range(XX)]);
ax = gca; ax.FontName = 'Segoe UI'; ax.FontSize = 10; 
end