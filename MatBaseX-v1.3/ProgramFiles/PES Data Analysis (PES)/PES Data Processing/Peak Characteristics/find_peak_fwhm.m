function [fwhm, fwhmLocs] = find_peak_fwhm(xdat, ydat, xWin, type, plot_result)
% [fwhm, fwhmLocs] = find_peak_fwhm(xdat, ydat, xWin, type, plot_result)
%   This function is used to determine both the fwhm of a data set using 
%   a range of different methods; spline interpolation or curve fitting a 
%   gaussian / voigt function. 
%
%   IN:
%   -   xdat:           [N×1] column vector of the input domain.
%   -   ydat:           [N×1] column vector of the output range.
%   -   xWin:           [N×2] array that contains the x-windows where N peaks are expected to be found.
%   -   type:           string of the type of method to use. Default: "spline" ("raw","spline","gaco1","G","L","sGL","pGL","sGLA","pGLA").
%   -   plot_result:    if 1, will plot figure summary, otherwise it wont.
%
%   OUT:
%   -   fwhm:           scalar or [N×1] column vector of the fwhm of each peak defined.
%   -   fwhmLocs:   	[2N×2] column vector of the fwhm positions.

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
%% 1 - Extracting the FWHM
xVal = []; yVal = []; fwhm = [];
xx = {}; yy = {};
for i = 1:size(xWin, 1)
    % -- Finding the indices and ROI
    [~, lbIndx]             = min(abs(xdat - xWin(i,1)));
    [~, ubIndx]             = min(abs(xdat - xWin(i,2)));
    Indxs                   = [lbIndx, ubIndx];
    xdat_roi{i}             = xdat(Indxs(1):Indxs(2));
    ydat_roi{i}             = ydat(Indxs(1):Indxs(2));
    % ---- Finding peak value
    [xVal(i), yVal(i)]            = find_peak_loc(xdat, ydat, xWin(i,:), type, 0);
    % -- Selecting the appropriate method to use
    switch lower(type)
        % -- Finding the FWHM from the raw data
        case {lower(""),lower("none"),lower("raw"),lower("R")}
            xx{i}             	    = xdat_roi{i};
            yy{i}             	    = ydat_roi{i};
            if isrow(xx{i}); xx{i}  = xx{i}'; end
            if isrow(yy{i}); yy{i}  = yy{i}'; end
            % ---- Finding FWHM
            yHalf(i)                = 0.5*yVal(i);                              % Find the half max value
            index1                  = find(yy{i}(:) >= yHalf(i), 1, 'first');   % Find where the data first drops below half the max
            index2                  = find(yy{i}(:) >= yHalf(i), 1, 'last');    % Find where the data last rises above half the max
            fwhm(i)                 = abs(xx{i}(index2) - xx{i}(index1));       % Extracting FWHM
            fwhmLocs{i,1}    	    = [xx{i}(index1), yy{i}(index1); xx{i}(index2), yy{i}(index2)];
        % -- Finding the maximum peak value by fitting a spline
        case {lower("S"), lower("spline")}
            Npoints                 = 5*length(xdat_roi{i}(:));
            xx{i}                   = linspace(min(xdat_roi{i}(:)), max(xdat_roi{i}(:)), Npoints);
            yy{i}                   = interp1(xdat_roi{i}, ydat_roi{i}, xx{i}, 'spline');
            if isrow(xx{i}); xx{i} = xx{i}'; end
            if isrow(yy{i}); yy{i} = yy{i}'; end
            % ---- Finding FWHM
            yHalf(i)                = 0.5*yVal(i);                              % Find the half max value
            index1                  = find(yy{i}(:) >= yHalf(i), 1, 'first');   % Find where the data first drops below half the max
            index2                  = find(yy{i}(:) >= yHalf(i), 1, 'last');    % Find where the data last rises above half the max
            fwhm(i)                 = abs(xx{i}(index2) - xx{i}(index1));       % Extracting FWHM
            fwhmLocs{i,1}    	    = [xx{i}(index1), yy{i}(index1); xx{i}(index2), yy{i}(index2)];
        % -- Finding the maximum peak value from the Gaussian smoothed data
        case {lower("G1"), lower("gaco1")}
            Npoints                 = 5*length(xdat_roi{i}(:));
            xx{i}                   = linspace(min(xdat_roi{i}(:)), max(xdat_roi{i}(:)), Npoints);
            yy{i}                   = interp1(xdat_roi{i}, ydat_roi{i}, xx{i}, 'linear');
            yy{i}                   = Gaco1(yy{i}, ceil(0.01*Npoints));
            if isrow(xx{i}); xx{i} = xx{i}'; end
            if isrow(yy{i}); yy{i} = yy{i}'; end
            % ---- Finding FWHM
            yHalf(i)                = 0.5*yVal(i);                              % Find the half max value
            index1                  = find(yy{i}(:) >= yHalf(i), 1, 'first');   % Find where the data first drops below half the max
            index2                  = find(yy{i}(:) >= yHalf(i), 1, 'last');    % Find where the data last rises above half the max
            fwhm(i)                 = abs(xx{i}(index2) - xx{i}(index1));       % Extracting FWHM
            fwhmLocs{i,1}    	    = [xx{i}(index1), yy{i}(index1); xx{i}(index2), yy{i}(index2)];
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
            % ---- Finding FWHM
            fwhm(i)                 = params(3);
            [~, index1]             = min(abs(xx{i} - xVal(i) - 0.5*fwhm(i)));
            [~, index2]             = min(abs(xx{i} - xVal(i) + 0.5*fwhm(i)));
            fwhmLocs{i,1}    	    = [xx{i}(index1), yy{i}(index1); xx{i}(index2), yy{i}(index2)];
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
            % ---- Finding FWHM
            fwhm(i)                 = params(3);
            [~, index1]             = min(abs(xx{i} - xVal(i) - 0.5*fwhm(i)));
            [~, index2]             = min(abs(xx{i} - xVal(i) + 0.5*fwhm(i)));
            fwhmLocs{i,1}    	    = [xx{i}(index1), yy{i}(index1); xx{i}(index2), yy{i}(index2)];
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
            % ---- Finding FWHM
            fwhm(i)                 = params(3);
            [~, index1]             = min(abs(xx{i} - xVal(i) - 0.5*fwhm(i)));
            [~, index2]             = min(abs(xx{i} - xVal(i) + 0.5*fwhm(i)));
            fwhmLocs{i,1}    	    = [xx{i}(index1), yy{i}(index1); xx{i}(index2), yy{i}(index2)];
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
            % ---- Finding FWHM
            fwhm(i)                 = params(3);
            [~, index1]             = min(abs(xx{i} - xVal(i) - 0.5*fwhm(i)));
            [~, index2]             = min(abs(xx{i} - xVal(i) + 0.5*fwhm(i)));
            fwhmLocs{i,1}    	    = [xx{i}(index1), yy{i}(index1); xx{i}(index2), yy{i}(index2)];
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
            % ---- Finding FWHM
            fwhm(i)                 = params(3);
            [~, index1]             = min(abs(xx{i} - xVal(i) - 0.5*fwhm(i)));
            [~, index2]             = min(abs(xx{i} - xVal(i) + 0.5*fwhm(i)));
            fwhmLocs{i,1}    	    = [xx{i}(index1), yy{i}(index1); xx{i}(index2), yy{i}(index2)];
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
            % ---- Finding FWHM
            fwhm(i)                 = params(3);
            [~, index1]             = min(abs(xx{i} - xVal(i) - 0.5*fwhm(i)));
            [~, index2]             = min(abs(xx{i} - xVal(i) + 0.5*fwhm(i)));
            fwhmLocs{i,1}    	    = [xx{i}(index1), yy{i}(index1); xx{i}(index2), yy{i}(index2)];
        % -- Peak finder type not recognised
        otherwise; error('Peak-finding type not found.');
    end
end
fwhmLocs                = cell2mat(fwhmLocs);
%% Validity check on the outputs
if isrow(fwhm); fwhm = fwhm'; end   % -- Ensure fwhms are a column vector
%% -- For Debugging
if plot_result == 1
    fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450;
    hold on;
    % Plotting the data
    plot(xdat, ydat, 'k-', 'linewidth', 0.5);
    cols = parula(length(fwhm) +1);
    % Plotting the outcome of the peak finder
    for i = 1:size(xWin, 1)
        plot(xx{i}, yy{i}, 'r-', 'color', cols(i,:),  'linewidth', 2.5);
        plot(xdat_roi{i}, ydat_roi{i}, 'r-', 'linewidth', 1);
        % -- Plotting peak position
        plot(xVal(i), yVal(i), '.', 'markersize', 20, 'color', cols(i,:));
        line([1 1].*xVal(i), [0, yVal(i)], 'Color', cols(i,:), 'LineWidth', 1.5, 'Linestyle', '-');
        % -- Plotting LHS point
        plot(fwhmLocs(2*i-1,1), fwhmLocs(2*i-1,2), '.', 'markersize', 25, 'color', cols(i,:));
        line([1 1].*fwhmLocs(2*i-1,1), [0, yVal(i)], 'Color', cols(i,:), 'LineWidth', 1.0, 'Linestyle', ':');
        % -- Plotting RHS point
        plot(fwhmLocs(2*i,1), fwhmLocs(2*i,2), '.', 'markersize', 25, 'color', cols(i,:));
        line([1 1].*fwhmLocs(2*i,1), [0, yVal(i)], 'Color', cols(i,:), 'LineWidth', 1.0, 'Linestyle', ':');
        % -- Printing useful information
        fprintf(("%i) x = %.2f, y = %.2f, fwhm = %.2f \n"), i, xVal(i), yVal(i), fwhm(i));
    end
    % - Formatting the figure
    title(sprintf("find_peak_fwhm() - %s", type), 'interpreter', 'none'); 
    xlabel(' X ', 'fontweight', 'bold');
    ylabel(' Y ', 'fontweight', 'bold');
    axis([mean(xWin(:))-0.75*range(xWin(:)), mean(xWin(:))+0.75*range(xWin(:)), min(ydat(:)), 1.10.*max(yVal(:))]);
end

end