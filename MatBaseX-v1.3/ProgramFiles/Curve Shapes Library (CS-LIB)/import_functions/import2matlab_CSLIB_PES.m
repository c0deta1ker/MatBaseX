close all; clear all;
path_matbase    = what('Curve Shapes Library (CS-LIB)'); path_matbase = string(path_matbase.path);
path_save       = path_matbase + "\0_figs\";

%% 1    :   Atomic Concentration Curves
close all;
% Defining constants
xdat = linspace(-6, 6, 1e3);
center      = 0;
amplitude   = 3.5;
width       = 6;
fwhm        = 2;
cdl         = 1;
cutoff      = 1;
%% 1.1    :   Step
ydat = pes_atom_conc_curve(xdat, "StLHS", center, amplitude);
ydat = pes_atom_conc_curve(xdat, "StRHS", center, amplitude);
%% 1.2    :   Step Erf Broadened
ydat = pes_atom_conc_curve(xdat, "StErfLHS", center, amplitude, fwhm);
ydat = pes_atom_conc_curve(xdat, "StErfRHS", center, amplitude, fwhm);
%% 1.3    :   Step Gaussian Broadened
ydat = pes_atom_conc_curve(xdat, "StGaLHS", center, amplitude, fwhm);
ydat = pes_atom_conc_curve(xdat, "StGaRHS", center, amplitude, fwhm);
%% 1.4    :   Step Gaussian Broadened & Truncated
ydat = pes_atom_conc_curve(xdat, "StGaTrLHS", center, amplitude, fwhm, cutoff);
ydat = pes_atom_conc_curve(xdat, "StGaTrRHS", center, amplitude, fwhm, cutoff);
%% 1.5    :   Step Exponential Broadened
ydat = pes_atom_conc_curve(xdat, "StExLHS", center, amplitude, cdl);
ydat = pes_atom_conc_curve(xdat, "StExRHS", center, amplitude, cdl);
%% 1.6    :   Step Exponential Broadened & Truncated
ydat = pes_atom_conc_curve(xdat, "StExTrLHS", center, amplitude, cdl, cutoff);
ydat = pes_atom_conc_curve(xdat, "StExTrRHS", center, amplitude, cdl, cutoff);
%% 1.7    :   TopHat
ydat = pes_atom_conc_curve(xdat, "ToHa", center, amplitude, width);
%% 1.8    :   TopHat Erf Broadened
ydat = pes_atom_conc_curve(xdat, "ToHaErf", center, amplitude, width, fwhm);
ydat = pes_atom_conc_curve(xdat, "ToHaErfLHS", center, amplitude, width, fwhm);
ydat = pes_atom_conc_curve(xdat, "ToHaErfRHS", center, amplitude, width, fwhm);
%% 1.9    :   TopHat Gaussian Broadened
ydat = pes_atom_conc_curve(xdat, "ToHaGa", center, amplitude, width, fwhm);
ydat = pes_atom_conc_curve(xdat, "ToHaGaLHS", center, amplitude, width, fwhm);
ydat = pes_atom_conc_curve(xdat, "ToHaGaRHS", center, amplitude, width, fwhm);
%% 1.10    :   TopHat Gaussian Broadened & Truncated
ydat = pes_atom_conc_curve(xdat, "ToHaGaTrLHS", center, amplitude, width, fwhm, cutoff);
ydat = pes_atom_conc_curve(xdat, "ToHaGaTrRHS", center, amplitude, width, fwhm, cutoff);
%% 1.11    :   TopHat Exponential Broadened
ydat = pes_atom_conc_curve(xdat, "ToHaEx", center, amplitude, width, cdl);
ydat = pes_atom_conc_curve(xdat, "ToHaExLHS", center, amplitude, width, cdl);
ydat = pes_atom_conc_curve(xdat, "ToHaExRHS", center, amplitude, width, cdl);
%% 1.12    :   TopHat Exponential Broadened & Truncated
ydat = pes_atom_conc_curve(xdat, "ToHaExTrLHS", center, amplitude, width, cdl, cutoff);
ydat = pes_atom_conc_curve(xdat, "ToHaExTrRHS", center, amplitude, width, cdl, cutoff);

%% 2    :   General XPS Lineshapes
close all;
%% 2.1    :   Generic, vanilla PES curve
% 1 - Defining the input parameters
xdat = linspace(-3, 3, 1e4);
TYPE    = "sGLA";   % type of curve to use for fitting. Default: "sGLA" ("G","L","V","DS","sGL","sGLA","pGL","pGLA")
BE      =  0.0;      % scalar of the binding energy of PE curve.
INT     =  1.0;      % scalar of the peak intensity of PE curve.
FWHM    =  0.1;     % scalar of the FWHM of the PE curve.
MR      =  0.5;     % scalar of the Mixing Ratio: 0 for pure Gaussian, 1 is for pure Lorentzian.
LSE     = -1.0;     % scalar of the binding energy of spin-orbit split PE curve.
LSI     =  0.5;     % calar of the branching ratio of spin-orbit split PE curve.
LSW     =  0.0;     % scalar of the additional lorentzian width of spin-orbit split PE curve.
ASY     =  0.;     % scalar of the PE curve asymmetry parameter (usually for metallic systems).
% 2 - Calculating the lineshape
ydat    = pes_spec_int(xdat, TYPE, BE, INT, FWHM, MR, LSE, LSI, LSW, ASY);
%% 2.2    :   PES curve convolved with a Fermi-Dirac Distribution (FDD) for near Fermi-edge fitting problems
% 1 - Defining the input parameters
xdat = linspace(-2, 2, 1e4);
TYPE    = "sGLA";   % type of curve to use for fitting. Default: "sGLA" ("G","L","V","DS","sGL","sGLA","pGL","pGLA")
BE      =  0.0;     % scalar of the binding energy of PE curve.
INT     =  1.0;     % scalar of the peak intensity of PE curve.
FWHM    =  0.1;     % scalar of the FWHM of the PE curve.
MR      =  0.5;     % scalar of the Mixing Ratio: 0 for pure Gaussian, 1 is for pure Lorentzian.
LSE     = -1.0;     % scalar of the binding energy of spin-orbit split PE curve.
LSI     =  0.5;     % calar of the branching ratio of spin-orbit split PE curve.
LSW     =  0.0;     % scalar of the additional lorentzian width of spin-orbit split PE curve.
ASY     =  0.0;     % scalar of the PE curve asymmetry parameter (usually for metallic systems).
FDEF    =  0.0;     % scalar of the FDD Fermi-Level position.
FDT     =  12.0;    % scalar of the FDD temperature.
FDW     =  0.10;    % scalar of the FDD Gaussian width after convolution.
% 2 - Calculating the lineshape
ydat     = pes_spec_int_FDD(xdat, TYPE, BE, INT, FWHM, MR, LSE, LSI, LSW, ASY, FDEF, FDT, FDW);
%% 2.3    :   PES curve integrated over a pre-defined/theoretical potential profile
% 1 - Defining the input parameters
xdat    = linspace(-3.0, 3.0, 5e3);
TYPE    = "G";   % type of curve to use for fitting. Default: "sGLA" ("pGLA", "sGL", "pGL", "G", "L", "DS")
BE      =  -1.0;    % scalar of the binding energy of PE curve.
INT     =  1.05;    % scalar of the peak intensity of PE curve.
FWHM    =  0.1;     % scalar of the FWHM of the PE curve.
MR      =  0.5;     % scalar of the Mixing Ratio: 0 for pure Gaussian, 1 is for pure Lorentzian.
LSE     = -1.0;     % scalar of the binding energy of spin-orbit split PE curve.
LSI     =  0.5;     % scalar of the branching ratio of spin-orbit split PE curve.
LSW     =  0.0;     % scalar of the additional lorentzian width of spin-orbit split PE curve.
ASY     =  0.0;     % scalar of the PE curve asymmetry parameter (usually for metallic systems).
MFP     =  5.0;     % scalar of the mean-free path of the emitted photoelectrons (either from optical, TPP-2M or fits) [nm]
ZPOT    = linspace(0, 25, 100);                           % 1xN array of the z-domain (depth) of the potential profile [eV]
EPOT    = 1./(1 + exp(-ZPOT*0.05)) - 0.01;      % 1xN array of the potential energy relative to the Fermi-level [eV]
% 2 - Calculating the lineshape
[ydat, PES_int]     = pes_spec_int_POT(xdat, TYPE, BE, INT, FWHM, MR, LSE, LSI, LSW, ASY, MFP, ZPOT, EPOT);

%% 3    :   Background Subtraction Methods
close all;
LHS         = -7;
RHS         = 2;
Win         = 0.5;
Bgr         = 0;
%% 3.1    :   Artificial XPS spectrum
xdat        = linspace(-10, 10, 1e3);
ydat        = pes_spec_int(xdat, "sGLA", -2, 1, 0.1, 0.5, -1, 0.5, 0, 0.1);
ydat        = ydat - 0.01.*xdat + 0.1;
ydat        = ydat .* (1 + 0.5*rand(1, length(ydat)));
figure(); hold on; plot(xdat, ydat);
%% 3.2    :   Polynomial Background
[roi_xdat, roi_ydat, roi_bgrnd] = pes_bgrnd(xdat, ydat, "L", LHS, RHS, Win, Bgr);
[roi_xdat, roi_ydat, roi_bgrnd] = pes_bgrnd(xdat, ydat, "P", LHS, RHS, Win, Bgr, 4);
%% 3.3    :   Shirley Background
[roi_xdat, roi_ydat, roi_bgrnd] = pes_bgrnd(xdat, ydat, "S", LHS, RHS, Win, Bgr);
[roi_xdat, roi_ydat, roi_bgrnd] = pes_bgrnd(xdat, ydat, "SO", LHS, RHS, Win, Bgr);
[roi_xdat, roi_ydat, roi_bgrnd] = pes_bgrnd(xdat, ydat, "SS", LHS, RHS, Win, Bgr);
%% 3.4    :   Tougaard Background
[roi_xdat, roi_ydat, roi_bgrnd] = pes_bgrnd(xdat, ydat, "T1", LHS, RHS, Win, Bgr);
[roi_xdat, roi_ydat, roi_bgrnd] = pes_bgrnd(xdat, ydat, "T2", LHS, RHS, Win, Bgr);
%% 3.5    :   Step Fermi-Edge Background
[roi_xdat, roi_ydat, roi_bgrnd] = pes_bgrnd(xdat, ydat, "FDDGpL", LHS, RHS, Win);
[roi_xdat, roi_ydat, roi_bgrnd] = pes_bgrnd(xdat, ydat, "FDDGsL", LHS, RHS, Win);
%% 3.6    :   No Background
[roi_xdat, roi_ydat, roi_bgrnd] = pes_bgrnd(xdat, ydat, "R", LHS, RHS, Win);