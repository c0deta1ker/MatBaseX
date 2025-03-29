function fig = pes1d_view_fit(fitStr)
% fig = pes2ncurve_view_fit(fitStr)
%   This function is used to plot the final PES curve model AFTER  curve 
%   fitting with the 'pes2ncurve_solver()'.
%
%   IN:
%   -   fitStr: data structure that contains the PES fitting output of the corresponding solver.
%
%   OUT:
%   -   fig:    MATLAB figure object that summarises the fit.

%% - 1 - Plotting best fit model
% - Initialising the figure object
fig = figure(); 
fig.Position(1) = 100; fig.Position(2) = 100; 
fig.Position(3) = 800; fig.Position(4) = 450;
cols = lines(fitStr.nStates+5);
% -- Creating a tiled axis
t = tiledlayout(4,2); t.TileSpacing = 'compact'; t.Padding = 'compact';
%% - 1.1 - Plotting the background subtraction method
nexttile([4,1]); hold on;
% - Extracting variables
ROI     = [fitStr.X(1), fitStr.X(end)]; 
LHS     = ROI(1) + [-1,1].*fitStr.bParams{3};
RHS     = ROI(2) + [-1,1].*fitStr.bParams{3};
% -- Plotting the ROI, LHS and RHS analysis windows
hMID    = patch([ROI(1), ROI(1), ROI(2), ROI(2), ROI(1)], [0, 1, 1, 0, 0].*2*max(fitStr.ydat(:)), [0.8 0.8 0.8], 'facealpha', 0.5, 'edgecolor', 'none');
hLHS    = patch([LHS(1), LHS(1), LHS(2), LHS(2), LHS(1)], [0, 1, 1, 0, 0].*2*max(fitStr.ydat(:)), [0.2 0.7 0.2], 'facealpha', 0.2, 'edgecolor', 'none');
hRHS    = patch([RHS(1), RHS(1), RHS(2), RHS(2), RHS(1)], [0, 1, 1, 0, 0].*2*max(fitStr.ydat(:)), [0.2 0.7 0.2], 'facealpha', 0.2, 'edgecolor', 'none');
hLHS.Annotation.LegendInformation.IconDisplayStyle = 'off';
hRHS.Annotation.LegendInformation.IconDisplayStyle = 'off';
hMID.Annotation.LegendInformation.IconDisplayStyle = 'off';
% -- Plotting a vertical line to show the ROI
a = xline(ROI(1), 'Color', [0 0 0], 'LineWidth', 1, 'Linestyle', '-');
b = xline(ROI(2), 'Color', [0 0 0], 'LineWidth', 1, 'Linestyle', '-');
c = yline(0, 'Color', [0 0 0], 'LineWidth', 1, 'Linestyle', '-');
a.Annotation.LegendInformation.IconDisplayStyle = 'off';
b.Annotation.LegendInformation.IconDisplayStyle = 'off';
c.Annotation.LegendInformation.IconDisplayStyle = 'off';
% -- Plotting the 1D data
plot(fitStr.xdat, fitStr.ydat, 'b-', 'linewidth', 0.5);
plot(fitStr.X, fitStr.D, 'b-', 'linewidth', 1.5);
plot(fitStr.X, fitStr.DB, 'k-', 'linewidth', 1.5);
plot(fitStr.X, fitStr.B, 'r-', 'linewidth', 1.5);
title('Background Subtraction'); 
ylabel('$$ \bf  X $$', 'Interpreter', 'latex');
xlabel('$$ \bf  Y $$', 'Interpreter', 'latex');
legend({'Initial Data', 'ROI: Data', 'ROI: Background', 'ROI: Final'}, 'location', 'best', 'fontsize', 8);
% -- Determining the best limits for the plot
axLim_y = [fitStr.D; fitStr.DB];
axLim_x = [mean(fitStr.X(:)) - abs(0.65*range(fitStr.X(:))); mean(fitStr.X(:)) + abs(0.65*range(fitStr.X(:)));];
axis([axLim_x(1), axLim_x(2), min(axLim_y(:)), 1.05*max(axLim_y(:))]);
% Font properties
ax = gca;
ax.FontName         = 'Segoe UI'; 
ax.FontWeight       = 'normal'; 
ax.FontSize         = 10;
%% - 1.2 - Plotting the best fit curve components
nexttile([3,1]); hold on;
% -- Plotting all of the curve components
for i = 1:fitStr.nStates
    area(fitStr.Xi, fitStr.cMi(:,i), 'FaceColor', cols(i,:), 'FaceAlpha', 0.50, 'EdgeAlpha', 0);
    plot(fitStr.Xi, fitStr.cMi(:,i), 'k-', 'linewidth', 0.25);
end
% -- Plotting the curve component energy locations
for i = 1:fitStr.nStates
    if i == 1; lWidth = 2; else; lWidth = 1; end
    line([fitStr.BE(i), fitStr.BE(i)], [0, max(fitStr.cMi(:,i))],...
        'Color', [0 0 0], 'LineWidth', lWidth, 'Linestyle', '-');
end
% -- Plotting the experimental and fit spectra
plot(fitStr.X, fitStr.DB, 'k-', 'color', 'r', 'linewidth', 2.5);
plot(fitStr.X, fitStr.M, 'k-', 'Color', 'k', 'linewidth', 1.5);
% -- Add annotation for the quality of fit
text(0.04, 0.90, sprintf("R^2 = %.4e", fitStr.COST_STD_RESID),'fontsize', 8, 'color', 'k', 'Units','normalized');
text(0.04, 0.95, sprintf("X^2 = %.4e", fitStr.COST_CHISQ),'fontsize', 8, 'color', 'k', 'Units','normalized');
% - Formatting the figure
title('Best Curve Fit & Residuals'); 
ylabel('$$ \bf  Y $$', 'Interpreter', 'latex');
xlabel('$$ \bf  X $$', 'Interpreter', 'latex');
axis([min(fitStr.X(:)), max(fitStr.X(:)), min(fitStr.DB(:)), 1.10*max(fitStr.DB(:))]);
% Font properties
ax = gca;
ax.FontName         = 'Segoe UI'; 
ax.FontWeight       = 'normal'; 
ax.FontSize         = 10;
%% - 1.3 - Plotting the residuals
nexttile([1,1]); hold on;
bar(fitStr.X, fitStr.R, 'facecolor', [0 0 0]);
ylabel('$$ \bf  Resid. $$', 'Interpreter', 'latex');
xlabel('$$ \bf  E_B - E_F (eV) $$', 'Interpreter', 'latex');
% Font properties
ax = gca;
ax.FontName         = 'Segoe UI'; 
ax.FontWeight       = 'normal'; 
ax.FontSize         = 10;
end