function [fig, imfpData] = view_imfp(material)
% [fig, imfpData] = view_imfp(material)
%   This is a function that plots the electron IMFP curves of a particular material
%   defined by the user using all available calculators. This can be used to
%   quickly view all the available IMFP data for a particular element /
%   material.
%
%   IN:
%   -   material:  	string of element / material whose parameters are found in materials database; e.g. "Si", "SiO2", "Al2O3"...
%
%   OUT: 
%   -   fig:        figure output
%   -   imfpData:   data structure containing all the IMFP data

%% Default parameters (Parameters for Silicon)
if nargin < 1; material = "Si";  end
if isempty(material); material = "Si"; end
%% Validity checks on the input parameters
material    = string(material);
%% 1 - Extracting the material parameters
material_props = get_mpd_props(material);
Z = material_props.atom_z;
%% 2 - Extracting the eIMFP properties from each calculator
imfpData                    = table();
% -- Defining the kinetic energy range
imfpData.Ek                 = logspace(log10(50),log10(200000),200)';
imfpData.Ek_Uni             = logspace(log10(1),log10(200000),200)';
% -- Unversal curve from Seah (1979)
imfpData.universal          = calc_imfp_universal(imfpData.Ek_Uni);
% -- TPP2M predictive equations from Tanuma (1994)
imfpData.tpp2m              = mpd_calc_imfp_tpp2m(imfpData.Ek, material);
imfpData.tpp2m_avg          = calc_imfp_tpp2m_avg(imfpData.Ek);
% -- Optical data from NIST (1999)
[imfpData.opt, imfpData.dopt] = calc_imfp_optical(imfpData.Ek, material);
% -- S1 & S2 predictive equations from Seah (2011)
imfpData.S1                 = mpd_calc_imfp_S1(imfpData.Ek, material);
imfpData.S2                 = mpd_calc_imfp_S2(imfpData.Ek, material);
% -- S3 & S4 predictive equations from Seah (2012)
imfpData.S3                 = mpd_calc_eal_S3(imfpData.Ek, material);
imfpData.S3O                = calc_eal_S3_organic(imfpData.Ek);
imfpData.S4                 = mpd_calc_eal_S4(imfpData.Ek, material);
% -- JTP (2023)
imfpData.jtp                = mpd_calc_imfp_jtp(imfpData.Ek, material);
%% 3 - Plotting a summary of the final IMFP figure
% -- Defining the plot properties
colors = [
    0, 0, 0;                    % Black
    0.8, 0.1, 0.1;              % Dark Red
    0.75, 0.1, 0.1;             % Similar to Dark Red
    0, 0.5, 0;                  % Green
    0.2, 0.2, 0.8;              % Dark Blue
    0.22, 0.2, 0.75;            % Similar to Dark Blue
    0.10, 0.20, 0.50;           % Purple
    0.10, 0.20, 0.50;           % Deep Purple
    0.3010, 0.7450, 0.9330;     % Light Blue
    0.9, 0.6, 0.1               % Orange
];
linewidth = 2;
% - Creating a figure
fig = figure(); 
fig.Position(1) = 100; fig.Position(2) = 100;
fig.Position(3) = 1000; 
fig.Position(4) = 550;
% - Creating a tiled axis
t = tiledlayout(1,1);
t.TileSpacing = 'compact';
t.Padding = 'compact';
% - Plot all IMFP data
nexttile(); hold on; grid on; grid minor;
% - PLOTTING UNIVERSAL CURVE
loglog(imfpData.Ek_Uni, imfpData.universal,...
    '-', 'color', colors(1,:), 'LineWidth', linewidth);
% - PLOTTING TPP2M-CURVE
loglog(imfpData.Ek, imfpData.tpp2m,...
    '-', 'color', 'b', 'LineWidth', linewidth, 'color', colors(2,:));
% - PLOTTING TPP2M-AVERAGE-CURVE
loglog(imfpData.Ek, imfpData.tpp2m_avg,...
    ':', 'color', 'b', 'LineWidth', linewidth, 'color', colors(3,:));
% - PLOTTING OPTICAL/EXPERIMENTAL DATA
errorbar(imfpData.Ek, imfpData.opt, imfpData.dopt, imfpData.dopt,...
    'r.-', 'LineWidth', 0.75*linewidth, 'color', colors(4,:), 'CapSize', 8);
% - PLOTTING S1- & S2-CURVE
loglog(imfpData.Ek, imfpData.S1,...
    '-', 'LineWidth', linewidth, 'color', colors(5,:));
loglog(imfpData.Ek, imfpData.S2,...
    ':', 'LineWidth', linewidth, 'color', colors(6,:));
% - PLOTTING S3- & S4-CURVE
loglog(imfpData.Ek, imfpData.S3,...
    '-', 'LineWidth', linewidth, 'color', colors(7,:));
loglog(imfpData.Ek, imfpData.S3O,...
    '--', 'LineWidth', linewidth, 'color', colors(8,:));
loglog(imfpData.Ek, imfpData.S4,...
    ':', 'LineWidth', linewidth, 'color', colors(9,:));
% - PLOTTING JTP CURVE
loglog(imfpData.Ek, imfpData.jtp,...
    '-', 'LineWidth', linewidth, 'color', colors(10,:));
% - FORMATTING THE FIGURE
% -- Labelling the x- and y-axes
xlabel('Electron Kinetic Energy [eV] ', 'FontWeight','bold');
ylabel(' IMFP [Angstrom] ', 'FontWeight','bold');
text(0.02, 0.97, sprintf("%s(Z=%.1f)", material, Z),...
    'FontSize', 14, 'color', 'k', 'Units','normalized', 'FontWeight', 'bold', 'HorizontalAlignment','left');
ax = gca; ax.YScale = 'log'; ax.XScale = 'log';
axis([1, 210000, 1, 5e3]);
% -- Add a legend
list_of_formalisms = {...
    'Seah(1979)-Universal',...
    'Tanuma(1994)-TPP-2M',...
    'Tanuma(1994)-TPP-2M(Average)',...
    'NIST(1999)-OpticalExperiments',...
    'Seah(2011)-S1',...
    'Seah(2011)-S2',...
    'Seah(2012)-S3',...
    'Seah(2012)-S3(Organic)',...
    'Seah(2012)-S4',...
    'Jablonski(2023)-JTP',...
    };
h = zeros(length(list_of_formalisms), 1);
h(1)    = plot(NaN,NaN,'k-',    'LineWidth', linewidth, 'color',colors(1,:));
h(2)    = plot(NaN,NaN,'r-',    'LineWidth', linewidth, 'color',colors(2,:));
h(3)    = plot(NaN,NaN,'r:',    'LineWidth', linewidth, 'color',colors(3,:));
h(4)    = plot(NaN,NaN,'r.-',   'LineWidth', 0.75*linewidth, 'color',colors(4,:));
h(5)    = plot(NaN,NaN,'g-',    'LineWidth', linewidth, 'color',colors(5,:));
h(6)    = plot(NaN,NaN,'g:',   'LineWidth', linewidth, 'color',colors(6,:));
h(7)    = plot(NaN,NaN,'r-',    'LineWidth', linewidth, 'color',colors(7,:));
h(8)    = plot(NaN,NaN,'r--',    'LineWidth', linewidth, 'color',colors(8,:));
h(9)    = plot(NaN,NaN,'r:',   'LineWidth', linewidth, 'color',colors(9,:));
h(10)   = plot(NaN,NaN,'r-',    'LineWidth', linewidth, 'color',colors(10,:));
legend(h,list_of_formalisms,'location', 'eastoutside', 'FontSize', 8);
end