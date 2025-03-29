function [xVal, yVal] = find_peak_loc(xdat, ydat, xWin, type, plot_result)
% [xVal, yVal] = find_peak_loc(xdat, ydat, xWin, type, plot_result)
%   This function is used to determine both the maximum value and position of
%   a dataset using a range of different methods; raw maximum, spline interpolation, 
%   derivative or direct curve fitting a gaussian / voigt function. 
%
%   IN:
%   -   xdat:           [N×1] column vector of the input domain.
%   -   ydat:           [N×1] column vector of the output range.
%   -   xWin:           [M×2] array that contains the x-windows where N peaks are expected to be found.
%   -   type:           string of the type of method to use. Default: "spline" ("raw","spline","gaco1","dydx","dy2d2x","G","L","sGL","pGL","sGLA","pGLA").
%   -   plot_result:    if 1, will plot figure summary, otherwise it wont.
%
%   OUT:
%   -   xVal:           scalar or [M×1] column vector of the maxima x-values.
%   -   yVal:           scalar or [M×1] column vector of the maxima y-values.

%% Default parameters
if nargin < 3; xWin = []; end
if nargin < 4; type = ""; end
if nargin < 5; plot_result = 0; end
if isempty(xWin); xWin = []; end
if isempty(type); type = ""; end
if isempty(plot_result); plot_result = 0; end
%% Validity checks on the input parameters
%-- Ensuring the data is in the form of 1D column vectors
if isrow(xdat); xdat = xdat'; end   % -- Ensure x-data is a column vector
if isrow(ydat); ydat = ydat'; end   % -- Ensure y-data is a column vector
type    = string(type);             % -- Ensure the type is a string
% -- Making the default window-size if it is undefined
if isempty(xWin)
    minWin  = mean(xdat(:)) - abs(0.475*range(xdat(:)));
    maxWin  = mean(xdat(:)) + abs(0.475*range(xdat(:)));
    xWin    = [minWin, maxWin];
end
% -- Making sure the window-size is an M×2 array
if size(xWin, 2) ~= 2; xWin = xWin'; end
%% - 1 - Finding the peak locations and values
xVal = []; yVal = [];
xx = {}; yy = {};
% - Filing through all the windows
for i = 1:size(xWin, 1)
    % -- Finding the indices and ROI
    [~, lbIndx]             = min(abs(xdat - xWin(i,1)));
    [~, ubIndx]             = min(abs(xdat - xWin(i,2)));
    Indxs                   = [lbIndx, ubIndx];
    xdat_roi{i}             = xdat(Indxs(1):Indxs(2));
    ydat_roi{i}             = ydat(Indxs(1):Indxs(2));
    % -- Selecting the appropriate method to use
    switch lower(type)
        % -- Finding the maximum peak value from the raw data
        case {lower(""),lower("none"),lower("raw"),lower("R")}
            xx{i}             	    = xdat_roi{i};
            yy{i}             	    = ydat_roi{i};
            % ---- Storing peak values
            [yVal(i), maxInd]	    = max(yy{i}(:));
            xVal(i)           	    = xx{i}(maxInd);
        % -- Finding the maximum peak value by fitting a spline
        case {lower("S"), lower("spline")}
            Npoints                 = 5*length(xdat_roi{i}(:));
            xx{i}                   = linspace(min(xdat_roi{i}(:)), max(xdat_roi{i}(:)), Npoints);
            yy{i}                   = interp1(xdat_roi{i}, ydat_roi{i}, xx{i}, 'spline');
            if isrow(xx{i}); xx{i} = xx{i}'; end
            if isrow(yy{i}); yy{i} = yy{i}'; end
            % ---- Storing peak values
            [yVal(i), maxInd]	    = max(yy{i}(:));
            xVal(i)           	    = xx{i}(maxInd);
        % -- Finding the maximum peak value from the Gaussian smoothed data
        case {lower("G1"), lower("gaco1")}
            Npoints                 = 5*length(xdat_roi{i}(:));
            xx{i}                   = linspace(min(xdat_roi{i}(:)), max(xdat_roi{i}(:)), Npoints);
            yy{i}                   = interp1(xdat_roi{i}, ydat_roi{i}, xx{i}, 'linear');
            yy{i}                   = Gaco1(yy{i}, ceil(0.01*Npoints));
            if isrow(xx{i}); xx{i} = xx{i}'; end
            if isrow(yy{i}); yy{i} = yy{i}'; end
            % ---- Storing peak values
            [yVal(i), maxInd]	    = max(yy{i}(:));
            xVal(i)           	    = xx{i}(maxInd);
        % -- Finding the maximum peak value from the 1st derivative
        case {lower("D1"), lower("dydx"), lower("der1")}
            Npoints                 = 5*length(xdat_roi{i}(:));
            xx{i}                   = linspace(min(xdat_roi{i}(:)), max(xdat_roi{i}(:)), Npoints);
            yy{i}                   = interp1(xdat_roi{i}, ydat_roi{i}, xx{i}, 'spline');
            if isrow(xx{i}); xx{i} = xx{i}'; end
            if isrow(yy{i}); yy{i} = yy{i}'; end
            % ---- Finding the First derivative
            dx                      = abs(xx{i}(1) - xx{i}(2));
            dydx{i}                 = diff(yy{i}(:),1) ./ diff(xx{i}(:),1);
            dydx_x{i}               = 0.5*dx + xx{i}(1:length(dydx{i}));
            [~, indx]               = min(abs(dydx{i} - 0));
            % ---- Storing peak values
            xVal(i)                 = dydx_x{i}(indx);
            [~, indx]               = min(abs(xx{i} - xVal(i)));
            yVal(i)                 = yy{i}(indx);
        % -- Finding the maximum peak value from the 2nd derivative
        case {lower("D2"),lower("d2ydx2"), lower("der2")}
            Npoints                 = 5*length(xdat_roi{i}(:));
            xx{i}                   = linspace(min(xdat_roi{i}(:)), max(xdat_roi{i}(:)), Npoints);
            yy{i}                   = interp1(xdat_roi{i}, ydat_roi{i}, xx{i}, 'spline');
            if isrow(xx{i}); xx{i} = xx{i}'; end
            if isrow(yy{i}); yy{i} = yy{i}'; end
            % ---- Finding the Second derivative
            dx                      = abs(xx{i}(1) - xx{i}(2));
            d2ydx2{i}               = abs(diff(yy{i}(:),2) ./ dx.^2);
            d2ydx2_x{i}             = dx + xx{i}(1:length(d2ydx2{i}));
            [~, indx]               = max(d2ydx2{i});
            % ---- Storing peak values
            xVal(i)                 = d2ydx2_x{i}(indx);
            [~, indx]               = min(abs(xx{i} - xVal(i)));
            yVal(i)                 = yy{i}(indx);
        % -- Finding the maximum peak value by fitting a gaussian
        case {lower("G"), lower("gauss"), lower("gaussian")}
            Npoints                 = 5*length(xdat_roi{i}(:));
            xx{i}                   = linspace(min(xdat_roi{i}(:)), max(xdat_roi{i}(:)), Npoints);
            yy{i}                   = interp1(xdat_roi{i}, ydat_roi{i}, xx{i}, 'pchip');
            if isrow(xx{i}); xx{i} = xx{i}'; end
            if isrow(yy{i}); yy{i} = yy{i}'; end
            % --- Defining the fit function
            fit_func                = fittype(@(x0, peak, fwhm, x) GaussianModel(x, x0, peak, fwhm));
            x0_start                = mean(xdat_roi{i}(:));
            peak_start              = max(ydat_roi{i}(:));
            fwhm_start              = 0.5*range(xdat_roi{i}(:));
            % --- Executing the fitting operation
            [fit1,~,~]	            = fit(xx{i},yy{i},fit_func,'start',[x0_start, peak_start, fwhm_start]);
            params    	            = coeffvalues(fit1);
            yy{i}	                = GaussianModel(xx{i}, params(1), params(2), params(3));
            [yVal(i), maxInd]	    = max(yy{i}(:));
            xVal(i)           	    = xx{i}(maxInd);
        % -- Finding the maximum peak value by fitting a lorentzian
        case {lower("L"), lower("lorz"), lower("lorentzian")}
            Npoints                 = 5*length(xdat_roi{i}(:));
            xx{i}                   = linspace(min(xdat_roi{i}(:)), max(xdat_roi{i}(:)), Npoints);
            yy{i}                   = interp1(xdat_roi{i}, ydat_roi{i}, xx{i}, 'pchip');
            if isrow(xx{i}); xx{i} = xx{i}'; end
            if isrow(yy{i}); yy{i} = yy{i}'; end
            % --- Defining the fit function
            fit_func                = fittype(@(x0, peak, fwhm, x) LorentzianModel(x, x0, peak, fwhm));
            x0_start                = mean(xdat_roi{i}(:));
            peak_start              = max(ydat_roi{i}(:));
            fwhm_start              = 0.5*range(xdat_roi{i}(:));
            % --- Executing the fitting operation
            [fit1,~,~]	            = fit(xx{i},yy{i},fit_func,'start',[x0_start, peak_start, fwhm_start]);
            params    	            = coeffvalues(fit1);
            yy{i}	                = LorentzianModel(xx{i}, params(1), params(2), params(3));
            [yVal(i), maxInd]	    = max(yy{i}(:));
            xVal(i)           	    = xx{i}(maxInd);
        % -- Finding the maximum peak value by fitting a summed voigt
        case lower("sGL")
            Npoints                 = 5*length(xdat_roi{i}(:));
            xx{i}                   = linspace(min(xdat_roi{i}(:)), max(xdat_roi{i}(:)), Npoints);
            yy{i}                   = interp1(xdat_roi{i}, ydat_roi{i}, xx{i}, 'pchip');
            if isrow(xx{i}); xx{i} = xx{i}'; end
            if isrow(yy{i}); yy{i} = yy{i}'; end
            % --- Defining the fit function
            fit_func                = fittype(@(x0, peak, fwhm, mr, x) PseudoVoigtModel_sGL(x, x0, peak, fwhm, mr));
            x0_start                = mean(xdat_roi{i}(:));
            peak_start              = max(ydat_roi{i}(:));
            fwhm_start              = 0.5*range(xdat_roi{i}(:));
            mr_start                = 0.5;
            % --- Executing the fitting operation
            [fit1,~,~]	            = fit(xx{i},yy{i},fit_func,'start',[x0_start, peak_start, fwhm_start, mr_start]);
            params    	            = coeffvalues(fit1);
            yy{i}	                = PseudoVoigtModel_sGL(xx{i}, params(1), params(2), params(3), params(4));
            [yVal(i), maxInd]	    = max(yy{i}(:));
            xVal(i)           	    = xx{i}(maxInd);
        % -- Finding the maximum peak value by fitting a multiplied voigt
        case lower("pGL")
            Npoints                 = 5*length(xdat_roi{i}(:));
            xx{i}                   = linspace(min(xdat_roi{i}(:)), max(xdat_roi{i}(:)), Npoints);
            yy{i}                   = interp1(xdat_roi{i}, ydat_roi{i}, xx{i}, 'pchip');
            if isrow(xx{i}); xx{i} = xx{i}'; end
            if isrow(yy{i}); yy{i} = yy{i}'; end
            % --- Defining the fit function
            fit_func                = fittype(@(x0, peak, fwhm, mr, x) PseudoVoigtModel_pGL(x, x0, peak, fwhm, mr));
            x0_start                = mean(xdat_roi{i}(:));
            peak_start              = max(ydat_roi{i}(:));
            fwhm_start              = 0.5*range(xdat_roi{i}(:));
            mr_start                = 0.5;
            % --- Executing the fitting operation
            [fit1,~,~]	            = fit(xx{i},yy{i},fit_func,'start',[x0_start, peak_start, fwhm_start, mr_start]);
            params    	            = coeffvalues(fit1);
            yy{i}	                = PseudoVoigtModel_pGL(xx{i}, params(1), params(2), params(3), params(4));
            [yVal(i), maxInd]	    = max(yy{i}(:));
            xVal(i)           	    = xx{i}(maxInd);
        % -- Finding the maximum peak value by fitting a summed, asymmetric voigt
        case lower("sGLA")
            Npoints                 = 5*length(xdat_roi{i}(:));
            xx{i}                   = linspace(min(xdat_roi{i}(:)), max(xdat_roi{i}(:)), Npoints);
            yy{i}                   = interp1(xdat_roi{i}, ydat_roi{i}, xx{i}, 'pchip');
            if isrow(xx{i}); xx{i} = xx{i}'; end
            if isrow(yy{i}); yy{i} = yy{i}'; end
            % --- Defining the fit function
            fit_func                = fittype(@(x0, peak, fwhm, mr, asym, x) PseudoVoigtModel_sGLA(x, x0, peak, fwhm, mr, asym));
            x0_start                = mean(xdat_roi{i}(:));
            peak_start              = max(ydat_roi{i}(:));
            fwhm_start              = 0.5*range(xdat_roi{i}(:));
            mr_start                = 0.5;
            asym_start              = 0.0;
            % --- Executing the fitting operation
            [fit1,~,~]	            = fit(xx{i},yy{i},fit_func,'start',[x0_start, peak_start, fwhm_start, mr_start, asym_start]);
            params    	            = coeffvalues(fit1);
            yy{i}	                = PseudoVoigtModel_sGLA(xx{i}, params(1), params(2), params(3), params(4), params(5));
            [yVal(i), maxInd]	    = max(yy{i}(:));
            xVal(i)           	    = xx{i}(maxInd);
        % -- Finding the maximum peak value by fitting a multiplied, asymmetric voigt
        case lower("pGLA")
            Npoints                 = 5*length(xdat_roi{i}(:));
            xx{i}                   = linspace(min(xdat_roi{i}(:)), max(xdat_roi{i}(:)), Npoints);
            yy{i}                   = interp1(xdat_roi{i}, ydat_roi{i}, xx{i}, 'pchip');
            if isrow(xx{i}); xx{i} = xx{i}'; end
            if isrow(yy{i}); yy{i} = yy{i}'; end
            % --- Defining the fit function
            fit_func                = fittype(@(x0, peak, fwhm, mr, asym, x) PseudoVoigtModel_pGLA(x, x0, peak, fwhm, mr, asym));
            x0_start                = mean(xdat_roi{i}(:));
            peak_start              = max(ydat_roi{i}(:));
            fwhm_start              = 0.5*range(xdat_roi{i}(:));
            mr_start                = 0.5;
            asym_start              = 0.0;
            % --- Executing the fitting operation
            [fit1,~,~]	            = fit(xx{i},yy{i},fit_func,'start',[x0_start, peak_start, fwhm_start, mr_start, asym_start]);
            params    	            = coeffvalues(fit1);
            yy{i}	                = PseudoVoigtModel_pGLA(xx{i}, params(1), params(2), params(3), params(4), params(5));
            [yVal(i), maxInd]	    = max(yy{i}(:));
            xVal(i)           	    = xx{i}(maxInd);
        % -- Peak finder type not recognised
        otherwise; error('Peak-finding type not found.');
    end
end
%% Validity check on the outputs
if isrow(xVal); xVal = xVal'; end   % -- Ensure x peak locs are a column vector
if isrow(yVal); yVal = yVal'; end   % -- Ensure y peak vals are a column vector
%% -- For Debugging
if plot_result == 1
    fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450;
    hold on;
    % Plotting the data
    plot(xdat, ydat, 'k-', 'linewidth', 0.5);
    % Plotting the outcome of the peak finder
    cols = parula(length(yVal) +1);
    for i = 1:size(xWin, 1)
        plot(xx{i}, yy{i}, 'r-', 'color', cols(i,:),  'linewidth', 2.5);
        plot(xdat_roi{i}, ydat_roi{i}, 'r-', 'linewidth', 1);
        plot(xVal(i), yVal(i), '.', 'markersize', 25, 'color', cols(i,:));
        line([1 1].*xVal(i), [0, yVal(i)], 'Color', cols(i,:), 'LineWidth', 1.5, 'Linestyle', '-');
        fprintf(("%i) x = %.2f, y = %.2f \n"), i, xVal(i), yVal(i));
    end
    % - Formatting the figure
    title(sprintf("find_peak_loc() - %s", type), 'interpreter', 'none'); 
    xlabel(' X ', 'fontweight', 'bold');
    ylabel(' Y ', 'fontweight', 'bold');
    if min(ydat(:)) ~= max(yVal(:))
        axis([mean(xWin(:))-0.75*(range(xWin(:))), mean(xWin(:))+0.75*(range(xWin(:))),...
            0.95*min(cell2mat(ydat_roi(:))), 1.05.*max(cell2mat(ydat_roi(:)))]);
    end
    % - Plotting the derivatives if required
    switch lower(type)
        case {lower("D1"), lower("dydx"), lower("der1")}
            yyaxis right; 
            ax = gca; ax.YColor = [0 0 1];
            plot(dydx_x{i}, dydx{i}, 'b-');
            xline(0, 'color', [0 0 1], 'LineStyle',':'); 
            yline(0, 'color', [0 0 1], 'LineStyle',':');
            ylabel(' dY/dX ', 'fontweight', 'bold');
        case {lower("D2"),lower("d2ydx2"), lower("der2")}
            yyaxis right; 
            ax = gca; ax.YColor = [0 0 1];
            plot(d2ydx2_x{i}, d2ydx2{i}, 'b-');
            xline(0, 'color', [0 0 1], 'LineStyle',':'); 
            yline(0, 'color', [0 0 1], 'LineStyle',':');
            ylabel(' d2Y/dX2 ', 'fontweight', 'bold');
    end
end
end