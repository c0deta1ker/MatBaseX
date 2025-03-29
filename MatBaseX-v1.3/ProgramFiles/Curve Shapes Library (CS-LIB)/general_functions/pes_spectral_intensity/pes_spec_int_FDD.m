function y = pes_spec_int_FDD(x, Type, BE, INT, FWHM, MR, LSE, LSI, LSW, ASY, FDEF, FDT, FDW)
% y = pes_spec_int_FDD(x, Type, BE, INT, FWHM, MR, LSE, LSI, LSW, ASY, FDEF, FDT, FDW)
%   Function that evaluates a generic photoelectron spectroscopy (PES)
%   curve, by defining a primary (P) and spin-orbit split (SOS) component.
%   A Fermi-Dirac Distribution (FDD) is also multiplied with the PES curve.
%   This type of curve should be used to fit near Fermi-edge EDC cuts.
%
%   IN:
%   -   x:          N×1 (or 1×N) vector of the input domain (binding energy for PES)
%   -   Type:       string of the curve-shape type. Default: ["sGLA"] ("G","L","V","DS","sGL","sGLA","pGL","pGLA")
%   -   BE:      	scalar of the binding energy of PE curve.
%   -   INT:    	scalar of the peak intensity of PE curve.
%   -   FWHM:     	scalar of the FWHM of the PE curve.
%   -   MR:     	scalar of the Mixing Ratio: 0 for pure Gaussian, 1 is for pure Lorentzian.
%   -   LSE:     	scalar of the binding energy of spin-orbit split PE curve.
%   -   LSI:     	scalar of the branching ratio of spin-orbit split PE curve.
%   -   LSW:     	scalar of the additional lorentzian width of spin-orbit split PE curve.
%   -   ASY:     	scalar of the PE curve asymmetry parameter (usually for metallic systems).
%   -   FDEF:     	scalar of the FDD Fermi-Level position.
%   -   FDT:     	scalar of the FDD temperature.
%   -   FDW:     	scalar of the FDD Gaussian width after convolution.
%
%   OUT:
%   -   y:          N×1 (or 1×N) vector of the intensity range (spectral intensity for PES)

%% Default parameters
% Default based on inputs
if nargin < 2;  Type	= "sGLA"; end
if nargin < 3;  BE   = 0.00; end
if nargin < 4;  INT  = 1.00; end
if nargin < 5;  FWHM = 0.25; end
if nargin < 6;  MR = 0.25; end
if nargin < 7;  LSE  = 0; end
if nargin < 8;  LSI  = 0; end
if nargin < 9;  LSW  = 0; end
if nargin < 10; ASY  = 0; end
if nargin < 11; FDEF  = 0; end
if nargin < 12; FDT  = 12; end
if nargin < 13; FDW  = 0.05; end
% Default based on empty inputs
if isempty(Type);   Type   = "sGLA"; end
if isempty(BE);     BE      = 0.00; end
if isempty(INT);    INT     = 1.00; end
if isempty(FWHM);   FWHM    = 0.25; end
if isempty(MR);     MR      = 0.25; end
if isempty(LSE);    LSE     = 0; end
if isempty(LSI);    LSI     = 0; end
if isempty(LSW);    LSW     = 0; end
if isempty(ASY);    ASY     = 0; end
if isempty(FDEF);   FDEF    = 0; end
if isempty(FDT);    FDT     = 12; end
if isempty(FDW);    FDW     = 0.05; end
%% Validity checks on the input parameters
% if isrow(x); x = x'; end        % -- Ensure x-data is a column vector
if INT < 0; INT = 0; end        % -- If the INT is <0, pad it to 0
if FWHM < 0; FWHM = 0; end      % -- If the FWHM is negative, pad it to zero
if MR < 0; MR = 0; end          % -- If the MR is negative, pad it to zero
if MR > 1; MR = 1; end          % -- If the MR is >1, pad it to 1
if LSI < 0; LSI = 0; end        % -- If the LSI is <0, pad it to 0
if LSW < 0; LSW = 0; end        % -- If the LSW is <0, pad it to 0
if ASY < -1; ASY = -1; end      % -- If the ASY is <-1, pad it to -1
if ASY > 1; ASY = 1; end        % -- If the ASY is >1, pad it to 1
if FDW < 0; FDW = 0; end        % -- If the FDW is <0, pad it to 0
if FDT < 0; FDT = 0; end        % -- If the FDT is <0, pad it to 0
%% - 1 - Determination of the photoemission spectrum
% - Extracting the FDD curve
FDD_curve 	= curve_thermal_FDDG(x, FDEF, FDT, FDW);
% - Extracting the PES curve
PES_int     = pes_spec_int(x, Type, BE, INT, FWHM, MR, LSE, LSI, LSW, ASY);
% - Multiplying the components together
y    	    = PES_int .* FDD_curve;
%% Validity check on the outputs
y(isnan(y)) = 0;
if isrow(x); if size(y, 2) ~= length(x); y = y'; end
elseif iscolumn(x); if size(y, 1) ~= length(x); y = y'; end
end
%% -- For Debugging
plot_result = 0;
if plot_result == 1
    % - Initialising the figure object
    figure(); hold on;
    % -- Plotting the 1D data
    plot(x, y, 'b-', 'linewidth', 2);
    plot(x, PES_int, 'k-', 'linewidth', 1);
    plot(x, FDD_curve, 'r-', 'linewidth', 2);
    title('PES_SpecIntCurve_FDD()', 'interpreter', 'none'); 
    xlabel(' X ', 'fontweight', 'bold');
    ylabel(' Y ', 'fontweight', 'bold');
    legend({'PES_SpecIntCurve_FDD()', 'PES_SpecIntCurve()', 'ThermalModel_FDDG()'}, 'location', 'best', 'Interpreter','none');
    % -- Determining the best limits for the plot
    Y = [y; PES_int; FDD_curve];
    axis([min(x(:)), max(x(:)), min(Y(:)), max(Y(:))]);
end
end