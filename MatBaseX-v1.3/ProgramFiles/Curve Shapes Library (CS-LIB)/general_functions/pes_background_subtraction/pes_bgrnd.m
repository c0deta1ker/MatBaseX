function [roi_xdat, roi_ydat, roi_bgrnd] = pes_bgrnd(xdat, ydat, Type, LHS, RHS, Win, Bgr, varargin)
% [roi_xdat, roi_ydat, roi_bgrnd] = pes_bgrnd(xdat, ydat, Type, LHS, RHS, Win, Bgr, varargin)
%   Function that evaluates the background associated with 1D data or
%   photoelectron spectroscopy (PES) data. The background type can be defined 
%   over a given region of interest (ROI). The available background
%   subtraction methods are: Linear, Polynomial, Shirley, Shirley-Offset,
%   Shirley-Smart, 1-parameter Tougaard, 2-parameter Tougaard and FDD like.
%   The output is a vector containing the background intensity, and the new 
%   domain and intensity of the data within the defined region of interest.
%
%   IN:
%   -   xdat:       N×1 (or 1xN) column (or row) vector of the input domain (binding energy for PES).
%   -   ydat:       N×1 (or 1xN) column (or row) vector of the intensity range (spectral intensity for PES).
%   -   Type:       string of the type of background subtraction to use from the following list:
%                       - None:             ""
%                       - Linear:           "L"
%                       - Polynomial:       "P"
%                       - Shirley:          "S"
%                       - Shirley-Offset:   "SO"
%                       - Shirley-Smart:    "SS"
%                       - 1Tougaard:        "1T"
%                       - 2Tougaard:        "2T"
%   -   LHS:        scalar of the LHS x-axis position of the ROI {Default: 25th percentile.}
%   -   RHS:        scalar of the RHS x-axis position of the ROI {Default: 75th percentile.}
%   -   Win:        scalar of the window size around the LHS and RHS positions {Default: 2% of ROI size.}
%   -   Bgr:        scalar for a constant y-axis background to be included {Default: 0}
%   -   varargin:   arguments to be inserted depending on the type of background used;
%                       - None:             []
%                       - Linear:           []
%                       - Polynomial:       [Order]
%                       - Shirley:          []
%                       - Shirley-Offset:   []
%                       - Shirley-Smart:    []
%                       - 1Tougaard:        [C]
%                       - 2Tougaard:        [C, D]
%                       - FDDGpL:           [fdd_ef, fdd_T, fdd_fwhm]
%                       - FDDGsL:           [fdd_ef, fdd_T, fdd_fwhm]
%
%   OUT:
%   -   roi_xdat:   M×1 column vector of the ROI x-domain (binding energy for PES).
%   -   roi_ydat:   M×1 column vector of the ROI y-values (intensity for PES).
%   -   roi_bgrnd:  M×1 column vector of the best fit polynomial background to the ROI data.

%% Default parameters
% - Setting the default conditions
if nargin < 3;      Type 	= "L"; end
if nargin < 4;    	LHS     = mean(xdat(:)) - abs(0.25*range(xdat(:))); end
if nargin < 5;   	RHS     = mean(xdat(:)) + abs(0.25*range(xdat(:))); end
if nargin < 6;   	Win     = abs(0.02*range(xdat(:))); end
if nargin < 7;   	Bgr     = 0; end
if isempty(Type);   Type 	= ""; end
if isempty(LHS);   	LHS    	= mean(xdat(:)) - abs(0.25*range(xdat(:))); end
if isempty(RHS);    RHS    	= mean(xdat(:)) + abs(0.25*range(xdat(:))); end
if isempty(Win);	Win     = abs(0.02*range(xdat(:))); end
if isempty(Win);	Bgr     = 0; end
%% - 1 - Determination of the PES Background Subtraction Curve
Type = char(lower(Type));
switch Type
    % - Linear Background Substration
    case lower({'Linear','L'});             [roi_xdat, roi_ydat, roi_bgrnd] = pes_bgrnd_linear(xdat, ydat, LHS, RHS, Win, varargin{:}); label="Linear";
    % - Polynomial Background Subtraction
    case lower({'Polynomial','Poly','P'});  [roi_xdat, roi_ydat, roi_bgrnd] = pes_bgrnd_poly(xdat, ydat, LHS, RHS, Win, varargin{:}); label="Polynomial";
    % - Shirley Background Subtraction
    case lower({'Shirley','S'});            [roi_xdat, roi_ydat, roi_bgrnd] = pes_bgrnd_shirley(xdat, ydat, LHS, RHS, Win, varargin{:}); label="Shirley";
    case lower({'ShirleyOffset','SO'});     [roi_xdat, roi_ydat, roi_bgrnd] = pes_bgrnd_shirley_offset(xdat, ydat, LHS, RHS, Win, varargin{:}); label="ShirleyOffset";
    case lower({'ShirleySmart','SS'});      [roi_xdat, roi_ydat, roi_bgrnd] = pes_bgrnd_shirley_smart(xdat, ydat, LHS, RHS, Win, varargin{:}); label="ShirleySmart";
    % - Tougaard Background Subtraction
    case lower({'Tougaard1','T1','1T'});    [roi_xdat, roi_ydat, roi_bgrnd] = pes_bgrnd_1tougaard(xdat, ydat, LHS, RHS, Win, varargin{:}); label="Tougaard1";
    case lower({'Tougaard2','T2','2T'});    [roi_xdat, roi_ydat, roi_bgrnd] = pes_bgrnd_2tougaard(xdat, ydat, LHS, RHS, Win, varargin{:}); label="Tougaard2";
    % - Fermi-Dirac Distribution (FDD) Background Subtraction
    case lower({'StepFDDGpL','FDDGpL'});    [roi_xdat, roi_ydat, roi_bgrnd] = pes_bgrnd_step_FDDGpL(xdat, ydat, LHS, RHS, Win, varargin{:}); label="StepFDDGpL";
    case lower({'StepFDDGsL','FDDGsL'});    [roi_xdat, roi_ydat, roi_bgrnd] = pes_bgrnd_step_FDDGsL(xdat, ydat, LHS, RHS, Win, varargin{:}); label="StepFDDGsL";
    % - No Background Subtraction
    case lower({'','None','Raw','R'})
        label="Raw";
        [~, lhsIndx]	= min(abs(xdat - LHS));
        [~, rhsIndx]	= min(abs(xdat - RHS));
        roi_xdat        = xdat(lhsIndx:rhsIndx);
        roi_ydat        = ydat(lhsIndx:rhsIndx);
        roi_bgrnd       = 0.*roi_ydat;
    otherwise; roi_xdat = []; roi_ydat = []; roi_bgrnd = []; label="";
end
% - Adding a constant background 
roi_bgrnd = roi_bgrnd - Bgr;
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
    % - Extracting Start & End Point Indices
    % -- Start index points
    [~, StartIndx_lb]   = min(abs(xdat - LHS - Win));
    [~, StartIndx_ub]   = min(abs(xdat - LHS + Win));
    % -- End index points
    [~, EndIndx_lb]     = min(abs(xdat - RHS - Win));
    [~, EndIndx_ub]     = min(abs(xdat - RHS + Win));
    % - ROI indexes
    StartWin_indx      	= sort([StartIndx_lb, StartIndx_ub]);
    EndWin_indx     	= sort([EndIndx_lb, EndIndx_ub]);
    % - Extracting the data points of the background over the window size
    if iscolumn(xdat);  xdat_bgrnd      = [xdat(StartWin_indx(1):StartWin_indx(2));   xdat(EndWin_indx(1):EndWin_indx(2))];
    elseif isrow(xdat); xdat_bgrnd      = [xdat(StartWin_indx(1):StartWin_indx(2)),   xdat(EndWin_indx(1):EndWin_indx(2))];
    end
    if iscolumn(ydat); ydat_bgrnd       = [ydat(StartWin_indx(1):StartWin_indx(2));   ydat(EndWin_indx(1):EndWin_indx(2))];
    elseif isrow(ydat); ydat_bgrnd      = [ydat(StartWin_indx(1):StartWin_indx(2)),   ydat(EndWin_indx(1):EndWin_indx(2))];
    end
    % - Initialising the figure object
    fig = figure(); fig.Position(3) = 500; fig.Position(4) = 400; 
    hold on;
    % - Extracting variables
    ROI     = [LHS, RHS];
    LHS     = LHS + [-Win, Win];
    RHS     = RHS + [-Win, Win];
    % -- Plotting the ROI, LHS and RHS analysis windows
    hMID    = patch([ROI(1), ROI(1), ROI(2), ROI(2), ROI(1)], [0, 1, 1, 0, 0].*2*max(ydat(:)), [0.8 0.8 0.8], 'facealpha', 0.5, 'edgecolor', 'none');
    hLHS    = patch([LHS(1), LHS(1), LHS(2), LHS(2), LHS(1)], [0, 1, 1, 0, 0].*2*max(ydat(:)), [0.2 0.7 0.2], 'facealpha', 0.2, 'edgecolor', 'none');
    hRHS    = patch([RHS(1), RHS(1), RHS(2), RHS(2), RHS(1)], [0, 1, 1, 0, 0].*2*max(ydat(:)), [0.7 0.2 0.2], 'facealpha', 0.2, 'edgecolor', 'none');
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
    title(sprintf("PES_BgrndSubCurve(%s)",label), 'interpreter','none'); 
    xlabel(' X ', 'fontweight', 'bold');
    ylabel(' Y ', 'fontweight', 'bold');
    legend({'Initial Data', 'ROI: Data', 'ROI: Background', 'ROI: Final'}, 'location', 'best', 'fontsize', 9);
    % -- Determining the best limits for the plot
    axLim_y = [roi_ydat; roi_ydat-roi_bgrnd; roi_bgrnd];
    axLim_x = [mean(roi_xdat(:)) - abs(0.65*range(roi_xdat(:))); mean(roi_xdat(:)) + abs(0.65*range(roi_xdat(:)));];
    axis([axLim_x(1), axLim_x(2), min(axLim_y(:)), 1.05*max(axLim_y(:))]);
end
end