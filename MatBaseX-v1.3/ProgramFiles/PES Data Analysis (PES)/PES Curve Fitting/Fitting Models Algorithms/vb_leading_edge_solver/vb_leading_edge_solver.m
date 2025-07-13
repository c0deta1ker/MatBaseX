function dataStr = vb_leading_edge_solver(xdat, ydat, bgrnd_type, eWin_bgrnd, eWin_edge, dESmooth, plot_results)
% dataStr = vb_leading_edge_solver(xdat, ydat, bgrnd_type, eWin_bgrnd, eWin_edge, dESmooth, plot_results)

%% Default parameters
if nargin < 7; plot_results = 1; end
if nargin < 6; dESmooth = 0; end
if isempty(plot_results);   plot_results = 1; end
if isempty(dESmooth);       dESmooth = 0; end
if isempty(eWin_edge);      eWin_edge = -0.75 + [-0.25, 0.25]; end
if isempty(eWin_bgrnd);     eWin_bgrnd = [-0.25, 0.25]; end
if isempty(bgrnd_type);     bgrnd_type = "poly0"; end

%% - 1 - Initialising the fitting parameters
% - Validity check on the inputs
eWin_bgrnd	= sort(eWin_bgrnd);
eWin_edge 	= sort(eWin_edge);
dESmooth    = abs(dESmooth);
%% - 2 - Extracting the relevant ROI cuts from the data
[xdat_bgrnd, ydat_bgrnd] = data_crop1D(xdat, ydat, eWin_bgrnd);
[xdat_edge, ydat_edge] = data_crop1D(xdat, ydat, eWin_edge);
if dESmooth ~= 0; ydat_bgrnd = Gaco1(ydat_bgrnd, dESmooth); end
if dESmooth ~= 0; ydat_edge = Gaco1(ydat_edge, dESmooth); end
XX          = linspace(min(xdat(:)), max(xdat(:)), 1e3)';
%% - 3 - Fitting a linear equation to the leading edge
% -- Fitting the data
fit_edge    = fit(xdat_edge, ydat_edge, 'poly1');
% - Extracting confidence interval for each coefficient
fitci_edge 	= abs(0.5*range(confint(fit_edge)));
% - Evaluating the best fit lines over a consistent domain
DD_edge     = fit_edge(XX);
% - Extracting confidence interval to be plotted as a patch
ci_edge     = predint(fit_edge, XX, 0.95, 'observation', 'off');
ciXX        = [XX;         flipud(XX)];
ciDD_edge	= [ci_edge(:,1); flipud(ci_edge(:,2))];
%% - 4 - Fitting a to the background
if bgrnd_type == "poly0"
    % -- Fitting the data
    fit_back.p1    = 0;
    fit_back.p2    = mean(ydat_bgrnd(:));
    % - Extracting confidence interval for each coefficient
    fitci_back 	= 3*std(ydat_bgrnd(:))*[1,1];
    % - Evaluating the best fit lines over a consistent domain
    DD_bgrnd     = zeros(size(XX))+fit_back.p2;
    % - Extracting confidence interval to be plotted as a patch
    ci_back     = [DD_bgrnd-fitci_back, DD_bgrnd+fitci_back];
    ciXX        = [XX;         flipud(XX)];
    ciDD_bgrnd	= [ci_back(:,1); flipud(ci_back(:,2))];
elseif bgrnd_type == "poly1"
    % -- Fitting the data
    fit_back    = fit(xdat_bgrnd, ydat_bgrnd, 'poly1');
    % - Extracting confidence interval for each coefficient
    fitci_back 	= abs(0.5*range(confint(fit_back)));
    % - Evaluating the best fit lines over a consistent domain
    DD_bgrnd     = fit_back(XX);
    % - Extracting confidence interval to be plotted as a patch
    ci_back     = predint(fit_back, XX, 0.95, 'observation', 'off');
    ciXX        = [XX;         flipud(XX)];
    ciDD_bgrnd	= [ci_back(:,1); flipud(ci_back(:,2))];
elseif bgrnd_type == "none"
    % -- Fitting the data
    fit_back.p1    = 0;
    fit_back.p2    = 0;
    % - Extracting confidence interval for each coefficient
    fitci_back 	= 3*std(0.*ydat_bgrnd(:))*[1,1];
    % - Evaluating the best fit lines over a consistent domain
    DD_bgrnd     = zeros(size(XX))+fit_back.p2;
    % - Extracting confidence interval to be plotted as a patch
    ci_back     = [DD_bgrnd-fitci_back, DD_bgrnd+fitci_back];
    ciXX        = [XX;         flipud(XX)];
    ciDD_bgrnd	= [ci_back(:,1); flipud(ci_back(:,2))];
end

%% - 5 - Finding the point of intersection and its uncertainty
% - Finding the mean value of the POI
a       = fit_back.p1;
c       = fit_back.p2;
b       = fit_edge.p1;
d       = fit_edge.p2;
coeff   = (d-c)./(a-b);
X0      = round(coeff, 3);
Y0      = round(a.*coeff + c, 3);
% - Finding the uncertainty in the POI
A       = fit_back.p1 + fitci_back(1);
C       = fit_back.p2 - fitci_back(2);
B       = fit_edge.p1 - fitci_edge(1);
D       = fit_edge.p2 + fitci_edge(2);
coeff   = (D-C)./(A-B);
dX0     = round(abs(X0 - (coeff)), 3);
dY0     = round(abs(Y0 - (A.*coeff + C)), 3);

%% - 5 - Plotting the fitting result
if plot_results == 1
    cols = lines(5);
    % -- Initialising the figure
    fig = figure(); 
    fig.Position(3) = 700; 
    fig.Position(4) = 350;
    hold on; box on;
    % -- Plotting the full EDC cut first
    plot(xdat, ydat, 'k.-', 'color', 'k', 'LineWidth', 0.50);
    % -- Plotting the fits to the EDC background
    patch(ciXX, ciDD_bgrnd, cols(1,:), 'EdgeAlpha', 0, 'facealpha', 0.25);
    plot(xdat_bgrnd, ydat_bgrnd, 'k.-', 'color', cols(1,:), 'LineWidth', 1.50);
    plot(XX, DD_bgrnd, 'k:', 'color', cols(1,:), 'LineWidth', 1.50);
    % -- Plotting the fits to the EDC leading edge
    patch(ciXX, ciDD_edge, cols(2,:), 'EdgeAlpha', 0, 'facealpha', 0.25);
    plot(xdat_edge, ydat_edge, 'g.-', 'color', cols(2,:), 'LineWidth', 1.50);
    plot(XX, DD_edge, 'g:', 'color', cols(2,:), 'LineWidth', 1.50);
    % -- Plotting the point of intersection    
    errorbar(X0, Y0, dY0, dY0, dX0, dX0, 'ko',...
        'markersize', 7, 'color', [0 0 0], 'markerfacecolor', [1 0 0]);
    % -- Add text to show the POI
    text(0.03, 0.93, "$$ E_{VBM} = (" + X0 +  " \pm " + dX0 + ") eV $$",...
        'interpreter', 'latex', 'fontsize', 14, 'color', 'k', 'Units','normalized');
    % -- Formatting the figure
    gca_props();
    ax = gca;
    ax.XAxisLocation = 'bottom';            % 'bottom' | 'top' | 'origin'
    ax.YAxisLocation = 'left';             % 'left' | 'right' | 'origin'
    % - Axis labels and limits
    xlabel('$$ \bf  E_{B} (eV) $$', 'Interpreter', 'latex');
    ylabel('$$ \bf  Intensity $$', 'Interpreter', 'latex');
    % - Plotting the x- and y-axes
    axis([min(xdat(:)), max(xdat(:)), min(ydat(:)), 1.25*max(ydat(:))]);
    % axis([-14, 1, min(ydat(:)), 1.25*max(ydat(:))]);
end

%% 6 - Appending data to MATLAB data structure
dataStr                 = struct();
dataStr.bgrnd_type      = bgrnd_type;
dataStr.eWin_bgrnd      = eWin_bgrnd;
dataStr.eWin_edge       = eWin_edge;
dataStr.dESmooth        = dESmooth;
% - Appending all the EDC cuts taken
dataStr.xdat            = xdat;
dataStr.ydat            = ydat;
dataStr.xdat_bgrnd  	= xdat_bgrnd;
dataStr.ydat_bgrnd  	= ydat_bgrnd;
dataStr.xdat_edge  	    = xdat_edge;
dataStr.ydat_edge  	    = ydat_edge;
% - Appending the best fits to the background and edge
dataStr.fit_back  	    = fit_back;
dataStr.fit_edge  	    = fit_edge;
dataStr.XX              = XX;
dataStr.DD_bgrnd  	    = DD_bgrnd;
dataStr.DD_edge  	    = DD_edge;
% - Appending the VBM position and its uncertainty
dataStr.VBM             = X0;
dataStr.dVBM            = dX0;
dataStr.VBM_int         = Y0;
dataStr.dVBM_int        = dY0;

end