function [roi_xdat, roi_ydat, roi_bgrnd] = pes_bgrnd_step_FDDGsL(xdat, ydat, LHS, RHS, Win, fdd_ef, fdd_T, fdd_fwhm)
% [roi_xdat, roi_ydat, roi_bgrnd] = pes_bgrnd_step_FDDGsL(xdat, ydat, LHS, RHS, Win, fdd_ef, fdd_T, fdd_fwhm)
%   Function that determines the best fit to the background of PES (or 1D) 
%   data using a single FDD step. Here, a linear background is
%   SUMMED to the FDD function, so the background is fitted to the
%   the gradient, intercept and constant.
%   
%   IN:
%   -   xdat:           N×1 (or 1xN) column (or row) vector of the input domain (binding energy for PES)
%   -   ydat:           N×1 (or 1xN) column (or row) vector of the intensity range (intensity for PES)
%   -   LHS:            scalar of the LHS x-axis position of the ROI
%   -   RHS:            scalar of the RHS x-axis position of the ROI
%   -   Win:            scalar of the averaging window size around the start/end position
%   -   fdd_ef:         scalar of the Fermi-level position (eV)
%   -   fdd_T:          scalar of the temperature (K)
%   -   fdd_fwhm:       scalar of the full-width at half-maximum (FWHM) of the Gaussian broadening term (eV)
%
%   OUT:
%   -   roi_xdat:       M×1 (or 1xM) column (or row) vector of the ROI x-domain (binding energy for PES)
%   -   roi_ydat:       M×1 (or 1xM) column (or row) vector of the ROI y-values (intensity for PES)
%   -   roi_bgrnd:      M×1 (or 1xM) column (or row) vector of the best fit background to the ROI data

%% Default parameters
% - Setting the default conditions 
if nargin < 3;          LHS = mean(xdat(:)) - abs(0.25*range(xdat(:))); end
if nargin < 4;          RHS = mean(xdat(:)) + abs(0.25*range(xdat(:))); end
if nargin < 5;          Win = abs(0.02*range(xdat(:))); end
if nargin < 6;          fdd_ef      = 0.0; end
if nargin < 7;          fdd_T       = 12; end
if nargin < 8;          fdd_fwhm    = 0.1; end
if isempty(LHS);        LHS = mean(xdat(:)) - abs(0.25*range(xdat(:))); end
if isempty(RHS);        RHS = mean(xdat(:)) + abs(0.25*range(xdat(:))); end
if isempty(Win);        Win = abs(0.02*range(xdat(:))); end
if isempty(fdd_ef);   	fdd_ef      = 0.0; end
if isempty(fdd_T);    	fdd_T       = 12; end
if isempty(fdd_fwhm); 	fdd_fwhm    = 0.1; end
%% Validity checks on the input parameters
% -- If a vector / array of the LHS and RHS are entered, only select the first value
if length(LHS) > 1
    disp('Warning: Start is defined as a vector, only choosing the first element.');
    LHS = LHS(1);
end
if length(RHS) > 1
    disp('Warning: End is defined as a vector, only choosing the first element.');
    RHS = RHS(1);
end
% -- If the LHS value is smaller than the RHS value, switch the assignment
if LHS > RHS
    disp('Warning: Start > End, values have been switched.');
    A = LHS; Y_Bgrnd = RHS;
    LHS = Y_Bgrnd; RHS = A; 
% -- If the LHS and RHS values are identical, no window can be defined
elseif LHS == RHS
    error('Error: Start == End, make sure you define a finite window size for the ROI.');
end
% -- If a vector / array of the window size is entered, only select the first value
if length(Win) > 1
    disp('Warning: Win is defined as a vector, only choosing the first element.');
    Win = Win(1);
end
% -- Ensuring consistency in the vector definitions
if iscolumn(xdat) && isrow(ydat); ydat = ydat';
elseif isrow(xdat) && iscolumn(ydat); xdat = xdat';
elseif isrow(xdat) && isrow(ydat); xdat = xdat'; ydat = ydat';
end
% -- Validity check on the FDD parameters
if fdd_T < 0; fdd_T = 0; end
if fdd_fwhm < 0; fdd_fwhm = 0; end
%% - 1 - Extracting the index START and END point of the background
% -- Start index points
[~, StartIndx]      = min(abs(xdat - LHS));
[~, StartIndx_lb]   = min(abs(xdat - LHS - Win));
[~, StartIndx_ub]   = min(abs(xdat - LHS + Win));
% -- End index points
[~, EndIndx]        = min(abs(xdat - RHS));
[~, EndIndx_lb]     = min(abs(xdat - RHS - Win));
[~, EndIndx_ub]     = min(abs(xdat - RHS + Win));
% - ROI indexes
roi_indx            = sort([StartIndx, EndIndx]);
StartWin_indx      	= sort([StartIndx_lb, StartIndx_ub]);
EndWin_indx     	= sort([EndIndx_lb, EndIndx_ub]);
%% - 2 - Cropping the data over the ROI
roi_xdat    = xdat(roi_indx(1):roi_indx(2));
roi_ydat    = ydat(roi_indx(1):roi_indx(2));
nRows       = length(roi_xdat);
%% - 3 - Extracting the data points of the background over the window size
if iscolumn(xdat);  xdat_bgrnd      = [xdat(StartWin_indx(1):StartWin_indx(2));   xdat(EndWin_indx(1):EndWin_indx(2))];
elseif isrow(xdat); xdat_bgrnd      = [xdat(StartWin_indx(1):StartWin_indx(2)),   xdat(EndWin_indx(1):EndWin_indx(2))];
end
if iscolumn(ydat); ydat_bgrnd       = [ydat(StartWin_indx(1):StartWin_indx(2));   ydat(EndWin_indx(1):EndWin_indx(2))];
elseif isrow(ydat); ydat_bgrnd      = [ydat(StartWin_indx(1):StartWin_indx(2)),   ydat(EndWin_indx(1):EndWin_indx(2))];
end
%% - 4 - Determination & fitting of the FDD Background
% -- Fitting the data to a polynomial of the correct order
fermi_fit = fittype(@(a, b, c, x) curve_thermal_FDDGsL(x, fdd_ef, fdd_T, fdd_fwhm, a, b, c));
a_start = 0.1;      % lin_grad:         scalar of the gradient of the linear background.
b_start = 1.0;      % lin_offset:       scalar of the y-intercept of the linear background.
c_start = 0.1;      % const_bgrnd:  	scalar of the constant background y-offset value.
% Executing the fitting operation
[fit1,~,~]          = fit(xdat_bgrnd,ydat_bgrnd,fermi_fit,'start',[a_start, b_start, c_start]);
fit1para            = coeffvalues(fit1);
roi_bgrnd           = curve_thermal_FDDGsL(roi_xdat, fdd_ef, fdd_T, fdd_fwhm, fit1para(1), fit1para(2), fit1para(3));
%% Validity check on the outputs
if isrow(xdat); if iscolumn(roi_xdat); roi_xdat = roi_xdat'; end
elseif iscolumn(xdat); if isrow(roi_xdat); roi_xdat = roi_xdat'; end
end
if isrow(xdat); if iscolumn(roi_ydat); roi_ydat = roi_ydat'; end
elseif iscolumn(xdat); if isrow(roi_ydat); roi_ydat = roi_ydat'; end
end
if isrow(xdat); if iscolumn(roi_bgrnd); roi_bgrnd = roi_bgrnd'; end
elseif iscolumn(xdat); if isrow(roi_bgrnd); roi_bgrnd = roi_bgrnd'; end
end
%% -- For Debugging
plot_result = 0;
if plot_result == 1
    % - Initialising the figure object
    fig = figure(); fig.Position(3) = 500; fig.Position(4) = 400; 
    hold on;
    % - Extracting variables
    ROI     = [xdat(roi_indx(1)), xdat(roi_indx(2))];
    LHS     = [xdat(StartWin_indx(1)), xdat(StartWin_indx(2))];
    RHS     = [xdat(EndWin_indx(1)), xdat(EndWin_indx(2))];
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
    plot(roi_xdat, roi_ydat, 'b-', 'linewidth', 2);
    plot(roi_xdat, roi_bgrnd, 'r-', 'linewidth', 2);
    plot(roi_xdat, roi_ydat-roi_bgrnd, 'k-', 'linewidth', 2);
    plot(xdat_bgrnd, ydat_bgrnd, 'r.');
    title('BgrndFDDGsL()'); 
    xlabel(' X ', 'fontweight', 'bold');
    ylabel(' Y ', 'fontweight', 'bold');
    legend({'Initial Data', 'ROI: Data', 'ROI: Background', 'ROI: Final'}, 'location', 'best', 'fontsize', 9);
    % -- Determining the best limits for the plot
    axLim_y = [roi_ydat; roi_ydat-roi_bgrnd];
    axLim_x = [mean(roi_xdat(:)) - abs(0.65*range(roi_xdat(:))); mean(roi_xdat(:)) + abs(0.65*range(roi_xdat(:)));];
    axis([axLim_x(1), axLim_x(2), min(axLim_y(:)), 1.05*max(axLim_y(:))]);
end
end