close all; clear all;
path_matbase    = what('MatBase'); path_matbase = string(path_matbase.path);
path_save       = path_matbase + "\MatBase-v1.2\PES Data Analysis\PES Modelling And Fitting\Fitting Models - Generic\0_figs\";
xdat = linspace(-6, 6, 1e3);
%% 1    :   Exponential And Power Law Models
close all;
%% 1.1    :   ExponentialModel
help ExponentialModel;
% 1 - Defining the input parameters
amplitude   = 1;
decay       = 1:1:5;
% 2 - Calculating model
lgnd = {}; ydat = {};
for i = 1:length(decay)
    ydat{i}    = ExponentialModel(xdat, amplitude, decay(i));
    lgnd{i}       = "decay = " + string(decay(i));
end
% 3 - Plotting model
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
cols = parula(length(decay) + 1);
for i = 1:length(decay)
    plot(xdat, ydat{i}, 'k-', 'color', cols(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('ExponentialModel()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
print(path_save  + "ExponentialModel()",'-dpng', '-r500');
%% 1.2    :   PowerLawModel
help PowerLawModel;
% 1 - Defining the input parameters
amplitude   = 1;
exponent    = 1:1:6;
% 2 - Calculating model
lgnd = {}; ydat = {};
for i = 1:length(exponent)
    ydat{i}    = PowerLawModel(xdat, amplitude, exponent(i));
    lgnd{i}       = "exponent = " + string(exponent(i));
end
% 3 - Plotting model
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
cols = parula(length(exponent) + 1);
for i = 1:length(exponent)
    plot(xdat, ydat{i}, 'k-', 'color', cols(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('PowerLawModel()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
print(path_save  + "PowerLawModel()",'-dpng', '-r500');

%% 2    :   Linear And Polynomial Models
close all;
%% 2.1    :   ConstantModel
help ConstantModel;
% 1 - Defining the input parameters
constant       = 1:1:5;
% 2 - Calculating model
lgnd = {}; ydat = {};
for i = 1:length(constant)
    ydat{i}    = ConstantModel(xdat, constant(i));
    lgnd{i}       = "constant = " + string(constant(i));
end
% 3 - Plotting model
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
cols = parula(length(constant) + 1);
for i = 1:length(constant)
    plot(xdat, ydat{i}, 'k-', 'color', cols(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('ConstantModel()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
print(path_save  + "ConstantModel()",'-dpng', '-r500');
%% 2.2    :   LinModel
help LinModel;
% 1 - Defining the input parameters
slope       = 1:1:5;
intercept   = 2;
% 2 - Calculating model
lgnd = {}; ydat = {};
for i = 1:length(slope)
    ydat{i}    = LinModel(xdat, slope(i), intercept);
    lgnd{i}       = "slope = " + string(slope(i));
end
% 3 - Plotting model
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
cols = parula(length(slope) + 1);
for i = 1:length(slope)
    plot(xdat, ydat{i}, 'k-', 'color', cols(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('LinModel()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
print(path_save  + "LinModel()",'-dpng', '-r500');
%% 2.3    :   QuadraticModel
help QuadraticModel;
% 1 - Defining the input parameters
a   = 1:1:5;
b   = 0;
c   = 0;
% 2 - Calculating model
lgnd = {}; ydat = {};
for i = 1:length(a)
    ydat{i}    = QuadraticModel(xdat, a(i), b, c);
    lgnd{i}       = "b = " + string(a(i));
end
% 3 - Plotting model
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
cols = parula(length(a) + 1);
for i = 1:length(a)
    plot(xdat, ydat{i}, 'k-', 'color', cols(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('QuadraticModel()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
print(path_save  + "QuadraticModel()",'-dpng', '-r500');

%% 3    :   Peak-Like Models
close all;
%% 3.1    :   AsymExpBlendModel
help AsymExpBlendModel;
% 1 - Defining the input parameters
center              = 0.;
asymmetry       = [-0.5,-0.25,0,0.25,0.5];
% 2 - Calculating the lineshape
lgnd = {}; int_AEB = {};
for i = 1:length(asymmetry)
    int_AEB{i}    = AsymExpBlendModel(xdat, center, asymmetry(i));
    lgnd{i}        = "asymmetry = " + string(asymmetry(i));
end
% 3 - Plotting the lineshapes & verifying the FWHM values
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
cols = parula(length(asymmetry) + 1);
for i = 1:length(asymmetry)
    plot(xdat, int_AEB{i}, 'k-', 'color', cols(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('AsymExpBlendModel()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
int_AEB = int_AEB{1};
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(int_AEB(:))]);
print(path_save  + "AsymExpBlendModel()",'-dpng', '-r500');
%% 3.2    :   DoniachModel
help DoniachModel;
% 1 - Defining the input parameters
center          = 0;            % scalar of the peak position along the x-axis of the Lorentzian.
amplitude       = 1.0;          % scalar of the peak beneath the Lorentzian.
width           = 0.25;         % scalar of the width parameter
asymmetry       = 0.0:0.1:0.5;    % scalar of the asymmetry ratio; 0 for none, 1 is for maximum.
% 2 - Calculating the lineshape
lgnd = {};
for i = 1:length(asymmetry)
    int_DS{i}    = DoniachModel(xdat, center, amplitude, width, asymmetry(i));
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
legend(lgnd, 'location', 'best', 'fontsize', 7); title('DoniachModel()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
ydat = int_DS{i}; axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "DoniachModel()",'-dpng', '-r500');
%% 3.3    :   GaussianModel
help GaussianModel;
% 1 - Defining the input parameters
center          = 0;            % scalar of the peak position along the x-axis of the Gaussian.
amplitude       = 1.00;         % scalar of the peak beneath the Gaussian.
width           = 1:0.5:4;    % scalar of the full-width at half-maximum (FWHM) of the Gaussian.
% 2 - Calculating the lineshape
lgnd = {};
for i = 1:length(width)
    int_gauss{i}    = GaussianModel(xdat, center, amplitude, width(i));
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
legend(lgnd, 'location', 'best', 'fontsize', 7); title('GaussianModel()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
ydat = int_gauss{i}; axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "GaussianModel()",'-dpng', '-r500');
%% 3.4    :   LorentzianModel
help LorentzianModel;
% 1 - Defining the input parameters
center          = 0;            % scalar of the peak position along the x-axis of the Lorentzian.
amplitude       = 1.00;            % scalar of the peak beneath the Lorentzian.
width           = 1:0.5:4;    % scalar of the full-width at half-maximum (FWHM) of the Lorentzian.
% 2 - Calculating the lineshape
lgnd = {};
for i = 1:length(width)
    int_lorentz{i}    = LorentzianModel(xdat, center, amplitude, width(i));
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
legend(lgnd, 'location', 'best', 'fontsize', 7); title('LorentzianModel()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
ydat = int_lorentz{i}; axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "LorentzianModel()",'-dpng', '-r500');
%% 3.5    :   LorentzianSplitModel
help LorentzianSplitModel;
% 1 - Defining the input parameters
center      = 0;            % scalar of the peak position along the x-axis of the Lorentzian.
amplitude   = 1.00;            % scalar of the peak beneath the Lorentzian.
width_lhs   = 0.4:0.2:2;    % scalar of the full-width at half-maximum (FWHM) of the Lorentzian.
width_rhs   = 1;
% 2 - Calculating the lineshape
lgnd = {};
for i = 1:length(width_lhs)
    int_lorentzsplit{i}    = LorentzianSplitModel(xdat, center, amplitude, width_lhs(i), width_rhs);
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
legend(lgnd, 'location', 'best', 'fontsize', 7, 'interpreter', 'none'); title('LorentzianSplitModel()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
ydat = int_lorentzsplit{i}; axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "LorentzianSplitModel()",'-dpng', '-r500');
%% 3.6    :   VoigtModel
help VoigtModel;
% 1 - Defining the input parameters
center      = 0;
amplitude   = 1.00;
width       = 3.00;
mixratio    = 0.:0.2:1;
% 2 - Calculating the lineshape
lgnd = {};
for i = 1:length(mixratio)
    int_voigt{i}    = VoigtModel(xdat, center, amplitude, width, mixratio(i));
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
legend(lgnd, 'location', 'best', 'fontsize', 7); title('VoigtModel()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
ydat = int_voigt{i}; axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "VoigtModel()",'-dpng', '-r500');
%% 3.7    :   PseudoVoigtModel_sGL
help PseudoVoigtModel_sGL;
% 1 - Defining the input parameters
center          = 0;            % scalar of the peak position along the x-axis of the Lorentzian.
amplitude       = 1.0;          % scalar of the peak beneath the Lorentzian.
width           = 3.00;         % scalar of the full-width at half-maximum (FWHM) of the Lorentzian.
mixratio        = 0:0.2:1;    % scalar of the mixing ratio; 0 for pure Gaussian, 1 is for pure Lorentzian.
% 2 - Calculating the lineshape
lgnd = {};
for i = 1:length(mixratio)
    int_sGL{i}    = PseudoVoigtModel_sGL(xdat, center, amplitude, width, mixratio(i));
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
legend(lgnd, 'location', 'best', 'fontsize', 7); title('PseudoVoigtModel_sGL()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
ydat = int_sGL{i}; axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "PseudoVoigtModel_sGL()",'-dpng', '-r500');
%% 3.8    :   PseudoVoigtModel_pGL
help PseudoVoigtModel_pGL;
% 1 - Defining the input parameters
center          = 0;            % scalar of the peak position along the x-axis of the Lorentzian.
amplitude       = 1.0;          % scalar of the peak beneath the Lorentzian.
width           = 3.00;         % scalar of the full-width at half-maximum (FWHM) of the Lorentzian.
mixratio        = 0:0.2:1;    % scalar of the mixing ratio; 0 for pure Gaussian, 1 is for pure Lorentzian.
% 2 - Calculating the lineshape
lgnd = {};
for i = 1:length(mixratio)
    int_pGL{i}    = PseudoVoigtModel_pGL(xdat, center, amplitude, width, mixratio(i));
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
legend(lgnd, 'location', 'best', 'fontsize', 7); title('PseudoVoigtModel_pGL()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
ydat = int_pGL{i}; axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "PseudoVoigtModel_pGL()",'-dpng', '-r500');
%% 3.9    :   PseudoVoigtModel_sGLA
help PseudoVoigtModel_sGLA;
% 1 - Defining the input parameters
center          = 0;            % scalar of the peak position along the x-axis of the Lorentzian.
amplitude       = 1.00;          % scalar of the peak beneath the Lorentzian.
width           = 3.00;         % scalar of the full-width at half-maximum (FWHM) of the Lorentzian.
mixratio        = 0.5;          % scalar of the mixing ratio; 0 for pure Gaussian, 1 is for pure Lorentzian.
asymmetry       = [0, 0.1, 0.2, 0.4, 0.8, 1.0];            % scalar of the asymmetry ratio; 0 for none, 1 is for maximum.
% 2 - Calculating the lineshape
lgnd = {};
for i = 1:length(asymmetry)
    int_sGLA{i}    = PseudoVoigtModel_sGLA(xdat, center, amplitude, width, mixratio, asymmetry(i));
    lgnd{i}        = "asymmetry = " + string(asymmetry(i));
end
% 3 - Plotting the lineshapes & verifying the FWHM values
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
cols = parula(length(asymmetry) + 1);
for i = 1:length(asymmetry)
    plot(xdat, int_sGLA{i}, 'k-', 'color', cols(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('PseudoVoigtModel_sGLA()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
ydat = int_sGLA{i}; axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "PseudoVoigtModel_sGLA()",'-dpng', '-r500');
%% 3.10    :   PseudoVoigtModel_pGLA
help PseudoVoigtModel_pGLA;
% 1 - Defining the input parameters
center          = 0;            % scalar of the peak position along the x-axis of the Lorentzian.
amplitude       = 1.00;          % scalar of the peak beneath the Lorentzian.
width           = 3.00;         % scalar of the full-width at half-maximum (FWHM) of the Lorentzian.
mixratio        = 0.5;          % scalar of the mixing ratio; 0 for pure Gaussian, 1 is for pure Lorentzian.
asymmetry       = [0, 0.1, 0.2, 0.4, 0.8, 1.0];            % scalar of the asymmetry ratio; 0 for none, 1 is for maximum.
% 2 - Calculating the lineshape
lgnd = {};
for i = 1:length(asymmetry)
    int_pGLA{i}    = PseudoVoigtModel_pGLA(xdat, center, amplitude, width, mixratio, asymmetry(i));
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
legend(lgnd, 'location', 'best', 'fontsize', 7); title('PseudoVoigtModel_pGLA()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
ydat = int_pGLA{i}; axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "PseudoVoigtModel_pGLA()",'-dpng', '-r500');
%% 3.11    :   PseudoVoigtModel_sGLA_FDD
help PseudoVoigtModel_sGLA_FDD;
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
    int_sGLA_FDD{i}     = PseudoVoigtModel_sGLA_FDD(xdat, center, amplitude, width, mr, asymmetry, fdd_ef, fdd_T, fdd_fwhm(i));
    lgnd{i}             = "fdd-FWHM = " + string(fdd_fwhm(i));
end
% 3 - Plotting the lineshapes & verifying the FWHM values
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
cols = parula(length(fdd_fwhm) + 1);
for i = 1:length(fdd_fwhm)
    plot(xdat, int_sGLA_FDD{i}, 'k-', 'color', cols(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('PseudoVoigtModel_sGLA_FDD()', 'interpreter', 'none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
ydat = int_sGLA_FDD{i}; axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "PseudoVoigtModel_sGLA_FDD()",'-dpng', '-r500');
%% 3.12    :   PseudoVoigtModel_pGLA_FDD
help PseudoVoigtModel_pGLA_FDD;
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
    int_pGLA_FDD{i}     = PseudoVoigtModel_pGLA_FDD(xdat, center, amplitude, width, mr, asymmetry, fdd_ef, fdd_T, fdd_fwhm(i));
    lgnd{i}             = "fdd-FWHM = " + string(fdd_fwhm(i));
end
% 3 - Plotting the lineshapes & verifying the FWHM values
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
cols = parula(length(fdd_fwhm) + 1);
for i = 1:length(fdd_fwhm)
    plot(xdat, int_pGLA_FDD{i}, 'k-', 'color', cols(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('PseudoVoigtModel_pGLA_FDD()', 'interpreter', 'none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
ydat = int_pGLA_FDD{i}; axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "PseudoVoigtModel_pGLA_FDD()",'-dpng', '-r500');

%% 4    :   Periodic Models
close all;
%% 4.1    :   SineModel
help SineModel;
% 1 - Defining the input parameters
amplitude   = 1;
frequency       = 1./[pi, pi/2, pi/4];
phaseshift       = 0;
% 2 - Calculating model
lgnd = {}; ydat = {};
for i = 1:length(frequency)
    ydat{i}    = SineModel(xdat, amplitude, frequency(i), phaseshift);
    lgnd{i}       = "frequency = " + string(frequency(i));
end
% 3 - Plotting model
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
cols = parula(length(frequency) + 1);
for i = 1:length(frequency)
    plot(xdat, ydat{i}, 'k-', 'color', cols(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('SineModel()', 'interpreter', 'none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
print(path_save  + "SineModel()",'-dpng', '-r500');

%% 5    :   Step-Like Models
close all;
%% 5.1    :   StepModel_LHS
help StepModel_LHS;
center      = 0; 
amplitude   = 1:1:5;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_gauss = parula(length(amplitude) + 1);
lgnd = {};
for i = 1:length(amplitude)
    ydat = StepModel_LHS(xdat, center, amplitude(i));
    lgnd{i}       = "amplitude = " + string(amplitude(i));
    plot(xdat, ydat, 'k-', 'color', col_gauss(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('StepModel_LHS()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "StepModel_LHS()",'-dpng', '-r500');
%% 5.2    :   StepModel_RHS
help StepModel_RHS;
center      = 0; 
amplitude   = 1:1:5;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_gauss = parula(length(amplitude) + 1);
lgnd = {};
for i = 1:length(amplitude)
    ydat = StepModel_RHS(xdat, center, amplitude(i));
    lgnd{i}       = "amplitude = " + string(amplitude(i));
    plot(xdat, ydat, 'k-', 'color', col_gauss(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('StepModel_RHS()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "StepModel_RHS()",'-dpng', '-r500');
%% 5.3    :   StepModel_Gauss_LHS
help StepModel_Gauss_LHS;
center      = 0; 
amplitude   = 1;
width       = 0:0.2:1;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_gauss = parula(length(width) + 1);
lgnd = {};
for i = 1:length(width)
    ydat = StepModel_Gauss_LHS(xdat, center, amplitude, width(i));
    lgnd{i}       = "FWHM = " + string(width(i));
    plot(xdat, ydat, 'k-', 'color', col_gauss(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('StepModel_Gauss_LHS()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "StepModel_Gauss_LHS()",'-dpng', '-r500');
%% 5.4    :   StepModel_Gauss_RHS
help StepModel_Gauss_RHS;
center      = 0; 
amplitude   = 1;
width       = 0:0.2:1;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_gauss = parula(length(width) + 1);
lgnd = {};
for i = 1:length(width)
    ydat = StepModel_Gauss_RHS(xdat, center, amplitude, width(i));
    lgnd{i}       = "FWHM = " + string(width(i));
    plot(xdat, ydat, 'k-', 'color', col_gauss(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('StepModel_Gauss_RHS()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "StepModel_Gauss_RHS()",'-dpng', '-r500');
%% 5.5    :   StepModel_Gauss_LHS_trunc
help StepModel_Gauss_LHS_trunc;
center      = 0; 
amplitude   = 1;
width       = 0:0.2:1;
cutoff      = 0.5;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_Gauss = parula(length(width) + 1);
lgnd = {};
for i = 1:length(width)
    ydat = StepModel_Gauss_LHS_trunc(xdat, center, amplitude, width(i), cutoff);
    lgnd{i}       = "FWHM = " + string(width(i));
    plot(xdat, ydat, 'k-', 'color', col_Gauss(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('StepModel_Gauss_LHS_trunc()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "StepModel_Gauss_LHS_trunc()",'-dpng', '-r500');
%% 5.6    :   StepModel_Gauss_RHS_trunc
help StepModel_Gauss_RHS_trunc;
center      = 0; 
amplitude   = 1;
width       = 0:0.2:1;
cutoff      = 0.5;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_Gauss = parula(length(width) + 1);
lgnd = {};
for i = 1:length(width)
    ydat = StepModel_Gauss_RHS_trunc(xdat, center, amplitude, width(i), cutoff);
    lgnd{i}       = "FWHM = " + string(width(i));
    plot(xdat, ydat, 'k-', 'color', col_Gauss(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('StepModel_Gauss_RHS_trunc()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "StepModel_Gauss_RHS_trunc()",'-dpng', '-r500');
%% 5.7    :   StepModel_Exp_LHS
help StepModel_Exp_LHS;
center      = 0; 
amplitude   = 1;
cdl         = 0:0.2:1;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_Exp = parula(length(cdl) + 1);
lgnd = {};
for i = 1:length(cdl)
    ydat = StepModel_Exp_LHS(xdat, center, amplitude, cdl(i));
    lgnd{i}       = "CDL = " + string(cdl(i));
    plot(xdat, ydat, 'k-', 'color', col_Exp(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('StepModel_Exp_LHS()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "StepModel_Exp_LHS()",'-dpng', '-r500');
%% 5.8    :   StepModel_Exp_RHS
help StepModel_Exp_RHS;
center      = 0; 
amplitude   = 1;
cdl         = 0:0.2:1;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_Exp = parula(length(cdl) + 1);
lgnd = {};
for i = 1:length(cdl)
    ydat = StepModel_Exp_RHS(xdat, center, amplitude, cdl(i));
    lgnd{i}       = "CDL = " + string(cdl(i));
    plot(xdat, ydat, 'k-', 'color', col_Exp(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('StepModel_Exp_RHS()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "StepModel_Exp_RHS()",'-dpng', '-r500');
%% 5.9    :   StepModel_Exp_LHS_trunc
help StepModel_Exp_LHS_trunc;
center      = 0; 
amplitude   = 1;
cdl         = 0:0.2:1;
cutoff      = 0.5;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_Exp = parula(length(cdl) + 1);
lgnd = {};
for i = 1:length(cdl)
    ydat = StepModel_Exp_LHS_trunc(xdat, center, amplitude, cdl(i), cutoff);
    lgnd{i}       = "CDL = " + string(cdl(i));
    plot(xdat, ydat, 'k-', 'color', col_Exp(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('StepModel_Exp_LHS_trunc()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "StepModel_Exp_LHS_trunc()",'-dpng', '-r500');
%% 5.10    :   StepModel_Exp_RHS_trunc
help StepModel_Exp_RHS_trunc;
center      = 0; 
amplitude   = 1;
cdl         = 0:0.2:1;
cutoff      = 0.5;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_Exp = parula(length(cdl) + 1);
lgnd = {};
for i = 1:length(cdl)
    ydat = StepModel_Exp_RHS_trunc(xdat, center, amplitude, cdl(i), cutoff);
    lgnd{i}       = "CDL = " + string(cdl(i));
    plot(xdat, ydat, 'k-', 'color', col_Exp(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('StepModel_Exp_RHS_trunc()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "StepModel_Exp_RHS_trunc()",'-dpng', '-r500');
%% 5.11    :   StepModel_Erf_LHS
help StepModel_Erf_LHS;
center      = 0; 
amplitude   = 1;
fwhm        = 0:0.1:0.5;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_Exp = parula(length(fwhm) + 1);
lgnd = {};
for i = 1:length(fwhm)
    ydat = StepModel_Erf_LHS(xdat, center, amplitude, fwhm(i));
    lgnd{i}       = "FWHM = " + string(fwhm(i));
    plot(xdat, ydat, 'k-', 'color', col_Exp(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('StepModel_Erf_LHS()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), min(ydat(:)), 1.1*max(ydat(:))]);
print(path_save  + "StepModel_Erf_LHS()",'-dpng', '-r500');
%% 5.12    :   StepModel_Erf_RHS
help StepModel_Erf_RHS;
center      = 0; 
amplitude   = 1;
fwhm        = 0:0.1:0.5;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_Exp = parula(length(fwhm) + 1);
lgnd = {};
for i = 1:length(fwhm)
    ydat = StepModel_Erf_RHS(xdat, center, amplitude, fwhm(i));
    lgnd{i}       = "FWHM = " + string(fwhm(i));
    plot(xdat, ydat, 'k-', 'color', col_Exp(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('StepModel_Erf_RHS()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), min(ydat(:)), 1.1*max(ydat(:))]);
print(path_save  + "StepModel_Erf_RHS()",'-dpng', '-r500');

%% 6    :   FERMI-DIRAC DISTRIBUTION LINESHAPE
close all;
%% 6.1    :   Pure FDD function
help ThermalModel_FDD;
% 1 - Defining the input parameters
FDEF        = 0;                  % scalar of the location of the Fermi-level
FDT         = [10,20,40,80,160,200,250,300,500]; % scalar of the temperature of the system
% 2 - Calculating the lineshape
lgnd = {}; ydat = {};
for i = 1:length(FDT)
    ydat{i}    = ThermalModel_FDD(xdat, FDEF, FDT(i));
    lgnd{i}       = "FDD-T = " + string(FDT(i));
end
% 3 - Plotting the lineshapes & verifying the FWHM values
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
cols = parula(length(FDT) + 1);
for i = 1:length(FDT)
    plot(xdat, ydat{i}, 'k-', 'color', cols(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('ThermalModel_FDD()', 'interpreter', 'none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
ydat = ydat{i}; axis([min(xdat(:)), max(xdat(:)), min(ydat(:)), 1.1*max(ydat(:))]);
print(path_save  + "ThermalModel_FDD()",'-dpng', '-r500');
%% 6.2    :   Gaussian broadened FDD function
help ThermalModel_FDDG;
% 1 - Defining the input parameters
FDEF        = 0;            % scalar of the location of the Fermi-level
FDT         = 12;           % scalar of the temperature of the system
FDW         = [0.02, 0.04, 0.08, 0.16, 0.32, 0.64, 1.0, 2.0];         % scalar of the Gaussian FWHM to be convolved
% 2 - Calculating the lineshape
lgnd = {}; int_FDDG = {};
for i = 1:length(FDW)
    int_FDDG{i}    = ThermalModel_FDDG(xdat, FDEF, FDT, FDW(i));
    lgnd{i}       = "FDDG-fwhm = " + string(FDW(i));
end
% 3 - Plotting the lineshapes & verifying the FWHM values
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
cols = parula(length(FDW) + 1);
for i = 1:length(FDW)
    plot(xdat, int_FDDG{i}, 'k-', 'color', cols(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('ThermalModel_FDDG()', 'interpreter', 'none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
ydat = int_FDDG{i}; axis([min(xdat(:)), max(xdat(:)), min(ydat(:)), 1.1*max(ydat(:))]);
print(path_save  + "ThermalModel_FDDG()",'-dpng', '-r500');
%% 6.3    :   Gaussian broadened FDD function with a multiplied linear background
help ThermalModel_FDDGpL;
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
    int_FDDGpL{i}    = ThermalModel_FDDGpL(xdat, FDEF, FDT, FDW, BGR(i), BIN, BCO);
    lgnd{i}       = "FDDGpL-slope = " + string(BGR(i));
end
% 3 - Plotting the lineshapes & verifying the FWHM values
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
cols = parula(length(BGR) + 1);
for i = 1:length(BGR)
    plot(xdat, int_FDDGpL{i}, 'k-', 'color', cols(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('ThermalModel_FDDGpL()', 'interpreter', 'none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
ydat = int_FDDGpL{i}; axis([min(xdat(:)), max(xdat(:)), min(ydat(:)), 1.1*max(ydat(:))]);
print(path_save  + "ThermalModel_FDDGpL()",'-dpng', '-r500');
%% 6.4    :   Gaussian broadened FDD function with a summed linear background
help ThermalModel_FDDGsL;
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
    int_FDDGsL{i}    = ThermalModel_FDDGsL(xdat, FDEF, FDT, FDW, BGR(i), BIN, BCO);
    lgnd{i}       = "FDDGsL-slope = " + string(BGR(i));
end
% 3 - Plotting the lineshapes & verifying the FWHM values
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
cols = parula(length(BGR) + 1);
for i = 1:length(BGR)
    plot(xdat, int_FDDGsL{i}, 'k-', 'color', cols(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('ThermalModel_FDDGsL()', 'interpreter', 'none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
ydat = int_FDDGsL{i}; axis([min(xdat(:)), max(xdat(:)), min(ydat(:)), 1.1*max(ydat(:))]);
print(path_save  + "ThermalModel_FDDGsL()",'-dpng', '-r500');

%% 7    :   TopHat-Like Models
close all;
%% 7.1    :   TopHatModel
help TopHatModel;
center      = 0; 
amplitude   = 1;
width       = 1:1:5;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_gauss = parula(length(width) + 1);
lgnd = {};
for i = 1:length(width)
    ydat = TopHatModel(xdat, center, amplitude, width(i));
    lgnd{i}       = "width = " + string(width(i));
    plot(xdat, ydat, 'k-', 'color', col_gauss(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('TopHatModel()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "TopHatModel()",'-dpng', '-r500');
%% 7.2    :   TopHatModel_Erf
help TopHatModel_Erf;
center      = 0; 
amplitude   = 1;
width       = 3;
fwhm        = 0:0.2:1;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_gauss = parula(length(fwhm) + 1);
lgnd = {};
for i = 1:length(fwhm)
    ydat = TopHatModel_Erf(xdat, center, amplitude, width, fwhm(i));
    lgnd{i}       = "FWHM = " + string(fwhm(i));
    plot(xdat, ydat, 'k-', 'color', col_gauss(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('TopHatModel_Erf()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "TopHatModel_Erf()",'-dpng', '-r500');
%% 7.3    :   TopHatModel_Erf_LHS
help TopHatModel_Erf_LHS;
center      = 0; 
amplitude   = 1;
width       = 3;
fwhm        = 0:0.2:1;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_gauss = parula(length(fwhm) + 1);
lgnd = {};
for i = 1:length(fwhm)
    ydat = TopHatModel_Erf_LHS(xdat, center, amplitude, width, fwhm(i));
    lgnd{i}       = "FWHM = " + string(fwhm(i));
    plot(xdat, ydat, 'k-', 'color', col_gauss(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('TopHatModel_Erf_LHS()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "TopHatModel_Erf_LHS()",'-dpng', '-r500');
%% 7.4    :   TopHatModel_Erf_RHS
help TopHatModel_Erf_RHS;
center      = 0; 
amplitude   = 1;
width       = 3;
fwhm        = 0:0.2:1;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_gauss = parula(length(fwhm) + 1);
lgnd = {};
for i = 1:length(fwhm)
    ydat = TopHatModel_Erf_RHS(xdat, center, amplitude, width, fwhm(i));
    lgnd{i}       = "FWHM = " + string(fwhm(i));
    plot(xdat, ydat, 'k-', 'color', col_gauss(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('TopHatModel_Erf_RHS()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "TopHatModel_Erf_RHS()",'-dpng', '-r500');

%% 7.5    :   TopHatModel_Exp
help TopHatModel_Exp;
center      = 0; 
amplitude   = 1;
width       = 3;
cdl         = 0:0.2:1;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_gauss = parula(length(cdl) + 1);
lgnd = {};
for i = 1:length(cdl)
    ydat = TopHatModel_Exp(xdat, center, amplitude, width, cdl(i));
    lgnd{i}       = "CDL = " + string(cdl(i));
    plot(xdat, ydat, 'k-', 'color', col_gauss(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('TopHatModel_Exp()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "TopHatModel_Exp()",'-dpng', '-r500');
%% 7.6    :   TopHatModel_Exp_LHS
help TopHatModel_Exp_LHS;
center      = 0; 
amplitude   = 1;
width       = 3;
cdl         = 0:0.2:1;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_gauss = parula(length(cdl) + 1);
lgnd = {};
for i = 1:length(cdl)
    ydat = TopHatModel_Exp_LHS(xdat, center, amplitude, width, cdl(i));
    lgnd{i}       = "CDL = " + string(cdl(i));
    plot(xdat, ydat, 'k-', 'color', col_gauss(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('TopHatModel_Exp_LHS()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "TopHatModel_Exp_LHS()",'-dpng', '-r500');
%% 7.7    :   TopHatModel_Exp_RHS
help TopHatModel_Exp_RHS;
center      = 0; 
amplitude   = 1;
width       = 3;
cdl         = 0:0.2:1;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_gauss = parula(length(cdl) + 1);
lgnd = {};
for i = 1:length(cdl)
    ydat = TopHatModel_Exp_RHS(xdat, center, amplitude, width, cdl(i));
    lgnd{i}       = "CDL = " + string(cdl(i));
    plot(xdat, ydat, 'k-', 'color', col_gauss(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('TopHatModel_Exp_RHS()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "TopHatModel_Exp_RHS()",'-dpng', '-r500');
%% 7.8    :   TopHatModel_Exp_LHS_trunc
help TopHatModel_Exp_LHS_trunc;
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
    ydat = TopHatModel_Exp_LHS_trunc(xdat, center, amplitude, width, cdl(i), cutoff);
    lgnd{i}       = "CDL = " + string(cdl(i));
    plot(xdat, ydat, 'k-', 'color', col_gauss(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('TopHatModel_Exp_LHS_trunc()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), min(ydat(:)), 1.1*max(ydat(:))]);
print(path_save  + "TopHatModel_Exp_LHS_trunc()",'-dpng', '-r500');
%% 7.9    :   TopHatModel_Exp_RHS_trunc
help TopHatModel_Exp_RHS_trunc;
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
    ydat = TopHatModel_Exp_RHS_trunc(xdat, center, amplitude, width, cdl(i), cutoff);
    lgnd{i}       = "CDL = " + string(cdl(i));
    plot(xdat, ydat, 'k-', 'color', col_gauss(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('TopHatModel_Exp_RHS_trunc()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), min(ydat(:)), 1.1*max(ydat(:))]);
print(path_save  + "TopHatModel_Exp_RHS_trunc()",'-dpng', '-r500');
%% 7.10    :   TopHatModel_Gauss
help TopHatModel_Gauss;
center      = 0; 
amplitude   = 1;
width       = 3;
fwhm        = 0:0.5:2;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_gauss = parula(length(fwhm) + 1);
lgnd = {};
for i = 1:length(fwhm)
    ydat = TopHatModel_Gauss(xdat, center, amplitude, width, fwhm(i));
    lgnd{i}       = "FWHM = " + string(fwhm(i));
    plot(xdat, ydat, 'k-', 'color', col_gauss(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('TopHatModel_Gauss()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "TopHatModel_Gauss()",'-dpng', '-r500');
%% 7.11    :   TopHatModel_Gauss_LHS
help TopHatModel_Gauss_LHS;
center      = 0; 
amplitude   = 1;
width       = 3;
fwhm        = 0:0.5:2;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_gauss = parula(length(fwhm) + 1);
lgnd = {};
for i = 1:length(fwhm)
    ydat = TopHatModel_Gauss_LHS(xdat, center, amplitude, width, fwhm(i));
    lgnd{i}       = "FWHM = " + string(fwhm(i));
    plot(xdat, ydat, 'k-', 'color', col_gauss(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('TopHatModel_Gauss_LHS()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "TopHatModel_Gauss_LHS()",'-dpng', '-r500');
%% 7.12    :   TopHatModel_Gauss_RHS
help TopHatModel_Gauss_RHS;
center      = 0; 
amplitude   = 1;
width       = 3;
fwhm        = 0:0.5:2;
% -- Plotting the figure
fig = figure(); fig.Position(3) = 450; fig.Position(4) = 450; hold on; 
col_gauss = parula(length(fwhm) + 1);
lgnd = {};
for i = 1:length(fwhm)
    ydat = TopHatModel_Gauss_RHS(xdat, center, amplitude, width, fwhm(i));
    lgnd{i}       = "FWHM = " + string(fwhm(i));
    plot(xdat, ydat, 'k-', 'color', col_gauss(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('TopHatModel_Gauss_RHS()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), 0, 1.1*max(ydat(:))]);
print(path_save  + "TopHatModel_Gauss_RHS()",'-dpng', '-r500');
%% 7.13    :   TopHatModel_Gauss_LHS_trunc
help TopHatModel_Gauss_LHS_trunc;
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
    ydat = TopHatModel_Gauss_LHS_trunc(xdat, center, amplitude, width, fwhm(i), cutoff);
    lgnd{i}       = "FWHM = " + string(fwhm(i));
    plot(xdat, ydat, 'k-', 'color', col_gauss(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('TopHatModel_Gauss_LHS_trunc()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), min(ydat(:)), 1.1*max(ydat(:))]);
print(path_save  + "TopHatModel_Gauss_LHS_trunc()",'-dpng', '-r500');
%% 7.14    :   TopHatModel_Gauss_RHS_trunc
help TopHatModel_Gauss_RHS_trunc;
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
    ydat = TopHatModel_Gauss_RHS_trunc(xdat, center, amplitude, width, fwhm(i), cutoff);
    lgnd{i}       = "FWHM = " + string(fwhm(i));
    plot(xdat, ydat, 'k-', 'color', col_gauss(i,:), 'linewidth', 2);
end
legend(lgnd, 'location', 'best', 'fontsize', 7); title('TopHatModel_Gauss_RHS_trunc()', 'interpreter','none');
xlabel(' X ', 'fontweight', 'bold');
ylabel(' Y ', 'fontweight', 'bold');
axis([min(xdat(:)), max(xdat(:)), min(ydat(:)), 1.1*max(ydat(:))]);
print(path_save  + "TopHatModel_Gauss_RHS_trunc()",'-dpng', '-r500');
