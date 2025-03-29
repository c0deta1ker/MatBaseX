close all; clear all;
path_matbase        = what('2022Cant_HX_Formalism'); path_matbase = string(path_matbase.path);
path_fig_save_FL    = path_matbase + "\figs_FL\";
path_fig_save_FU    = path_matbase + "\figs_FU\";
path_fig_save_FP    = path_matbase + "\figs_FP\";
%% 1 : Defining all of the variables
% -- Defining the elements whose photoionization cross-sections we have
ATOM_SYMB       = read_mpd_elements();
ATOM_SYMB       = ATOM_SYMB(1:98);
% -- Defining the Z number for each one of these elements
ATOM_ZNUM       = 1:length(ATOM_SYMB);
ATOM_CLEVELS    = read_be_core_levels();
%% 2 : UNPOLARISED LIGHT (FU)
%% 2.1 : hv@5000eV, omega-dependence
close all;
hv      = 5000;
omega   = 0:5:90;
extrapolate     = 1;
plot_results    = 1;
for i = ATOM_ZNUM
    % -- FU angular anisotropy
    calc_xsect_angle_aniso_FU(hv, ATOM_SYMB{i}, [], omega, extrapolate, plot_results);
    figX = gca;
    fname = sprintf("FU_hv%ieV_Z%i_%s", hv, ATOM_ZNUM(i), ATOM_SYMB{i});
    print(path_fig_save_FU + fname,'-dpng', '-r500');
    saveas(figX, path_fig_save_FU + fname, 'fig');
    close all;
end

%% 3 : LINEARLY POLARISED LIGHT (FL)
%% 3.1 : hv@5000eV, phi@0degree, theta-dependence
close all;
hv      = 5000;
theta   = 0:5:90;
phi     = 0;
extrapolate     = 1;
plot_results    = 1;
for i = ATOM_ZNUM
    % -- FL angular anisotropy
    calc_xsect_angle_aniso_FL(hv, ATOM_SYMB{i}, [], theta, phi, extrapolate, plot_results);
    figX = gca;
    fname = sprintf("FL_hv%ieV_phi%ideg_Z%i_%s", hv, phi, ATOM_ZNUM(i), ATOM_SYMB{i});
    print(path_fig_save_FL + fname,'-dpng', '-r500');
    saveas(figX, path_fig_save_FL + fname, 'fig');
    close all;
end
%% 3.2 : hv@5000eV, theta@0degree, phi-dependence
close all;
hv      = 5000;
theta   = 0;
phi     = 0:10:180;
extrapolate     = 1;
plot_results    = 1;
for i = ATOM_ZNUM
    % -- FL angular anisotropy
    calc_xsect_angle_aniso_FL(hv, ATOM_SYMB{i}, [], theta, phi, extrapolate, plot_results);
    figX = gca;
    fname = sprintf("FL_hv%ieV_theta%ideg_Z%i_%s", hv, theta, ATOM_ZNUM(i), ATOM_SYMB{i});
    print(path_fig_save_FL + fname,'-dpng', '-r500');
    saveas(figX, path_fig_save_FL + fname, 'fig');
    close all;
end

%% 4 : PARTIALLY LINEARLY POLARISED LIGHT (FP)
P = {0, 0.5, 1};
for pp = 1:length(P)
% 4.1 : hv@5000eV, phi@0degree, theta-dependence
    close all;
    hv      = 5000;
    theta   = 0:5:90;
    phi     = 0;
    extrapolate     = 1;
    plot_results    = 1;
    for i = ATOM_ZNUM
        % -- FL angular anisotropy
        calc_xsect_angle_aniso_FP(hv, ATOM_SYMB{i}, [], theta, phi, P{pp}, extrapolate, plot_results);
        figX = gca;
        fnum = sprintf('%.2f', P{pp}); fnum = strrep(fnum, '.', '');
        fname = sprintf("FP_P%s_hv%ieV_phi%ideg_Z%i_%s", fnum, hv, phi, ATOM_ZNUM(i), ATOM_SYMB{i});
        print(path_fig_save_FP + fname,'-dpng', '-r500');
        saveas(figX, path_fig_save_FP + fname, 'fig');
        close all;
    end
% 4.2 : hv@5000eV, theta@0degree, phi-dependence
    close all;
    hv      = 5000;
    theta   = 0;
    phi     = 0:10:180;
    plot_results    = 1;
    for i = ATOM_ZNUM
        % -- FL angular anisotropy
        calc_xsect_angle_aniso_FP(hv, ATOM_SYMB{i}, [], theta, phi, P{pp}, extrapolate, plot_results);
        figX = gca;
        fnum = sprintf('%.2f', P{pp}); fnum = strrep(fnum, '.', '');
        fname = sprintf("FP_P%s_hv%ieV_theta%ideg_Z%i_%s", fnum, hv, theta, ATOM_ZNUM(i), ATOM_SYMB{i});
        print(path_fig_save_FP + fname,'-dpng', '-r500');
        saveas(figX, path_fig_save_FP + fname, 'fig');
        close all;
    end
end