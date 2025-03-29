function fig = pes1d_view_init(xdat, ydat, cType, cParams, bType, bParams)
% fig = pes1d_view_init(xdat, ydat, cType, cParams, bType, bParams)
%   This function is used to plot the initial, model XPS curve PRIOR to
%   curve fitting with 'pes1d_solver()'. The plot consists of 3 subplots; (1) The
%   background that is determined from the fit; (2) A plot showing all of
%   the fitted curve components, as well as the final model fit and
%   experimental data; (3) A plot of the residuals, showing the quality of
%   the experimental and model fit. This is used as an informative plot
%   that allows you to view and create a better initial guess of the XPS
%   model prior to running the fitting algorithm.
%
%   IN:
%   -   xdat:       N×1 column vector of the input domain (binding energy for PES).
%   -   ydat:       N×1 column vector of the intensity range (intensity for PES).
%   -   cType:      1xM row vector of the type of curve to use for the nth state.
%   -   cParams:    3 cells {x0}{lb}{ub} with Nx8 arrays: the n'th peak parameters [BE,INT,FWHM,MR,LSE,LSI,LSW,ASY]
%   -   bType:      string of the type of background to use for fitting. Default: "S" ("", "L", "P", "S", "SO", "SS", "1T", "2T")
%   -   bParams:    1xL cell vector of the background parameters: {LHS,RHS,WIN,BGR,varargin{:}}
%
%   OUT:
%   -   fig:  	MATLAB figure object with the ARPES data plotted.

%% Default parameters
% - Default input parameters to use
if nargin < 5
    bType   = "S";
    LHS     = mean(xdat(:)) - abs(0.25*range(xdat(:)));
    RHS     = mean(xdat(:)) + abs(0.25*range(xdat(:)));
    Win     = abs(0.02*range(xdat(:)));
    Bgr     = 0.00;
    bParams = {LHS, RHS, Win, Bgr};
end
if isempty(bType); bType = "S"; end
if isempty(bParams)
    LHS     = mean(xdat(:)) - abs(0.25*range(xdat(:)));
    RHS     = mean(xdat(:)) + abs(0.25*range(xdat(:)));
    Win     = abs(0.02*range(xdat(:)));
    Bgr     = 0.00;
    bParams = {LHS, RHS, Win, Bgr};
end
%% Validity checks on the input parameters
% - Consistency check and finding the total number of curves
if size(cParams{1}, 1) ~= size(cParams{2}, 1) || size(cParams{2}, 1) ~= size(cParams{3}, 1)
    error('The input parameter cell array is not a consistent size - check iparams input!');
end
% - Validity check on input curve parameters
for i = 1:size(cParams{1}, 1)
    if size(cParams{1}, 2) == 4
        % --- Set the ASY, LSE, LSI and LSW components to zero
        cParams{1}(i,5) = 0; cParams{1}(i,6) = 0; cParams{1}(i,7) = 0; cParams{1}(i,8) = 0;
        cParams{2}(i,5) = 0; cParams{2}(i,6) = 0; cParams{2}(i,7) = 0; cParams{2}(i,8) = 0;
        cParams{3}(i,5) = 0; cParams{3}(i,6) = 0; cParams{3}(i,7) = 0; cParams{3}(i,8) = 0;
    elseif size(cParams{1}, 2) == 5
        % --- Set the LSE, LSI and LSW components to zero
        cParams{1}(i,6) = 0; cParams{1}(i,7) = 0; cParams{1}(i,8) = 0;
        cParams{2}(i,6) = 0; cParams{2}(i,7) = 0; cParams{2}(i,8) = 0;
        cParams{3}(i,6) = 0; cParams{3}(i,7) = 0; cParams{3}(i,8) = 0;
    elseif size(cParams{1}, 2) == 6
        % --- Set the LSI and LSW components to zero
        cParams{1}(i,7) = 0; cParams{1}(i,8) = 0;
        cParams{2}(i,7) = 0; cParams{2}(i,8) = 0;
        cParams{3}(i,7) = 0; cParams{3}(i,8) = 0;
    elseif size(cParams{1}, 2) == 7
        % --- Set the LSW components to zero
        cParams{1}(i,8) = 0;
        cParams{2}(i,8) = 0;
        cParams{3}(i,8) = 0;
    elseif size(cParams{1}, 2) > 8 || size(cParams{1}, 2) < 4 
        error('Not enough input arguments defined - check cParams input!');
    end
end
% - Validity check on values of curve parameters
for i = 1:3
    % --- if INT < 0, then make it 0
    matrix = []; matrix = cParams{i}(:,2); matrix(matrix<0) = 0; cParams{i}(:,2) = matrix;
    % --- if FWHM < 0, then make it 0
    matrix = []; matrix = cParams{i}(:,3); matrix(matrix<0) = 0; cParams{i}(:,3) = matrix;
    % --- if MR < 0, then make it 0 (if MR > 1, then make it 1)
    matrix = []; matrix = cParams{i}(:,4); matrix(matrix<0) = 0; cParams{i}(:,4) = matrix;
    matrix = []; matrix = cParams{i}(:,4); matrix(matrix>1) = 0; cParams{i}(:,4) = matrix;
    % --- if LSI < 0, then make it 0
    matrix = []; matrix = cParams{i}(:,6); matrix(matrix<0) = 0; cParams{i}(:,6) = matrix;
    % --- if LSW < 0, then make it 0
    matrix = []; matrix = cParams{i}(:,7); matrix(matrix<0) = 0; cParams{i}(:,7) = matrix;
    % --- if ASY < 0, then make it 0
    matrix = []; matrix = cParams{i}(:,8); matrix(matrix<0) = 0; cParams{i}(:,8) = matrix;
end
% -- Ensuring consistency in the vector definitions
if iscolumn(xdat) && isrow(ydat); ydat = ydat';
elseif isrow(xdat) && iscolumn(ydat); xdat = xdat';
elseif isrow(xdat) && isrow(ydat); xdat = xdat'; ydat = ydat';
end
%% - 1 - Background subtraction of data
[X, D, B] = PES_BgrndSubCurve(xdat, ydat, bType, bParams{:});
%% - 2 - Extracting all model data
% -- Total number of states to be fitted
nStates     = length(cType);
% -- Initialising the vectors to contain XPS data
DB          = D - B;      	        % Data after being background subtracted
M           = zeros(size(X));      	% XPS model data
% -- Filing through all curve components and extracting them seperately
cYY = [];
for i = 1:nStates
   	cYY(:,i) = PES_SpecIntCurve(X, cType(i),...
        cParams{1}(i,1), cParams{1}(i,2), cParams{1}(i,3),...
        cParams{1}(i,4), cParams{1}(i,5), cParams{1}(i,6),...
        cParams{1}(i,7), cParams{1}(i,8));
    M = M + cYY(:,i);
end
%% - 3 - Determination of the residuals and chi-squared
R           = M - (D - B);              % Residuals
COST_R2     = sum(R.^2);                % Cost Function: Sum of Squared Residuals
COST_CHISQ  = sum(R.^2 ./ abs(M));	    % Cost Function: Chi-squared
COST_STD_RESID   = sqrt(sum(R.^2) ./ (length(R) - 2));  % Cost Function: Standard Deviation of the Residuals

%% - 4 - Plotting best fit model
% - Initialising the figure object
fig = figure(); 
fig.Position(1) = 100; fig.Position(2) = 100; 
fig.Position(3) = 800; fig.Position(4) = 450;
cols = lines(nStates+5);
% -- Creating a tiled axis
t = tiledlayout(4,2); t.TileSpacing = 'compact'; t.Padding = 'compact';
%% - 4.1 - Plotting the background subtraction method
nexttile([4,1]); hold on;
% - Extracting variables
ROI     = [X(1), X(end)]; 
LHS     = ROI(1) + [-1,1].*bParams{3};
RHS     = ROI(2) + [-1,1].*bParams{3};
% -- Plotting the ROI, LHS and RHS analysis windows
hMID    = patch([ROI(1), ROI(1), ROI(2), ROI(2), ROI(1)], [0, 1, 1, 0, 0].*2*max(ydat(:)), [0.8 0.8 0.8], 'facealpha', 0.5, 'edgecolor', 'none');
hLHS    = patch([LHS(1), LHS(1), LHS(2), LHS(2), LHS(1)], [0, 1, 1, 0, 0].*2*max(ydat(:)), [0.2 0.7 0.2], 'facealpha', 0.2, 'edgecolor', 'none');
hRHS    = patch([RHS(1), RHS(1), RHS(2), RHS(2), RHS(1)], [0, 1, 1, 0, 0].*2*max(ydat(:)), [0.2 0.7 0.2], 'facealpha', 0.2, 'edgecolor', 'none');
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
plot(xdat, ydat, 'b-', 'linewidth', 0.5);
plot(X, D, 'b-', 'linewidth', 1.5);
plot(X, DB, 'k-', 'linewidth', 1.5);
plot(X, B, 'r-', 'linewidth', 1.5);
title('Background Subtraction'); 
ylabel('$$ \bf  X $$', 'Interpreter', 'latex');
xlabel('$$ \bf  Y $$', 'Interpreter', 'latex');
legend({'Initial Data', 'ROI: Data', 'ROI: Background', 'ROI: Final'}, 'location', 'best', 'fontsize', 8);
% -- Determining the best limits for the plot
axLim_y = [D; DB];
axLim_x = [mean(X(:)) - abs(0.65*range(X(:))); mean(X(:)) + abs(0.65*range(X(:)));];
axis([axLim_x(1), axLim_x(2), min(axLim_y(:)), 1.05*max(axLim_y(:))]);
% Font properties
ax = gca;
ax.FontName         = 'Segoe UI'; 
ax.FontWeight       = 'normal'; 
ax.FontSize         = 10;
%% - 4.2 - Plotting the best fit curve components
nexttile([3,1]); hold on;
% -- Plotting all of the curve components
for i = 1:nStates
    area(X, cYY(:,i), 'FaceColor', cols(i,:), 'FaceAlpha', 0.50, 'EdgeAlpha', 0);
    plot(X, cYY(:,i), 'k-', 'linewidth', 0.25);
end
% -- Plotting the curve component energy locations
for i = 1:nStates
    if i == 1; lWidth = 2; else; lWidth = 1; end
    line([cParams{1}(i,1), cParams{1}(i,1)], [0, max(cYY(:,i))],...
        'Color', [0 0 0], 'LineWidth', lWidth, 'Linestyle', '-');
end
% -- Plotting the peak uncertainties
for i = 1:nStates
    % --- Plotting the primary peak uncertainties
    lbBE  	= cParams{2}(i,1); ubBE      = cParams{3}(i,1);
    lbINT  	= cParams{2}(i,2); ubINT     = cParams{3}(i,2);
    x_vals = [lbBE, lbBE, ubBE, ubBE, lbBE];
    y_vals = [lbINT, ubINT, ubINT, lbINT, lbINT];
    patch(x_vals, y_vals, cols(i,:), 'FaceAlpha', 0.65, 'EdgeAlpha', 0);
    % --- Adding text to identify each peak index
    text(max(x_vals), max(y_vals), string(i), 'interpreter', 'latex', 'fontsize', 14, 'color', 'k');
    % --- Plotting the spin-orbit split (SOS) peak uncertainties
    BE      = cParams{1}(i,1);   INT     = cParams{1}(i,2);
    lbLSE  	= cParams{2}(i,5);   ubLSE	= cParams{3}(i,5);
    lbLSI  	= cParams{2}(i,6);   ubLSI	= cParams{3}(i,6);
    x_vals  = BE + [lbLSE, lbLSE, ubLSE, ubLSE, lbLSE];
    y_vals  = [lbINT*lbLSI, ubINT*ubLSI, ubINT*ubLSI, lbINT*lbLSI, lbINT*lbLSI];
    patch(x_vals, y_vals, cols(i,:), 'FaceAlpha', 0.65, 'EdgeAlpha', 0);
end
% -- Plotting the experimental and fit spectra
plot(X, DB, 'k-', 'color', 'r', 'linewidth', 2.5);
plot(X, M, 'k-', 'Color', 'k', 'linewidth', 1.5);
% -- Add annotation for the quality of fit
text(0.04, 0.90, sprintf("R^2 = %.4e", COST_STD_RESID),'fontsize', 8, 'color', 'k', 'Units','normalized');
text(0.04, 0.95, sprintf("X^2 = %.4e", COST_CHISQ),'fontsize', 8, 'color', 'k', 'Units','normalized');
% - Formatting the figure
title('Initial Curve Guess & Residuals'); 
ylabel('$$ \bf  X $$', 'Interpreter', 'latex');
xlabel('$$ \bf  Y $$', 'Interpreter', 'latex');
axis([min(X(:)), max(X(:)), min(DB(:)), 1.10*max(DB(:))]);
% Font properties
ax = gca;
ax.FontName         = 'Segoe UI'; 
ax.FontWeight       = 'normal'; 
ax.FontSize         = 10;
%% - 4.3 - Plotting the residuals
nexttile([1,1]); hold on;
bar(X, R, 'facecolor', [0 0 0]);
ylabel('$$ \bf  Resid. $$', 'Interpreter', 'latex');
xlabel('$$ \bf  E_B - E_F (eV) $$', 'Interpreter', 'latex');
% Font properties
ax = gca;
ax.FontName         = 'Segoe UI'; 
ax.FontWeight       = 'normal'; 
ax.FontSize         = 10;
end