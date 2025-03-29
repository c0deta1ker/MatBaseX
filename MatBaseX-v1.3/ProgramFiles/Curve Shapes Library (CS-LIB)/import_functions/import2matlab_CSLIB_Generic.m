close all; clear all;
path_matbase    = what('Curve Shapes Library (CS-LIB)'); path_matbase = string(path_matbase.path);
path_save       = path_matbase + "\0_figs\";
%% Initializing variables
xdat = linspace(-6, 6, 1e3);
%% 1    :   Exponential And Power Law Models
close all;
%% 1.1    :   curve_exponential
help curve_exponential;
% 1 - Defining the input parameters
amplitude   = 1;
decay       = logspace(0,0.3,5); 
% 2 - Calculating model
lgnd = {}; ydat = {};
for i = 1:length(decay)
    ydat{i}    = curve_exponential(xdat, amplitude, decay(i));
    lgnd{i}       = "decay = " + string(decay(i));
end
% 3 - Plotting model
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
cols = parula(length(decay) + 1);
for i = 1:length(decay)
    plot(xdat, ydat{i}, 'k-', 'color', cols(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_exponential()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
print(path_save  + "curve_exponential()",'-dpng', '-r500');
%% 1.2    :   curve_powerlaw
help curve_powerlaw;
% 1 - Defining the input parameters
amplitude   = 1;
exponent    = 1:1:5;
% 2 - Calculating model
lgnd = {}; ydat = {};
for i = 1:length(exponent)
    ydat{i}    = curve_powerlaw(xdat, amplitude, exponent(i));
    lgnd{i}       = "exponent = " + string(exponent(i));
end
% 3 - Plotting model
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
cols = parula(length(exponent) + 1);
for i = 1:length(exponent)
    plot(xdat, ydat{i}, 'k-', 'color', cols(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_powerlaw()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
print(path_save  + "curve_powerlaw()",'-dpng', '-r500');

%% 2    :   Linear And Polynomial Models
close all;
%% 2.1    :   curve_constant
help curve_constant;
% 1 - Defining the input parameters
constant       = 1:1:5;
% 2 - Calculating model
lgnd = {}; ydat = {};
for i = 1:length(constant)
    ydat{i}    = curve_constant(xdat, constant(i));
    lgnd{i}       = "constant = " + string(constant(i));
end
% 3 - Plotting model
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
cols = parula(length(constant) + 1);
for i = 1:length(constant)
    plot(xdat, ydat{i}, 'k-', 'color', cols(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_constant()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
print(path_save  + "curve_constant()",'-dpng', '-r500');
%% 2.2    :   curve_linear
help curve_linear;
% 1 - Defining the input parameters
slope       = 1:1:5;
intercept   = 2;
% 2 - Calculating model
lgnd = {}; ydat = {};
for i = 1:length(slope)
    ydat{i}    = curve_linear(xdat, slope(i), intercept);
    lgnd{i}       = "slope = " + string(slope(i));
end
% 3 - Plotting model
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
cols = parula(length(slope) + 1);
for i = 1:length(slope)
    plot(xdat, ydat{i}, 'k-', 'color', cols(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_linear()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
print(path_save  + "curve_linear()",'-dpng', '-r500');
%% 2.3    :   curve_quadratic
help curve_quadratic;
% 1 - Defining the input parameters
a   = 1:1:5;
b   = 0;
c   = 0;
% 2 - Calculating model
lgnd = {}; ydat = {};
for i = 1:length(a)
    ydat{i}    = curve_quadratic(xdat, a(i), b, c);
    lgnd{i}       = "b = " + string(a(i));
end
% 3 - Plotting model
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
cols = parula(length(a) + 1);
for i = 1:length(a)
    plot(xdat, ydat{i}, 'k-', 'color', cols(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_quadratic()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
print(path_save  + "curve_quadratic()",'-dpng', '-r500');

%% 3    :   Peak-Like Models
close all;
%% 3.1    :   curve_asym_exp_blend
help curve_asym_exp_blend;
% 1 - Defining the input parameters
center              = 0.;
asymmetry       = [-0.5,-0.25,0,0.25,0.5];
% 2 - Calculating the lineshape
lgnd = {}; int_AEB = {};
for i = 1:length(asymmetry)
    int_AEB{i}    = curve_asym_exp_blend(xdat, center, asymmetry(i));
    lgnd{i}        = "asymmetry = " + string(asymmetry(i));
end
% 3 - Plotting the lineshapes & verifying the FWHM values
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
cols = parula(length(asymmetry) + 1);
for i = 1:length(asymmetry)
    plot(xdat, int_AEB{i}, 'k-', 'color', cols(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_asym_exp_blend()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
int_AEB = int_AEB{1};
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(int_AEB(:))]);
print(path_save  + "curve_asym_exp_blend()",'-dpng', '-r500');
%% 3.2    :   curve_doniachsunjic
help curve_doniachsunjic;
% 1 - Defining the input parameters
center          = 0;            % scalar of the peak position along the x-axis of the Lorentzian.
amplitude       = 1.0;          % scalar of the peak beneath the Lorentzian.
width           = 0.25;         % scalar of the width parameter
asymmetry       = 0.0:0.1:0.5;    % scalar of the asymmetry ratio; 0 for none, 1 is for maximum.
% 2 - Calculating the lineshape
lgnd = {};
for i = 1:length(asymmetry)
    int_DS{i}    = curve_doniachsunjic(xdat, center, amplitude, width, asymmetry(i));
    lgnd{i}         = "asymmetry = " + string(asymmetry(i));
end
% 3 - Plotting the lineshapes & verifying the FWHM values
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
cols = parula(length(asymmetry) + 1);
for i = 1:length(asymmetry)
    plot(xdat, int_DS{i}, 'k-', 'color', cols(i,:), 'linewidth', 2);
    % -- Verifying the peak peak
    cpeak   = max(int_DS{i}(:));
    % -- Verifying the FWHM
    halfMax = 0.5*max(int_DS{i}(:));                      % Find the half max value
    index1  = find(int_DS{i}(:) >= halfMax, 1, 'first');  % Find where the data first drops below half the max
    index2  = find(int_DS{i}(:) >= halfMax, 1, 'last');   % Find where the data last rises above half the max
    cfwhm   = xdat(index2) - xdat(index1);                   % Calculated FWHM
    sprintf("FWHM = %.2f, peak = %.2f", cfwhm, cpeak)
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_doniachsunjic()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
ydat = int_DS{i}; axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "curve_doniachsunjic()",'-dpng', '-r500');
%% 3.3    :   curve_gaussian
help curve_gaussian;
% 1 - Defining the input parameters
center          = 0;            % scalar of the peak position along the x-axis of the Gaussian.
amplitude       = 1.00;         % scalar of the peak beneath the Gaussian.
width           = 1:0.5:4;    % scalar of the full-width at half-maximum (FWHM) of the Gaussian.
% 2 - Calculating the lineshape
lgnd = {};
for i = 1:length(width)
    int_gauss{i}    = curve_gaussian(xdat, center, amplitude, width(i));
    lgnd{i}         = "FWHM = " + string(width(i));
end
% 3 - Plotting the lineshapes & verifying the FWHM values
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
cols = parula(length(width) + 1);
for i = 1:length(width)
    plot(xdat, int_gauss{i}, 'k-', 'color', cols(i,:), 'linewidth', 2);
    % -- Verifying the peak peak
    cpeak   = max(int_gauss{i}(:));
    % -- Verifying the FWHM
    halfMax = 0.5*max(int_gauss{i}(:));                      % Find the half max value
    index1  = find(int_gauss{i}(:) >= halfMax, 1, 'first');  % Find where the data first drops below half the max
    index2  = find(int_gauss{i}(:) >= halfMax, 1, 'last');   % Find where the data last rises above half the max
    cfwhm   = xdat(index2) - xdat(index1);                  % Calculated FWHM
    sprintf("FWHM = %.2f, peak = %.2f", cfwhm, cpeak)
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_gaussian()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
ydat = int_gauss{i}; axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "curve_gaussian()",'-dpng', '-r500');
%% 3.4    :   curve_lorentzian
help curve_lorentzian;
% 1 - Defining the input parameters
center          = 0;            % scalar of the peak position along the x-axis of the Lorentzian.
amplitude       = 1.00;            % scalar of the peak beneath the Lorentzian.
width           = 1:0.5:4;    % scalar of the full-width at half-maximum (FWHM) of the Lorentzian.
% 2 - Calculating the lineshape
lgnd = {};
for i = 1:length(width)
    int_lorentz{i}    = curve_lorentzian(xdat, center, amplitude, width(i));
    lgnd{i}           = "FWHM = " + string(width(i));
end
% 3 - Plotting the lineshapes & verifying the FWHM values
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
cols = parula(length(width) + 1);
for i = 1:length(width)
    plot(xdat, int_lorentz{i}, 'k-', 'color', cols(i,:), 'linewidth', 2);
    % -- Verifying the peak peak
    cpeak   = max(int_lorentz{i}(:));
    % -- Verifying the FWHM
    halfMax = 0.5*max(int_lorentz{i}(:));                      % Find the half max value
    index1  = find(int_lorentz{i}(:) >= halfMax, 1, 'first');  % Find where the data first drops below half the max
    index2  = find(int_lorentz{i}(:) >= halfMax, 1, 'last');   % Find where the data last rises above half the max
    cfwhm   = xdat(index2) - xdat(index1);                     % Calculated FWHM
    sprintf("FWHM = %.2f, peak = %.2f", cfwhm, cpeak)
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_lorentzian()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
ydat = int_lorentz{i}; axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "curve_lorentzian()",'-dpng', '-r500');
%% 3.5    :   curve_lorentzian_split
help curve_lorentzian_split;
% 1 - Defining the input parameters
center      = 0;            % scalar of the peak position along the x-axis of the Lorentzian.
amplitude   = 1.00;            % scalar of the peak beneath the Lorentzian.
width_lhs   = 0.4:0.2:2;    % scalar of the full-width at half-maximum (FWHM) of the Lorentzian.
width_rhs   = 1;
% 2 - Calculating the lineshape
lgnd = {};
for i = 1:length(width_lhs)
    int_lorentzsplit{i}    = curve_lorentzian_split(xdat, center, amplitude, width_lhs(i), width_rhs);
    lgnd{i}           = "FWHM_lhs = " + string(width_lhs(i));
end
% 3 - Plotting the lineshapes & verifying the FWHM values
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
cols = parula(length(width_lhs) + 1);
for i = 1:length(width_lhs)
    plot(xdat, int_lorentzsplit{i}, 'k-', 'color', cols(i,:), 'linewidth', 2);
    % -- Verifying the peak peak
    cpeak   = max(int_lorentzsplit{i}(:));
    % -- Verifying the FWHM
    halfMax = 0.5*max(int_lorentzsplit{i}(:));                      % Find the half max value
    index1  = find(int_lorentzsplit{i}(:) >= halfMax, 1, 'first');  % Find where the data first drops below half the max
    index2  = find(int_lorentzsplit{i}(:) >= halfMax, 1, 'last');   % Find where the data last rises above half the max
    cfwhm   = xdat(index2) - xdat(index1);                     % Calculated FWHM
    sprintf("FWHM = %.2f, peak = %.2f", cfwhm, cpeak)
end
legend(lgnd, 'location', 'best', 'fontsize', 7, 'interpreter', 'none'); title('curve_lorentzian_split()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
ydat = int_lorentzsplit{i}; axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "curve_lorentzian_split()",'-dpng', '-r500');
%% 3.6    :   curve_voigt
help curve_voigt;
% 1 - Defining the input parameters
center      = 0;
amplitude   = 1.00;
width       = 3.00;
mixratio    = 0.:0.2:1;
% 2 - Calculating the lineshape
lgnd = {};
for i = 1:length(mixratio)
    int_voigt{i}    = curve_voigt(xdat, center, amplitude, width, mixratio(i));
    lgnd{i}           = "mixratio = " + string(mixratio(i));
end
% 3 - Plotting the lineshapes & verifying the FWHM values
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
cols = parula(length(mixratio) + 1);
for i = 1:length(mixratio)
    plot(xdat, int_voigt{i}, 'k-', 'color', cols(i,:), 'linewidth', 2);
    % -- Verifying the peak peak
    cpeak   = max(int_voigt{i}(:));
    % -- Verifying the FWHM
    halfMax = 0.5*max(int_voigt{i}(:));                      % Find the half max value
    index1  = find(int_voigt{i}(:) >= halfMax, 1, 'first');  % Find where the data first drops below half the max
    index2  = find(int_voigt{i}(:) >= halfMax, 1, 'last');   % Find where the data last rises above half the max
    cfwhm   = xdat(index2) - xdat(index1);                     % Calculated FWHM
    sprintf("FWHM = %.2f, peak = %.2f", cfwhm, cpeak)
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_voigt()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
ydat = int_voigt{i}; axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "curve_voigt()",'-dpng', '-r500');
%% 3.7    :   curve_pseudo_voigt_sGL
help curve_pseudo_voigt_sGL;
% 1 - Defining the input parameters
center          = 0;            % scalar of the peak position along the x-axis of the Lorentzian.
amplitude       = 1.0;          % scalar of the peak beneath the Lorentzian.
width           = 3.00;         % scalar of the full-width at half-maximum (FWHM) of the Lorentzian.
mixratio        = 0:0.2:1;    % scalar of the mixing ratio; 0 for pure Gaussian, 1 is for pure Lorentzian.
% 2 - Calculating the lineshape
lgnd = {};
for i = 1:length(mixratio)
    int_sGL{i}    = curve_pseudo_voigt_sGL(xdat, center, amplitude, width, mixratio(i));
    lgnd{i}         = "sGL-MR = " + string(mixratio(i));
end
% 3 - Plotting the lineshapes & verifying the FWHM values
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
cols = parula(length(mixratio) + 1);
for i = 1:length(mixratio)
    plot(xdat, int_sGL{i}, 'k-', 'color', cols(i,:), 'linewidth', 2);
    % -- Verifying the peak peak
    cpeak   = max(int_sGL{i}(:));
    % -- Verifying the FWHM
    halfMax = 0.5*max(int_sGL{i}(:));                      % Find the half max value
    index1  = find(int_sGL{i}(:) >= halfMax, 1, 'first');  % Find where the data first drops below half the max
    index2  = find(int_sGL{i}(:) >= halfMax, 1, 'last');   % Find where the data last rises above half the max
    cfwhm   = xdat(index2) - xdat(index1);                   % Calculated FWHM
    sprintf("FWHM = %.2f, peak = %.2f", cfwhm, cpeak)
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_pseudo_voigt_sGL()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
ydat = int_sGL{i}; axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "curve_pseudo_voigt_sGL()",'-dpng', '-r500');
%% 3.8    :   curve_pseudo_voigt_pGL
help curve_pseudo_voigt_pGL;
% 1 - Defining the input parameters
center          = 0;            % scalar of the peak position along the x-axis of the Lorentzian.
amplitude       = 1.0;          % scalar of the peak beneath the Lorentzian.
width           = 3.00;         % scalar of the full-width at half-maximum (FWHM) of the Lorentzian.
mixratio        = 0:0.2:1;    % scalar of the mixing ratio; 0 for pure Gaussian, 1 is for pure Lorentzian.
% 2 - Calculating the lineshape
lgnd = {};
for i = 1:length(mixratio)
    int_pGL{i}    = curve_pseudo_voigt_pGL(xdat, center, amplitude, width, mixratio(i));
    lgnd{i}       = "pGL-MR = " + string(mixratio(i));
end
% 3 - Plotting the lineshapes & verifying the FWHM values
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
cols = parula(length(mixratio) + 1);
for i = 1:length(mixratio)
    plot(xdat, int_pGL{i}, 'k-', 'color', cols(i,:), 'linewidth', 2);
    % -- Verifying the peak peak
    cpeak   = max(int_pGL{i}(:));
    % -- Verifying the FWHM
    halfMax = 0.5*max(int_pGL{i}(:));                      % Find the half max value
    index1  = find(int_pGL{i}(:) >= halfMax, 1, 'first');  % Find where the data first drops below half the max
    index2  = find(int_pGL{i}(:) >= halfMax, 1, 'last');   % Find where the data last rises above half the max
    cfwhm   = xdat(index2) - xdat(index1);                   % Calculated FWHM
    sprintf("FWHM = %.2f, peak = %.2f", cfwhm, cpeak)
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_pseudo_voigt_pGL()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
ydat = int_pGL{i}; axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "curve_pseudo_voigt_pGL()",'-dpng', '-r500');
%% 3.9    :   curve_pseudo_voigt_sGLA
help curve_pseudo_voigt_sGLA;
% 1 - Defining the input parameters
center          = 0;            % scalar of the peak position along the x-axis of the Lorentzian.
amplitude       = 1.00;          % scalar of the peak beneath the Lorentzian.
width           = 3.00;         % scalar of the full-width at half-maximum (FWHM) of the Lorentzian.
mixratio        = 0.5;          % scalar of the mixing ratio; 0 for pure Gaussian, 1 is for pure Lorentzian.
asymmetry       = [0, 0.1, 0.2, 0.4, 0.8, 1.0];            % scalar of the asymmetry ratio; 0 for none, 1 is for maximum.
% 2 - Calculating the lineshape
lgnd = {};
for i = 1:length(asymmetry)
    int_sGLA{i}    = curve_pseudo_voigt_sGLA(xdat, center, amplitude, width, mixratio, asymmetry(i));
    lgnd{i}        = "asymmetry = " + string(asymmetry(i));
end
% 3 - Plotting the lineshapes & verifying the FWHM values
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
cols = parula(length(asymmetry) + 1);
for i = 1:length(asymmetry)
    plot(xdat, int_sGLA{i}, 'k-', 'color', cols(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_pseudo_voigt_sGLA()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
ydat = int_sGLA{i}; axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "curve_pseudo_voigt_sGLA()",'-dpng', '-r500');
%% 3.10    :   curve_pseudo_voigt_pGLA
help curve_pseudo_voigt_pGLA;
% 1 - Defining the input parameters
center          = 0;            % scalar of the peak position along the x-axis of the Lorentzian.
amplitude       = 1.00;          % scalar of the peak beneath the Lorentzian.
width           = 3.00;         % scalar of the full-width at half-maximum (FWHM) of the Lorentzian.
mixratio        = 0.5;          % scalar of the mixing ratio; 0 for pure Gaussian, 1 is for pure Lorentzian.
asymmetry       = [0, 0.1, 0.2, 0.4, 0.8, 1.0];            % scalar of the asymmetry ratio; 0 for none, 1 is for maximum.
% 2 - Calculating the lineshape
lgnd = {};
for i = 1:length(asymmetry)
    int_pGLA{i}    = curve_pseudo_voigt_pGLA(xdat, center, amplitude, width, mixratio, asymmetry(i));
    lgnd{i}        = "asymmetry = " + string(asymmetry(i));
end
% 3 - Plotting the lineshapes & verifying the FWHM values
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
cols = parula(length(asymmetry) + 1);
for i = 1:length(asymmetry)
    plot(xdat, int_pGLA{i}, 'k-', 'color', cols(i,:), 'linewidth', 2);
%     h = plot(xdat, int_AEB{i}, 'k--', 'color', col_gauss(i,:), 'linewidth', 1);
%     h.Annotation.LegendInformation.IconDisplayStyle = 'off';
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_pseudo_voigt_pGLA()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
ydat = int_pGLA{i}; axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "curve_pseudo_voigt_pGLA()",'-dpng', '-r500');
%% 3.11    :   curve_pseudo_voigt_sGLA_FDD
help curve_pseudo_voigt_sGLA_FDD;
% 1 - Defining the input parameters
center      = 0;            % scalar of the peak position along the x-axis of the Lorentzian.
amplitude   = 1.00;          % scalar of the peak beneath the Lorentzian.
width       = 3.00;         % scalar of the full-width at half-maximum (FWHM) of the Lorentzian.
mr          = 0.5;          % scalar of the mixing ratio; 0 for pure Gaussian, 1 is for pure Lorentzian.
asymmetry   = 0.0;          % scalar of the asymmetry ratio; 0 for none, 1 is for maximum.
fdd_ef      = 0.0;            % scalar of the location of the Fermi-level
fdd_T       = 12;           % scalar of the temperature of the system
fdd_fwhm    = [0.02, 0.08, 0.16, 0.32, 0.64, 1.0, 2.0];         % scalar of the Gaussian FWHM to be convolved
% 2 - Calculating the lineshape
lgnd = {};
for i = 1:length(fdd_fwhm)
    int_sGLA_FDD{i}     = curve_pseudo_voigt_sGLA_FDD(xdat, center, amplitude, width, mr, asymmetry, fdd_ef, fdd_T, fdd_fwhm(i));
    lgnd{i}             = "fdd-FWHM = " + string(fdd_fwhm(i));
end
% 3 - Plotting the lineshapes & verifying the FWHM values
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
cols = parula(length(fdd_fwhm) + 1);
for i = 1:length(fdd_fwhm)
    plot(xdat, int_sGLA_FDD{i}, 'k-', 'color', cols(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_pseudo_voigt_sGLA_FDD()', 'interpreter', 'none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
ydat = int_sGLA_FDD{i}; axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "curve_pseudo_voigt_sGLA_FDD()",'-dpng', '-r500');
%% 3.12    :   curve_pseudo_voigt_pGLA_FDD
help curve_pseudo_voigt_pGLA_FDD;
% 1 - Defining the input parameters
center      = 0;            % scalar of the peak position along the x-axis of the Lorentzian.
amplitude   = 1.00;          % scalar of the peak beneath the Lorentzian.
width       = 3.00;         % scalar of the full-width at half-maximum (FWHM) of the Lorentzian.
mr          = 0.5;          % scalar of the mixing ratio; 0 for pure Gaussian, 1 is for pure Lorentzian.
asymmetry   = 0.0;          % scalar of the asymmetry ratio; 0 for none, 1 is for maximum.
fdd_ef      = 0.0;            % scalar of the location of the Fermi-level
fdd_T       = 12;           % scalar of the temperature of the system
fdd_fwhm    = [0.02, 0.08, 0.16, 0.32, 0.64, 1.0, 2.0];         % scalar of the Gaussian FWHM to be convolved
% 2 - Calculating the lineshape
lgnd = {};
for i = 1:length(fdd_fwhm)
    int_pGLA_FDD{i}     = curve_pseudo_voigt_pGLA_FDD(xdat, center, amplitude, width, mr, asymmetry, fdd_ef, fdd_T, fdd_fwhm(i));
    lgnd{i}             = "fdd-FWHM = " + string(fdd_fwhm(i));
end
% 3 - Plotting the lineshapes & verifying the FWHM values
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
cols = parula(length(fdd_fwhm) + 1);
for i = 1:length(fdd_fwhm)
    plot(xdat, int_pGLA_FDD{i}, 'k-', 'color', cols(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_pseudo_voigt_pGLA_FDD()', 'interpreter', 'none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
ydat = int_pGLA_FDD{i}; axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "curve_pseudo_voigt_pGLA_FDD()",'-dpng', '-r500');

%% 4    :   Periodic Models
close all;
%% 4.1    :   curve_sine
help curve_sine;
% 1 - Defining the input parameters
amplitude   = 1;
frequency       = 1./[pi, pi/2, pi/4];
phaseshift       = 0;
% 2 - Calculating model
lgnd = {}; ydat = {};
for i = 1:length(frequency)
    ydat{i}    = curve_sine(xdat, amplitude, frequency(i), phaseshift);
    lgnd{i}       = "frequency = " + string(frequency(i));
end
% 3 - Plotting model
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
cols = parula(length(frequency) + 1);
for i = 1:length(frequency)
    plot(xdat, ydat{i}, 'k-', 'color', cols(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_sine()', 'interpreter', 'none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
print(path_save  + "curve_sine()",'-dpng', '-r500');

%% 5    :   Step-Like Models
close all;
%% 5.1    :   curve_step_lhs
help curve_step_lhs;
center      = 0; 
amplitude   = 1:1:5;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_gauss = parula(length(amplitude) + 1);
lgnd = {};
for i = 1:length(amplitude)
    ydat = curve_step_lhs(xdat, center, amplitude(i));
    lgnd{i}       = "amplitude = " + string(amplitude(i));
    plot(xdat, ydat, 'k-', 'color', col_gauss(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_step_lhs()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "curve_step_lhs()",'-dpng', '-r500');
%% 5.2    :   curve_step_rhs
help curve_step_rhs;
center      = 0; 
amplitude   = 1:1:5;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_gauss = parula(length(amplitude) + 1);
lgnd = {};
for i = 1:length(amplitude)
    ydat = curve_step_rhs(xdat, center, amplitude(i));
    lgnd{i}       = "amplitude = " + string(amplitude(i));
    plot(xdat, ydat, 'k-', 'color', col_gauss(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_step_rhs()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "curve_step_rhs()",'-dpng', '-r500');
%% 5.3    :   curve_step_lhs_gauss
help curve_step_lhs_gauss;
center      = 0; 
amplitude   = 1;
width       = 0:0.2:1;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_gauss = parula(length(width) + 1);
lgnd = {};
for i = 1:length(width)
    ydat = curve_step_lhs_gauss(xdat, center, amplitude, width(i));
    lgnd{i}       = "FWHM = " + string(width(i));
    plot(xdat, ydat, 'k-', 'color', col_gauss(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_step_lhs_gauss()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "curve_step_lhs_gauss()",'-dpng', '-r500');
%% 5.4    :   curve_step_rhs_gauss
help curve_step_rhs_gauss;
center      = 0; 
amplitude   = 1;
width       = 0:0.2:1;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_gauss = parula(length(width) + 1);
lgnd = {};
for i = 1:length(width)
    ydat = curve_step_rhs_gauss(xdat, center, amplitude, width(i));
    lgnd{i}       = "FWHM = " + string(width(i));
    plot(xdat, ydat, 'k-', 'color', col_gauss(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_step_rhs_gauss()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "curve_step_rhs_gauss()",'-dpng', '-r500');
%% 5.5    :   curve_step_lhs_gauss_trunc
help curve_step_lhs_gauss_trunc;
center      = 0; 
amplitude   = 1;
width       = 0:0.2:1;
cutoff      = 0.5;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_Gauss = parula(length(width) + 1);
lgnd = {};
for i = 1:length(width)
    ydat = curve_step_lhs_gauss_trunc(xdat, center, amplitude, width(i), cutoff);
    lgnd{i}       = "FWHM = " + string(width(i));
    plot(xdat, ydat, 'k-', 'color', col_Gauss(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_step_lhs_gauss_trunc()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "curve_step_lhs_gauss_trunc()",'-dpng', '-r500');
%% 5.6    :   curve_step_rhs_gauss_trunc
help curve_step_rhs_gauss_trunc;
center      = 0; 
amplitude   = 1;
width       = 0:0.2:1;
cutoff      = 0.5;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_Gauss = parula(length(width) + 1);
lgnd = {};
for i = 1:length(width)
    ydat = curve_step_rhs_gauss_trunc(xdat, center, amplitude, width(i), cutoff);
    lgnd{i}       = "FWHM = " + string(width(i));
    plot(xdat, ydat, 'k-', 'color', col_Gauss(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_step_rhs_gauss_trunc()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "curve_step_rhs_gauss_trunc()",'-dpng', '-r500');
%% 5.7    :   curve_step_lhs_exp
help curve_step_lhs_exp;
center      = 0; 
amplitude   = 1;
cdl         = 0:0.2:1;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_Exp = parula(length(cdl) + 1);
lgnd = {};
for i = 1:length(cdl)
    ydat = curve_step_lhs_exp(xdat, center, amplitude, cdl(i));
    lgnd{i}       = "CDL = " + string(cdl(i));
    plot(xdat, ydat, 'k-', 'color', col_Exp(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_step_lhs_exp()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "curve_step_lhs_exp()",'-dpng', '-r500');
%% 5.8    :   curve_step_rhs_exp
help curve_step_rhs_exp;
center      = 0; 
amplitude   = 1;
cdl         = 0:0.2:1;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_Exp = parula(length(cdl) + 1);
lgnd = {};
for i = 1:length(cdl)
    ydat = curve_step_rhs_exp(xdat, center, amplitude, cdl(i));
    lgnd{i}       = "CDL = " + string(cdl(i));
    plot(xdat, ydat, 'k-', 'color', col_Exp(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_step_rhs_exp()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "curve_step_rhs_exp()",'-dpng', '-r500');
%% 5.9    :   curve_step_lhs_exp_trunc
help curve_step_lhs_exp_trunc;
center      = 0; 
amplitude   = 1;
cdl         = 0:0.2:1;
cutoff      = 0.5;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_Exp = parula(length(cdl) + 1);
lgnd = {};
for i = 1:length(cdl)
    ydat = curve_step_lhs_exp_trunc(xdat, center, amplitude, cdl(i), cutoff);
    lgnd{i}       = "CDL = " + string(cdl(i));
    plot(xdat, ydat, 'k-', 'color', col_Exp(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_step_lhs_exp_trunc()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "curve_step_lhs_exp_trunc()",'-dpng', '-r500');
%% 5.10    :   curve_step_rhs_exp_trunc
help curve_step_rhs_exp_trunc;
center      = 0; 
amplitude   = 1;
cdl         = 0:0.2:1;
cutoff      = 0.5;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_Exp = parula(length(cdl) + 1);
lgnd = {};
for i = 1:length(cdl)
    ydat = curve_step_rhs_exp_trunc(xdat, center, amplitude, cdl(i), cutoff);
    lgnd{i}       = "CDL = " + string(cdl(i));
    plot(xdat, ydat, 'k-', 'color', col_Exp(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_step_rhs_exp_trunc()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "curve_step_rhs_exp_trunc()",'-dpng', '-r500');
%% 5.11    :   curve_step_lhs_erf
help curve_step_lhs_erf;
center      = 0; 
amplitude   = 1;
fwhm        = 0:0.1:0.5;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_Exp = parula(length(fwhm) + 1);
lgnd = {};
for i = 1:length(fwhm)
    ydat = curve_step_lhs_erf(xdat, center, amplitude, fwhm(i));
    lgnd{i}       = "FWHM = " + string(fwhm(i));
    plot(xdat, ydat, 'k-', 'color', col_Exp(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_step_lhs_erf()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), min(ydat(:)), 1.1*max(ydat(:))]);
print(path_save  + "curve_step_lhs_erf()",'-dpng', '-r500');
%% 5.12    :   curve_step_rhs_erf
help curve_step_rhs_erf;
center      = 0; 
amplitude   = 1;
fwhm        = 0:0.1:0.5;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_Exp = parula(length(fwhm) + 1);
lgnd = {};
for i = 1:length(fwhm)
    ydat = curve_step_rhs_erf(xdat, center, amplitude, fwhm(i));
    lgnd{i}       = "FWHM = " + string(fwhm(i));
    plot(xdat, ydat, 'k-', 'color', col_Exp(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_step_rhs_erf()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), min(ydat(:)), 1.1*max(ydat(:))]);
print(path_save  + "curve_step_rhs_erf()",'-dpng', '-r500');

%% 6    :   FERMI-DIRAC DISTRIBUTION LINESHAPE
close all;
%% 6.1    :   Pure FDD function
help curve_thermal_FDD;
% 1 - Defining the input parameters
FDEF        = 0;                  % scalar of the location of the Fermi-level
FDT         = [10,20,40,80,160,200,250,300,500]; % scalar of the temperature of the system
% 2 - Calculating the lineshape
lgnd = {}; ydat = {};
for i = 1:length(FDT)
    ydat{i}    = curve_thermal_FDD(xdat, FDEF, FDT(i));
    lgnd{i}       = "FDD-T = " + string(FDT(i));
end
% 3 - Plotting the lineshapes & verifying the FWHM values
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
cols = parula(length(FDT) + 1);
for i = 1:length(FDT)
    plot(xdat, ydat{i}, 'k-', 'color', cols(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_thermal_FDD()', 'interpreter', 'none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
ydat = ydat{i}; axis([min(xdat(:)), max(xdat(:)), min(ydat(:)), 1.1*max(ydat(:))]);
print(path_save  + "curve_thermal_FDD()",'-dpng', '-r500');
%% 6.2    :   Gaussian broadened FDD function
help curve_thermal_FDDG;
% 1 - Defining the input parameters
FDEF        = 0;            % scalar of the location of the Fermi-level
FDT         = 12;           % scalar of the temperature of the system
FDW         = [0.02, 0.04, 0.08, 0.16, 0.32, 0.64, 1.0, 2.0];         % scalar of the Gaussian FWHM to be convolved
% 2 - Calculating the lineshape
lgnd = {}; int_FDDG = {};
for i = 1:length(FDW)
    int_FDDG{i}    = curve_thermal_FDDG(xdat, FDEF, FDT, FDW(i));
    lgnd{i}       = "FDDG-fwhm = " + string(FDW(i));
end
% 3 - Plotting the lineshapes & verifying the FWHM values
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
cols = parula(length(FDW) + 1);
for i = 1:length(FDW)
    plot(xdat, int_FDDG{i}, 'k-', 'color', cols(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_thermal_FDDG()', 'interpreter', 'none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
ydat = int_FDDG{i}; axis([min(xdat(:)), max(xdat(:)), min(ydat(:)), 1.1*max(ydat(:))]);
print(path_save  + "curve_thermal_FDDG()",'-dpng', '-r500');
%% 6.3    :   Gaussian broadened FDD function with a multiplied linear background
help curve_thermal_FDDGpL;
% 1 - Defining the input parameters
FDEF    = 0.0;          % scalar of the location of the Fermi-level
FDT     = 12;           % scalar of the temperature of the system
FDW     = 0.30;         % scalar of the Gaussian FWHM to be convolved
BGR     = 0:-0.1:-1;    % scalar of the gradient of the linear background.
BIN     = 1.;           % scalar of the y-intercept of the linear background.
BCO     = 0.05;         % scalar of the constant background y-offset value.
% 2 - Calculating the lineshape
lgnd = {}; int_FDDGpL = {};
for i = 1:length(BGR)
    int_FDDGpL{i}    = curve_thermal_FDDGpL(xdat, FDEF, FDT, FDW, BGR(i), BIN, BCO);
    lgnd{i}       = "FDDGpL-slope = " + string(BGR(i));
end
% 3 - Plotting the lineshapes & verifying the FWHM values
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
cols = parula(length(BGR) + 1);
for i = 1:length(BGR)
    plot(xdat, int_FDDGpL{i}, 'k-', 'color', cols(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_thermal_FDDGpL()', 'interpreter', 'none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
ydat = int_FDDGpL{i}; axis([min(xdat(:)), max(xdat(:)), min(ydat(:)), 1.1*max(ydat(:))]);
print(path_save  + "curve_thermal_FDDGpL()",'-dpng', '-r500');
%% 6.4    :   Gaussian broadened FDD function with a summed linear background
help curve_thermal_FDDGsL;
% 1 - Defining the input parameters
FDEF    = 0.0;          % scalar of the location of the Fermi-level
FDT     = 12;           % scalar of the temperature of the system
FDW     = 0.30;         % scalar of the Gaussian FWHM to be convolved
BGR     = 0:-0.1:-1;
BIN     = 0.;
BCO     = 0.0;
% 2 - Calculating the lineshape
lgnd = {}; int_FDDGsL = {};
for i = 1:length(BGR)
    int_FDDGsL{i}    = curve_thermal_FDDGsL(xdat, FDEF, FDT, FDW, BGR(i), BIN, BCO);
    lgnd{i}       = "FDDGsL-slope = " + string(BGR(i));
end
% 3 - Plotting the lineshapes & verifying the FWHM values
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
cols = parula(length(BGR) + 1);
for i = 1:length(BGR)
    plot(xdat, int_FDDGsL{i}, 'k-', 'color', cols(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_thermal_FDDGsL()', 'interpreter', 'none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
ydat = int_FDDGsL{i}; axis([min(xdat(:)), max(xdat(:)), min(ydat(:)), 1.1*max(ydat(:))]);
print(path_save  + "curve_thermal_FDDGsL()",'-dpng', '-r500');

%% 7    :   TopHat-Like Models
close all;
%% 7.1    :   curve_tophat
help curve_tophat;
center      = 0; 
amplitude   = 1;
width       = 1:1:5;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_gauss = parula(length(width) + 1);
lgnd = {};
for i = 1:length(width)
    ydat = curve_tophat(xdat, center, amplitude, width(i));
    lgnd{i}       = "width = " + string(width(i));
    plot(xdat, ydat, 'k-', 'color', col_gauss(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_tophat()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "curve_tophat()",'-dpng', '-r500');
%% 7.2    :   curve_tophat_erf
help curve_tophat_erf;
center      = 0; 
amplitude   = 1;
width       = 3;
fwhm        = 0:0.2:1;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_gauss = parula(length(fwhm) + 1);
lgnd = {};
for i = 1:length(fwhm)
    ydat = curve_tophat_erf(xdat, center, amplitude, width, fwhm(i));
    lgnd{i}       = "FWHM = " + string(fwhm(i));
    plot(xdat, ydat, 'k-', 'color', col_gauss(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_tophat_erf()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "curve_tophat_erf()",'-dpng', '-r500');
%% 7.3    :   curve_tophat_lhs_erf
help curve_tophat_lhs_erf;
center      = 0; 
amplitude   = 1;
width       = 3;
fwhm        = 0:0.2:1;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_gauss = parula(length(fwhm) + 1);
lgnd = {};
for i = 1:length(fwhm)
    ydat = curve_tophat_lhs_erf(xdat, center, amplitude, width, fwhm(i));
    lgnd{i}       = "FWHM = " + string(fwhm(i));
    plot(xdat, ydat, 'k-', 'color', col_gauss(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_tophat_lhs_erf()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "curve_tophat_lhs_erf()",'-dpng', '-r500');
%% 7.4    :   curve_tophat_rhs_erf
help curve_tophat_rhs_erf;
center      = 0; 
amplitude   = 1;
width       = 3;
fwhm        = 0:0.2:1;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_gauss = parula(length(fwhm) + 1);
lgnd = {};
for i = 1:length(fwhm)
    ydat = curve_tophat_rhs_erf(xdat, center, amplitude, width, fwhm(i));
    lgnd{i}       = "FWHM = " + string(fwhm(i));
    plot(xdat, ydat, 'k-', 'color', col_gauss(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_tophat_rhs_erf()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "curve_tophat_rhs_erf()",'-dpng', '-r500');

%% 7.5    :   curve_tophat_exp
help curve_tophat_exp;
center      = 0; 
amplitude   = 1;
width       = 3;
cdl         = 0:0.2:1;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_gauss = parula(length(cdl) + 1);
lgnd = {};
for i = 1:length(cdl)
    ydat = curve_tophat_exp(xdat, center, amplitude, width, cdl(i));
    lgnd{i}       = "CDL = " + string(cdl(i));
    plot(xdat, ydat, 'k-', 'color', col_gauss(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_tophat_exp()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "curve_tophat_exp()",'-dpng', '-r500');
%% 7.6    :   curve_tophat_lhs_exp
help curve_tophat_lhs_exp;
center      = 0; 
amplitude   = 1;
width       = 3;
cdl         = 0:0.2:1;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_gauss = parula(length(cdl) + 1);
lgnd = {};
for i = 1:length(cdl)
    ydat = curve_tophat_lhs_exp(xdat, center, amplitude, width, cdl(i));
    lgnd{i}       = "CDL = " + string(cdl(i));
    plot(xdat, ydat, 'k-', 'color', col_gauss(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_tophat_lhs_exp()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "curve_tophat_lhs_exp()",'-dpng', '-r500');
%% 7.7    :   curve_tophat_rhs_exp
help curve_tophat_rhs_exp;
center      = 0; 
amplitude   = 1;
width       = 3;
cdl         = 0:0.2:1;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_gauss = parula(length(cdl) + 1);
lgnd = {};
for i = 1:length(cdl)
    ydat = curve_tophat_rhs_exp(xdat, center, amplitude, width, cdl(i));
    lgnd{i}       = "CDL = " + string(cdl(i));
    plot(xdat, ydat, 'k-', 'color', col_gauss(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_tophat_rhs_exp()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "curve_tophat_rhs_exp()",'-dpng', '-r500');
%% 7.8    :   curve_tophat_lhs_exp_trunc
help curve_tophat_lhs_exp_trunc;
center      = 0; 
amplitude   = 1;
width       = 3;
cdl         = 0:0.2:1;
cutoff      = 2;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_gauss = parula(length(cdl) + 1);
lgnd = {};
for i = 1:length(cdl)
    ydat = curve_tophat_lhs_exp_trunc(xdat, center, amplitude, width, cdl(i), cutoff);
    lgnd{i}       = "CDL = " + string(cdl(i));
    plot(xdat, ydat, 'k-', 'color', col_gauss(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_tophat_lhs_exp_trunc()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), min(ydat(:)), 1.1*max(ydat(:))]);
print(path_save  + "curve_tophat_lhs_exp_trunc()",'-dpng', '-r500');
%% 7.9    :   curve_tophat_rhs_exp_trunc
help curve_tophat_rhs_exp_trunc;
center      = 0; 
amplitude   = 1;
width       = 3;
cdl         = 0:0.2:1;
cutoff      = 2;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_gauss = parula(length(cdl) + 1);
lgnd = {};
for i = 1:length(cdl)
    ydat = curve_tophat_rhs_exp_trunc(xdat, center, amplitude, width, cdl(i), cutoff);
    lgnd{i}       = "CDL = " + string(cdl(i));
    plot(xdat, ydat, 'k-', 'color', col_gauss(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_tophat_rhs_exp_trunc()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), min(ydat(:)), 1.1*max(ydat(:))]);
print(path_save  + "curve_tophat_rhs_exp_trunc()",'-dpng', '-r500');
%% 7.10    :   curve_tophat_gauss
help curve_tophat_gauss;
center      = 0; 
amplitude   = 1;
width       = 3;
fwhm        = 0:0.5:2;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_gauss = parula(length(fwhm) + 1);
lgnd = {};
for i = 1:length(fwhm)
    ydat = curve_tophat_gauss(xdat, center, amplitude, width, fwhm(i));
    lgnd{i}       = "FWHM = " + string(fwhm(i));
    plot(xdat, ydat, 'k-', 'color', col_gauss(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_tophat_gauss()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "curve_tophat_gauss()",'-dpng', '-r500');
%% 7.11    :   curve_tophat_lhs_gauss
help curve_tophat_lhs_gauss;
center      = 0; 
amplitude   = 1;
width       = 3;
fwhm        = 0:0.5:2;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_gauss = parula(length(fwhm) + 1);
lgnd = {};
for i = 1:length(fwhm)
    ydat = curve_tophat_lhs_gauss(xdat, center, amplitude, width, fwhm(i));
    lgnd{i}       = "FWHM = " + string(fwhm(i));
    plot(xdat, ydat, 'k-', 'color', col_gauss(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_tophat_lhs_gauss()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "curve_tophat_lhs_gauss()",'-dpng', '-r500');
%% 7.12    :   curve_tophat_rhs_gauss
help curve_tophat_rhs_gauss;
center      = 0; 
amplitude   = 1;
width       = 3;
fwhm        = 0:0.5:2;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_gauss = parula(length(fwhm) + 1);
lgnd = {};
for i = 1:length(fwhm)
    ydat = curve_tophat_rhs_gauss(xdat, center, amplitude, width, fwhm(i));
    lgnd{i}       = "FWHM = " + string(fwhm(i));
    plot(xdat, ydat, 'k-', 'color', col_gauss(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_tophat_rhs_gauss()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "curve_tophat_rhs_gauss()",'-dpng', '-r500');
%% 7.13    :   curve_tophat_lhs_gauss_trunc
help curve_tophat_lhs_gauss_trunc;
center      = 0; 
amplitude   = 1;
width       = 3;
fwhm        = 0:0.5:2;
cutoff      = 1;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_gauss = parula(length(fwhm) + 1);
lgnd = {};
for i = 1:length(fwhm)
    ydat = curve_tophat_lhs_gauss_trunc(xdat, center, amplitude, width, fwhm(i), cutoff);
    lgnd{i}       = "FWHM = " + string(fwhm(i));
    plot(xdat, ydat, 'k-', 'color', col_gauss(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_tophat_lhs_gauss_trunc()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), min(ydat(:)), 1.1*max(ydat(:))]);
print(path_save  + "curve_tophat_lhs_gauss_trunc()",'-dpng', '-r500');
%% 7.14    :   curve_tophat_rhs_gauss_trunc
help curve_tophat_rhs_gauss_trunc;
center      = 0; 
amplitude   = 1;
width       = 3;
fwhm        = 0:0.5:2;
cutoff      = 1;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_gauss = parula(length(fwhm) + 1);
lgnd = {};
for i = 1:length(fwhm)
    ydat = curve_tophat_rhs_gauss_trunc(xdat, center, amplitude, width, fwhm(i), cutoff);
    lgnd{i}       = "FWHM = " + string(fwhm(i));
    plot(xdat, ydat, 'k-', 'color', col_gauss(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('curve_tophat_rhs_gauss_trunc()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), min(ydat(:)), 1.1*max(ydat(:))]);
print(path_save  + "curve_tophat_rhs_gauss_trunc()",'-dpng', '-r500');
