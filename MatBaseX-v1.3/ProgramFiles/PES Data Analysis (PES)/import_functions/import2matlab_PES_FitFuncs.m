close all; clear all;
path_matbase    = what('Curve Shapes Library (CS-LIB)'); path_matbase = string(path_matbase.path);
path_save       = path_matbase + "\0_figs\";

%% 4    :   Fitting an FDD Spectrum
help fdd2fit_solver
% 1 - Arbitrary 1D Fermi Edge
xdat    = linspace(-3, 3, 1e3);
ydat    = ThermalModel_FDDGsL(xdat, -0.25, 12, 0.3, -0.2, 0, 0.05) + 0.15*rand(size(xdat));
[fitStr, Ef] = fdd2fit_solver([], xdat, ydat, [], [], "FDDGsL");

%% APPENDIX
close all;
%% Appendix I - Extracting peak parameters
% 1 - Defining a curve to be used
xdat = linspace(-3, 3, 1e3);
TYPE    = "sGLA";   % type of curve to use for fitting. Default: "sGLA" ("pGLA", "sGL", "pGL", "G", "L", "DS")
BE      = 0.0;      % scalar of the binding energy of PE curve.
INT     = 1.0;      % scalar of the peak intensity of PE curve.
FWHM    =  0.1;     % scalar of the FWHM of the PE curve.
MR      =  0.5;     % scalar of the Mixing Ratio: 0 for pure Gaussian, 1 is for pure Lorentzian.
LSE     = -1.0;     % scalar of the binding energy of spin-orbit split PE curve.
LSI     =  0.5;     % calar of the branching ratio of spin-orbit split PE curve.
LSW     =  0.0;     % scalar of the additional lorentzian width of spin-orbit split PE curve.
ASY     =  0.0;     % scalar of the PE curve asymmetry parameter (usually for metallic systems).
% 2 - Calculating the lineshape
ydat    = pes_spec_int(xdat, TYPE, BE, INT, FWHM, MR, LSE, LSI, LSW, ASY);
% 3 - Plotting the lineshapes & verifying the FWHM values
figure(); plot(xdat, ydat, 'b-', 'linewidth', 2);
title('PESCurve()'); 
xlabel('$$ \bf  E_B - E_F (eV) $$', 'Interpreter', 'latex');
ylabel('$$ \bf  Intensity $$', 'Interpreter', 'latex');
%% Appendix II - Extracting peak positions & heights
close all;
help find_peak_loc; 
Win = 0.02 .* [-1, 1];
[xval_R, yval_R]            = find_peak_loc(xdat, ydat, Win, "R", 1);
[xval_S, yval_S]            = find_peak_loc(xdat, ydat, Win, "S", 1);
[xval_G1, yval_G1]          = find_peak_loc(xdat, ydat, Win, "G1", 1);
[xval_D1, yval_D1]          = find_peak_loc(xdat, ydat, Win, "D1", 1);
[xval_D2, yval_D2]          = find_peak_loc(xdat, ydat, Win, "D2", 1);
[xval_G, yval_G]            = find_peak_loc(xdat, ydat, Win, "G", 1);
[xval_L, yval_L]            = find_peak_loc(xdat, ydat, Win, "L", 1);
[xval_sGL, yval_sGL]        = find_peak_loc(xdat, ydat, Win, "sGL", 1);
[xval_pGL, yval_pGL]        = find_peak_loc(xdat, ydat, Win, "pGL", 1);
[xval_sGLA, yval_sGLA]      = find_peak_loc(xdat, ydat, Win, "sGLA", 1);
[xval_pGLA, yval_pGLA]      = find_peak_loc(xdat, ydat, Win, "pGLA", 1);
% -- Plotting a comparison of all peak finder methods
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
xline(0, 'HandleVisibility','off'); yline(1, 'HandleVisibility','off'); 
h = plot(0, 1, 'kx', 'markersize', 10, 'HandleVisibility','off');
cols = lines(20);
plot(xval_R, yval_R, 'kx', 'color', cols(1,:));
plot(xval_S, yval_S, 'rx', 'color', cols(2,:));
plot(xval_G1, yval_G1, 'rx', 'color', cols(3,:));
plot(xval_D1, yval_D1, 'rx', 'color', cols(4,:));
plot(xval_D2, yval_D2, 'rx', 'color', cols(5,:));
plot(xval_G, yval_G, 'kx', 'color', cols(6,:));
plot(xval_L, yval_L, 'rx', 'color', cols(7,:));
plot(xval_sGL, yval_sGL, 'rx', 'color', cols(8,:));
plot(xval_pGL, yval_pGL, 'rx', 'color', cols(9,:));
plot(xval_sGLA, yval_sGLA, 'rx', 'color', cols(10,:));
plot(xval_pGLA, yval_pGLA, 'rx', 'color', cols(11,:));
lgnd = {"Raw", "Spline", "Gaco1", "dydx", "d2ydx2", "G", "L", "sGL", "pGL", "sGLA", "pGLA"};
legend(lgnd, 'location', 'best','fontsize', 7);
axis([-0.015, 0.015, 0.985, 1.015]);
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
title(sprintf("find_peak_loc()"), 'interpreter', 'none'); 
%% Appendix III - Extracting peak FWHM
close all;
help find_peak_fwhm; 
Win = 0.08 .* [-1, 1];
[fwhm_R, fwhmLocs_R]            = find_peak_fwhm(xdat, ydat, Win, "R", 1);
[fwhm_S, fwhmLocs_S]            = find_peak_fwhm(xdat, ydat, Win, "S", 1);
[fwhm_G1, fwhmLocs_G1]          = find_peak_fwhm(xdat, ydat, Win, "G1", 1);
[fwhm_G, fwhmLocs_G]            = find_peak_fwhm(xdat, ydat, Win, "G", 1);
[fwhm_L, fwhmLocs_L]            = find_peak_fwhm(xdat, ydat, Win, "L", 1);
[fwhm_sGL, fwhmLocs_sGL]        = find_peak_fwhm(xdat, ydat, Win, "sGL", 1);
[fwhm_pGL, fwhmLocs_pGL]        = find_peak_fwhm(xdat, ydat, Win, "pGL", 1);
[fwhm_sGLA, fwhmLocs_sGLA]      = find_peak_fwhm(xdat, ydat, Win, "sGLA", 1);
[fwhm_pGLA, fwhmLocs_pGLA]      = find_peak_fwhm(xdat, ydat, Win, "pGLA", 1);
% -- Plotting a comparison of all peak finder methods
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
xline(0.1, 'HandleVisibility','off'); yline(0.1, 'HandleVisibility','off'); 
h = plot(FWHM, FWHM, 'kx', 'markersize', 10, 'HandleVisibility','off');
cols = lines(20);
plot(fwhm_R, fwhm_R, 'kx', 'color', cols(1,:));
plot(fwhm_S, fwhm_S, 'rx', 'color', cols(2,:));
plot(fwhm_G1, fwhm_G1, 'rx', 'color', cols(3,:));
plot(fwhm_G, fwhm_G, 'kx', 'color', cols(4,:));
plot(fwhm_L, fwhm_L, 'rx', 'color', cols(5,:));
plot(fwhm_sGL, fwhm_sGL, 'rx', 'color', cols(6,:));
plot(fwhm_pGL, fwhm_pGL, 'rx', 'color', cols(7,:));
plot(fwhm_sGLA, fwhm_sGLA, 'rx', 'color', cols(8,:));
plot(fwhm_pGLA, fwhm_pGLA, 'rx', 'color', cols(9,:));
lgnd = {"Raw", "Spline", "Gaco1",  "G", "L", "sGL", "pGL", "sGLA", "pGLA"};
legend(lgnd, 'location', 'best','fontsize', 7);
axis([0.08, 0.12, 0.08, 0.12]);
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
title(sprintf("find_peak_fwhm()"), 'interpreter', 'none'); 
