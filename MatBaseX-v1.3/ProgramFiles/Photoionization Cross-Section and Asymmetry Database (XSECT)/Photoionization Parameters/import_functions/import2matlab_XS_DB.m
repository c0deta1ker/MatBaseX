close all; clear all;
%% 1 :  Importing all Photoionization Cross-Section (XS) databases
run import2matlab_XS_DB_1973Scof.m; close all; clear all;
run import2matlab_XS_DB_1985YehLind.m; close all; clear all;
run import2matlab_XS_DB_2018Trzha.m; close all; clear all;
run import2matlab_XS_DB_2022Cant.m; close all; clear all;
%% 2 :  Comparing Photoionization Cross-Sections (XS) of known data
% -- Initializing save path
path_matbase    = what('Photoionization Parameters'); path_matbase = string(path_matbase.path);
path_figs       = path_matbase + "\0_figs\";
% -- Defining the reference data
close all;
labels = {'C1s','Si1s','Si2p3','Ag3d5','Au4s1','Au4f7'};
hv = 1250:50:11000;
%% 2.1 :  SIGMA, CROSS-SECTIONS
xsect_C1s   = calc_xsect_sigma(hv, 'C', '1s1');
xsect_Si1s  = calc_xsect_sigma(hv, 'Si','1s1');
xsect_Si2p3 = calc_xsect_sigma(hv, 'Si','2p3');
xsect_Ag3d5 = calc_xsect_sigma(hv, 'Ag','3d5');
xsect_Au4s1 = calc_xsect_sigma(hv, 'Au','4s1');
xsect_Au4f7 = calc_xsect_sigma(hv, 'Au','4f7');
% -- Plotting a comparison of all photon energies
barn2cm2 = 1e-24;
figure(); hold on;
plot(hv, xsect_C1s.*barn2cm2, 'g-', 'linewidth', 1.5);
plot(hv, xsect_Si1s.*barn2cm2, 'r-', 'linewidth', 1.5);
plot(hv, xsect_Si2p3.*barn2cm2, 'b-', 'linewidth', 1.5);
plot(hv, xsect_Ag3d5.*barn2cm2, 'm-','linewidth', 1.5);
plot(hv, xsect_Au4s1.*barn2cm2, 'y-','linewidth', 1.5, 'color', [0.9290 0.6940 0.1250]);
plot(hv, xsect_Au4f7.*barn2cm2, 'k-','linewidth', 1.5);
legend(labels, 'Location','best');
xlabel('$$ \bf Photon\ Energy\ [eV] $$', 'interpreter', 'latex');
ylabel('$$ \bf Cross\ Section\ [cm^2] $$', 'interpreter', 'latex');
ax = gca; ax.YScale = 'log'; ax.XScale = 'log';
axis([1000, 11000, 1e-24, 1e-18]); box on; grid on;
title('Change of \sigma of selected peaks with photon energy');
print(path_figs + "fig_Ref_XSECT_Sigma",'-dpng', '-r300');
%% 2.2 :  BETA, ASYMMETRY PARAMETER
beta_C1s   = calc_xsect_beta(hv, 'C','1s1');
beta_Si1s  = calc_xsect_beta(hv, 'Si','1s1');
beta_Si2p3 = calc_xsect_beta(hv, 'Si','2p3');
beta_Ag3d5 = calc_xsect_beta(hv, 'Ag','3d5');
beta_Au4s1 = calc_xsect_beta(hv, 'Au','4s1');
beta_Au4f7 = calc_xsect_beta(hv, 'Au','4f7');
% -- Plotting a comparison of all photon energies
figure(); hold on;
plot(hv, beta_C1s, 'g-', 'linewidth', 1.5);
plot(hv, beta_Si1s, 'r-', 'linewidth', 1.5);
plot(hv, beta_Si2p3, 'b-', 'linewidth', 1.5);
plot(hv, beta_Ag3d5, 'm-', 'linewidth', 1.5);
plot(hv, beta_Au4s1, 'y-', 'linewidth', 1.5, 'color', [0.9290 0.6940 0.1250]);
plot(hv, beta_Au4f7, 'k-', 'linewidth', 1.5);
box on; legend(labels, 'Location','best');
xlabel('$$ \bf Photon\ Energy\ [eV] $$', 'interpreter', 'latex');
ylabel('$$ \bf \beta $$', 'interpreter', 'latex');
axis([0, 11000, 0, 2.5]); box on; grid on;
title('Change of \beta of selected peaks with photon energy');
print(path_figs + "fig_Ref_XSECT_Beta",'-dpng', '-r300');
%% 2.3 :  GAMMA, ASYMMETRY PARAMETER
gamma_C1s   = calc_xsect_gamma(hv, 'C','1s1');
gamma_Si1s  = calc_xsect_gamma(hv, 'Si','1s1');
gamma_Si2p3 = calc_xsect_gamma(hv, 'Si','2p3');
gamma_Ag3d5 = calc_xsect_gamma(hv, 'Ag','3d5');
gamma_Au4s1 = calc_xsect_gamma(hv, 'Au','4s1');
gamma_Au4f7 = calc_xsect_gamma(hv, 'Au','4f7');
% -- Plotting a comparison of all photon energies
figure(); hold on;
plot(hv, gamma_C1s, 'g-', 'linewidth', 1.5);
plot(hv, gamma_Si1s, 'r-', 'linewidth', 1.5);
plot(hv, gamma_Si2p3, 'b-', 'linewidth', 1.5);
plot(hv, gamma_Ag3d5, 'm-', 'linewidth', 1.5);
plot(hv, gamma_Au4s1, 'y-', 'linewidth', 1.5, 'color', [0.9290 0.6940 0.1250]);
plot(hv, gamma_Au4f7, 'k-', 'linewidth', 1.5);
box on; legend(labels, 'Location','best');
xlabel('$$ \bf Photon\ Energy\ [eV] $$', 'interpreter', 'latex');
ylabel('$$ \bf \gamma $$', 'interpreter', 'latex');
axis([0, 11000, -0.5, 2.5]); box on; grid on;
title('Change of \gamma of selected peaks with photon energy');
print(path_figs + "fig_Ref_XSECT_Gamma",'-dpng', '-r300');
%% 2.4 :  DELTA, ASYMMETRY PARAMETER
delta_C1s   = calc_xsect_delta(hv, 'C','1s1');
delta_Si1s  = calc_xsect_delta(hv, 'Si','1s1');
delta_Si2p3 = calc_xsect_delta(hv, 'Si','2p3');
delta_Ag3d5 = calc_xsect_delta(hv, 'Ag','3d5');
delta_Au4s1 = calc_xsect_delta(hv, 'Au','4s1');
delta_Au4f7 = calc_xsect_delta(hv, 'Au','4f7');
% -- Plotting a comparison of all photon energies
figure(); hold on;
plot(hv, delta_C1s, 'g-', 'linewidth', 1.5);
plot(hv, delta_Si1s, 'r-', 'linewidth', 1.5);
plot(hv, delta_Si2p3, 'b-', 'linewidth', 1.5);
plot(hv, delta_Ag3d5, 'm-', 'linewidth', 1.5);
plot(hv, delta_Au4s1, 'y-', 'linewidth', 1.5, 'color', [0.9290 0.6940 0.1250]);
plot(hv, delta_Au4f7, 'k-', 'linewidth', 1.5);
box on; legend(labels, 'Location','best');
xlabel('$$ \bf Photon\ Energy\ [eV] $$', 'interpreter', 'latex');
ylabel('$$ \bf \delta $$', 'interpreter', 'latex');
axis([1000, 10000, 0, 0.45]); box on; grid on;
title('Change of \delta of selected peaks with photon energy');
print(path_figs + "fig_Ref_XSECT_Delta",'-dpng', '-r300');
%% 3 :  Comparing Photoionization Cross-Sections (XS) of all formalisms
% -- Defining the elements
ATOM_SYMB = read_mpd_elements();
ATOM_SYMB = ATOM_SYMB(1:98);
% -- Defining the Z number for each one of these elements
ATOM_ZNUM = 1:length(ATOM_SYMB);
XS_DB_Trzh2018	= load('XS_DB_Trzh2018.mat'); XS_DB_Trzh2018 = XS_DB_Trzh2018.XS_DB_Trzh2018;
% -- Filing through all elements and core-levels
for i = 1:length(ATOM_SYMB)
    DataTable = XS_DB_Trzh2018.XSECT_SIGMA{i};
    CoreLevels = DataTable.Properties.VariableNames;
    for j = 1:length(CoreLevels)
        close all;
        figX = view_xsect(ATOM_SYMB{i}, CoreLevels{j});
        save_fullname = path_figs + sprintf("Z%i_%i_%s%s_XSECT", ATOM_ZNUM(i), j, ATOM_SYMB{i}, CoreLevels{j});
        print(save_fullname,'-dpng', '-r300');
        saveas(figX, save_fullname, 'fig');
    end
end

