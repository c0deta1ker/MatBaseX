close all; clear all;
%% 1 :  Importing all Angular Anisotropy (AA) data
run import2matlab_AA_2008Fisher.m; close all; clear all;
run import2matlab_AA_2022Cant.m; close all; clear all;
%% 2 :  Comparing Angular Anisotropy (AA) of known data
path_matbase        = what('Photoionization Angular Anisotropy'); path_matbase = string(path_matbase.path);
path_fig_save       = path_matbase + "\0_figs\";
%% 2.1 : Soft X-Ray Regime : CONSISTENCY CHECK FOR POLARISATION FUNCTIONS
close all;
% -- Initializing variables
element     = {'C', 'Si', 'Si', 'Ag', 'Au', 'Au'};
corelevel   = {'1s1', '1s1', '2p3', '3d5', '4s1', '4f7'};
hv          = 1000;
theta       = 0:5:90;
phi         = 0;
P           = {0, 0.5, 1};
for i = 1:length(element)
    % -- Extracting polarization factors
    FU = calc_xsect_angle_aniso_FU(hv, element{i}, corelevel{i}, theta);
    FL = calc_xsect_angle_aniso_FL(hv, element{i}, corelevel{i}, theta, phi);
    for j = 1:length(P)
        FP{j} = calc_xsect_angle_aniso_FP(hv, element{i}, corelevel{i}, theta, phi, P{j});
    end
    Fadj = calc_xsect_angle_aniso_Fadj(hv, element{i}, corelevel{i}, theta, phi);
    % -- Squeezing arrays
    FU = squeeze(FU);
    FL = squeeze(FL);
    for j = 1:length(P); FP{j} = squeeze(FP{j}); end
    Fadj = squeeze(Fadj);
    % -- Plotting a comparison of all polarisation functions
    % --- Creating a figure
    fig = figure(); 
    fig.Position(1) = 100; fig.Position(2) = 100;
    fig.Position(3) = 700; 
    fig.Position(4) = 500;
    % --- Creating a tiled axis
    t = tiledlayout(1,1);
    t.TileSpacing = 'compact';
    t.Padding = 'compact';
    nexttile(); hold on; grid on; grid minor;
    % --- Plot polarisation factors
    plot(theta, Fadj, 'go-', 'color', [0.2 1 0.2], 'LineWidth', 2, 'markerfacecolor', [0.2 1 0.2]);
    plot(theta, FU, 'bo-', 'color', [0.2 0.2 1], 'LineWidth', 2, 'markerfacecolor', [0.2 0.2 1]);
    plot(fliplr(theta), FU, 'bo-', 'color', [0.7 0.7 1], 'LineWidth', 2, 'markerfacecolor', [0.7 0.7 1]);
    plot(theta, FL, 'rd-', 'color', [1 0.2 0.2], 'LineWidth', 2, 'markerfacecolor', [1 0.2 0.2]);
    plot(theta, FP{1}, 'bx:', 'color', [0.5 0.5 0.5], 'LineWidth', 1., 'markersize', 6);
    plot(theta, FP{2}, 'bx:', 'color', [0.3 0.3 0.3], 'LineWidth', 1., 'markersize', 6);
    plot(theta, FP{3}, 'bx:', 'color', [0. 0. 0.], 'LineWidth', 1., 'markersize', 6);
    lgnd_txt = {'Fadj', 'FU', 'FU(T)', 'FL', 'FP(0)', 'FP(0.5)', 'FP(1)'};
    legend(lgnd_txt, 'Location', 'eastoutside');
    title(sprintf("%s(%s) - Angular Anisotropy", element{i}, corelevel{i}));
    text(0.98, 0.98, sprintf("hv = %i eV", hv),...
        'FontSize', 14, 'color', 'k', 'Units','normalized', 'FontWeight', 'bold', 'HorizontalAlignment','right');
    xlabel(' Angle (degree) ', 'FontWeight','bold');
    ylabel(' Angular Anisotropy ', 'FontWeight','bold');
    axis([0, 90, 0, 3.75]);
    print(path_fig_save + sprintf("figRef_AA_hv%ieV_%s%s", hv, element{i}, corelevel{i}),'-dpng', '-r500');
    close all;
end
%% 2.2 : Hard X-Ray Regime : CONSISTENCY CHECK FOR POLARISATION FUNCTIONS
close all;
% -- Initializing variables
element     = {'C', 'Si', 'Si', 'Ag', 'Au', 'Au'};
corelevel   = {'1s1', '1s1', '2p3', '3d5', '4s1', '4f7'};
hv          = 5000;
theta       = 0:5:90;
phi         = 0;
P           = {0, 0.5, 1};
for i = 1:length(element)
    % -- Extracting polarization factors
    FU = calc_xsect_angle_aniso_FU(hv, element{i}, corelevel{i}, theta);
    FL = calc_xsect_angle_aniso_FL(hv, element{i}, corelevel{i}, theta, phi);
    for j = 1:length(P)
        FP{j} = calc_xsect_angle_aniso_FP(hv, element{i}, corelevel{i}, theta, phi, P{j});
    end
    % -- Squeezing arrays
    FU = squeeze(FU);
    FL = squeeze(FL);
    for j = 1:length(P); FP{j} = squeeze(FP{j}); end
    % -- Plotting a comparison of all polarisation functions
    % --- Creating a figure
    fig = figure(); 
    fig.Position(1) = 100; fig.Position(2) = 100;
    fig.Position(3) = 700; 
    fig.Position(4) = 500;
    % --- Creating a tiled axis
    t = tiledlayout(1,1);
    t.TileSpacing = 'compact';
    t.Padding = 'compact';
    nexttile(); hold on; grid on; grid minor;
    % --- Plot polarisation factors
    plot(theta, FU, 'bo-', 'color', [0.2 0.2 1], 'LineWidth', 2, 'markerfacecolor', [0.2 0.2 1]);
    plot(fliplr(theta), FU, 'bo-', 'color', [0.7 0.7 1], 'LineWidth', 2, 'markerfacecolor', [0.7 0.7 1]);
    plot(theta, FL, 'rd-', 'color', [1 0.2 0.2], 'LineWidth', 2, 'markerfacecolor', [1 0.2 0.2]);
    plot(theta, FP{1}, 'bx:', 'color', [0.5 0.5 0.5], 'LineWidth', 1., 'markersize', 6);
    plot(theta, FP{2}, 'bx:', 'color', [0.3 0.3 0.3], 'LineWidth', 1., 'markersize', 6);
    plot(theta, FP{3}, 'bx:', 'color', [0. 0. 0.], 'LineWidth', 1., 'markersize', 6);
    lgnd_txt = {'FU', 'FU(T)', 'FL', 'FP(0)', 'FP(0.5)', 'FP(1)'};
    legend(lgnd_txt, 'Location', 'eastoutside');
    title(sprintf("%s(%s) - Angular Anisotropy", element{i}, corelevel{i}));
    text(0.98, 0.98, sprintf("hv = %i eV", hv),...
        'FontSize', 14, 'color', 'k', 'Units','normalized', 'FontWeight', 'bold', 'HorizontalAlignment','right');
    xlabel(' Angle (degree) ', 'FontWeight','bold');
    ylabel(' Angular Anisotropy ', 'FontWeight','bold');
    axis([0, 90, 0, 3.75]);
    print(path_fig_save + sprintf("figRef_AA_hv%ieV_%s%s", hv, element{i}, corelevel{i}),'-dpng', '-r500');
    close all;
end
%% 3 :  Comparing Angular Anisotropy of all core-levels
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
        % close all;
        P = 1;
        formalism = "C2022";
        figX = view_angle_aniso(ATOM_SYMB{i}, CoreLevels{j}, [], P);
        save_fullname = path_fig_save + sprintf("Z%i_%i_%s%s_XSECT-ANISO", ATOM_ZNUM(i), j, ATOM_SYMB{i}, CoreLevels{j});
        print(save_fullname,'-dpng', '-r300');
        saveas(figX, save_fullname, 'fig');
    end
end