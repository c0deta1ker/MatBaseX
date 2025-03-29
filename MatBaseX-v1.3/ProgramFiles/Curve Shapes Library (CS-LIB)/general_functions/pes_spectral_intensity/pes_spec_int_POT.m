function [y, y_2D] = pes_spec_int_POT(x, Type, BE, INT, FWHM, MR, LSE, LSI, LSW, ASY, MFP, ZPOT, EPOT)
% [y, y_2D] = pes_spec_int_POT(x, Type, BE, INT, FWHM, MR, LSE, LSI, LSW, ASY, MFP, ZPOT, EPOT)
%   Function that evaluates a generic photoelectron spectroscopy (PES)
%   curve, by defining a primary (P) and spin-orbit split (SOS) component.
%   This curve shape assumes there is a potential band-bending profile that is 
%   described by E(Z), in which the PES Spectra are then layer-summed in
%   accordance to the energy shift of the potential profile. This creates
%   the so-called layer-summation PES Spectral Intensity Curves.
%
%   IN:
%   -   x:          N×1 column vector of the input domain (binding energy for PES)
%   -   Type:       string of the curve-shape type. Default: ["sGLA"] ("G","L","V","DS","sGL","sGLA","pGL","pGLA")
%   -   BE:      	scalar of the binding energy of PE curve.
%   -   INT:    	scalar of the peak intensity of PE curve.
%   -   FWHM:     	scalar of the FWHM of the PE curve.
%   -   MR:     	scalar of the Mixing Ratio: 0 for pure Gaussian, 1 is for pure Lorentzian.
%   -   LSE:     	scalar of the binding energy of spin-orbit split PE curve.
%   -   LSI:     	scalar of the branching ratio of spin-orbit split PE curve.
%   -   LSW:     	scalar of the additional lorentzian width of spin-orbit split PE curve.
%   -   ASY:     	scalar of the PE curve asymmetry parameter (usually for metallic systems).
%   -   MFP:     	scalar of the mean-free path of the emitted photoelectrons (either from optical, TPP-2M or fits).
%   -   ZPOT:     	1×M row vector of the z-domain (depth) of the potential profile.
%   -   EPOT:     	1×M row vector of the potential energy relative to the Fermi-level.
%
%   OUT:
%   -   y:          N×1 column vector of the intensity range (intensity for PES)
%   -   y_2D:    	N×M array of all the PES curve profiles at each point in the potential profile.

%% Default parameters
% Default based on inputs
if nargin < 2; Type	= "sGLA"; end
if nargin < 3; BE   = 0.00; end
if nargin < 4; INT  = 1.00; end
if nargin < 5; FWHM = 0.25; end
if nargin < 6; MR = 0.25; end
if nargin < 7; LSE  = 0; end
if nargin < 8; LSI  = 0; end
if nargin < 9; LSW  = 0; end
if nargin < 10; ASY  = 0; end
if nargin < 11; MFP  = 1; end
if nargin < 12; EPOT  = 0; end
if nargin < 13; ZPOT  = 0; end
% Default based on empty inputs
if isempty(Type);  Type   = "sGLA"; end
if isempty(BE);     BE      = 0.00; end
if isempty(INT);    INT     = 1.00; end
if isempty(FWHM);   FWHM    = 0.25; end
if isempty(MR);     MR      = 0.25; end
if isempty(LSE);    LSE     = 0; end
if isempty(LSI);    LSI     = 0; end
if isempty(LSW);    LSW     = 0; end
if isempty(ASY);    ASY     = 0; end
if isempty(MFP);    MFP     = 1; end
if isempty(EPOT);   EPOT    = 0; end
if isempty(ZPOT);   ZPOT  	= 0; end
%% Validity checks on the input parameters
if isrow(x); x = x'; end        % -- Ensure x-data is a column vector
if INT < 0; INT = 0; end        % -- If the INT is <0, pad it to 0
if FWHM < 0; FWHM = 0; end      % -- If the FWHM is negative, pad it to zero
if MR < 0; MR = 0; end          % -- If the MR is negative, pad it to zero
if MR > 1; MR = 1; end          % -- If the MR is >1, pad it to 1
if LSI < 0; LSI = 0; end        % -- If the LSI is <0, pad it to 0
if LSW < 0; LSW = 0; end        % -- If the LSW is <0, pad it to 0
if ASY < -1; ASY = -1; end      % -- If the ASY is <-1, pad it to -1
if ASY > 1; ASY = 1; end        % -- If the ASY is >1, pad it to 1
%% - 1 - Determination of the photoemission spectrum
% - Setting the potential to be zero at the BE value
EPOT    = BE + EPOT;  % EPOT    = BE + (EPOT - EPOT(1));
% - Extracting the PES curve
for i = 1:length(ZPOT)
    y_2D(:,i) = pes_spec_int(x, Type, EPOT(i), INT.*exp(-ZPOT(i)./MFP), FWHM, MR, LSE, LSI, LSW, ASY);
end
% - Normalising all the individual curves for comparison
y_2D      = INT .* (y_2D ./ max(y_2D(:)));
% - Extracting the final intensity
y        = sum(y_2D, 2);
y        = INT .* (y / max(y));
%% Validity check on the outputs
y(isnan(y)) = 0;
if isrow(x); if size(y, 2) ~= length(x); y = y'; end
elseif iscolumn(x); if size(y, 1) ~= length(x); y = y'; end
end
%% -- For Debugging
plot_result = 0;
if plot_result == 1
    fig = figure(); set(fig, 'position', [10, 10, 900, 400]);
    cols = jet(length(ZPOT)+2);
    % -- Plotting all individual curves, shifted by the potential and the final sum
    subplot(121); hold on;
    % --- Plotting individual curves
    for i = 1:length(ZPOT)
        plot(x, y_2D(:,i), 'k-', 'color', cols(i,:), 'linewidth', 0.5);
    end
    % --- Plotting the final curve
    plot(x, y, 'k-', 'linewidth', 2);
    % --- Formatting the figure
    title('PES_SpecIntCurve_POT()', 'Interpreter','none');
    xlabel(' E_B - E_F (eV) ', 'fontweight', 'bold');
    ylabel(' Intensity ', 'fontweight', 'bold');
    axis([min(x(:)), max(x(:)), min(y(:)), max(y(:))]);
    % -- Plotting the potential profile information
    subplot(122); hold on;
    % --- Image of the curve series shifted by potential and scaled by MFP
    h = pcolor(ZPOT, x, y_2D);
    set(h,'EdgeColor','None','FaceColor','Interp');
    % --- Plotting the potential energy curves
    plot(ZPOT, EPOT, 'r-', 'linewidth', 2);
    plot(ZPOT, BE*ones(size(ZPOT)), 'g-', 'linewidth', 1);
    % --- Formatting the figure
    colormap jet;
    xlabel(' z (nm) ', 'fontweight', 'bold');
    ylabel(' E_B - E_F (eV) ', 'fontweight', 'bold');
    axis([0, max(ZPOT(:)), min(x(:)), max(x(:))]);
end
end