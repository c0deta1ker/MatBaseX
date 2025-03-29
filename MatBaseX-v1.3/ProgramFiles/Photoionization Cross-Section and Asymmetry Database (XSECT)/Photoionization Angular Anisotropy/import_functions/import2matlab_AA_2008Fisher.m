close all; clear all;
path_matbase        = what('2008Fisher_SX_Formalism'); path_matbase = string(path_matbase.path);
path_fig_save       = path_matbase + "\figs_Fadj\";
%% 1 : Defining all of the variables
% -- Defining the elements whose photoionization cross-sections we have
ATOM_SYMB       = read_mpd_elements();
ATOM_SYMB       = ATOM_SYMB(1:98);
% -- Defining the Z number for each one of these elements
ATOM_ZNUM       = 1:length(ATOM_SYMB);
ATOM_CLEVELS    = read_be_core_levels();
%% 2 : UNPOLARISED LIGHT (Fadj) - SX regime
%% 2.1 : hv@1000eV, theta-dependence
close all;
hv      = 1000;
theta   = 0:5:90;
phi     = 0;
extrapolate     = 1;
plot_results    = 1;
for i = ATOM_ZNUM
    % -- FU angular anisotropy
    calc_xsect_angle_aniso_Fadj(hv, ATOM_SYMB{i}, [], theta, phi, extrapolate, plot_results);
    fname = sprintf("Fadj_hv%ieV_Z%i_%s", hv, ATOM_ZNUM(i), ATOM_SYMB{i});
    print(path_fig_save + fname,'-dpng', '-r500');
    figX = gca;
    saveas(figX, path_fig_save + fname, 'fig');
    close all;
end