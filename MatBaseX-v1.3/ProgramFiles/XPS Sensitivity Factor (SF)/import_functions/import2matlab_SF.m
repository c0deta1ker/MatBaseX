close all; clear all;
path_matbase        = what('XPS Sensitivity Factor (SF)'); path_matbase = string(path_matbase.path);
path_fig_save_SF    = path_matbase + "\0_figs_sf\";
path_fig_save_RSF   = path_matbase + "\0_figs_rsf\";
%% 1    :   Initialization
ATOM_SYMB   = read_mpd_elements();          % -- Defining all possible elements
ATOM_SYMB   = ATOM_SYMB(1:92);
COMP_SYMB   = read_mpd_compounds();         % -- Defining all possible compounds
MAT_SYMB    = horzcat(ATOM_SYMB, COMP_SYMB);    % -- List of all materials
ATOM_ZNUM   = 1:length(ATOM_SYMB);
%% 2    :   Photon Energy Dependence
for i = 1:length(ATOM_SYMB)
    fig     = view_sf_vs_hv(ATOM_SYMB{i});
    fnum    = sprintf('%.2f', 0.5); fnum = strrep(fnum, '.', '');
    fname   = sprintf("SF_P%s_theta%ideg_phi%ideg_Z%i_%s", fnum, 0, 0, ATOM_ZNUM(i), ATOM_SYMB{i});
    print(path_fig_save_SF + fname,'-dpng', '-r300');
    saveas(fig, path_fig_save_SF + fname, 'fig');
    close all;
end
%% 3    :   Theta Dependence
for i = 1:length(ATOM_SYMB)
    fig     = view_sf_vs_theta(ATOM_SYMB{i});
    fnum    = sprintf('%.2f', 0.5); fnum = strrep(fnum, '.', '');
    fname   = sprintf("SF_P%s_hv%ieV_phi%ideg_Z%i_%s", fnum, 1000, 0, ATOM_ZNUM(i), ATOM_SYMB{i});
    print(path_fig_save_SF + fname,'-dpng', '-r300');
    saveas(fig, path_fig_save_SF + fname, 'fig');
    close all;
end
%% 4    :   Photon Energy Dependence
for i = 1:length(ATOM_SYMB)
    fig = view_rsf_vs_hv(ATOM_SYMB{i});
    fnum    = sprintf('%.2f', 0.5); fnum = strrep(fnum, '.', '');
    fname   = sprintf("RSF_P%s_theta%ideg_phi%ideg_Z%i_%s", fnum, 0, 0, ATOM_ZNUM(i), ATOM_SYMB{i});
    print(path_fig_save_RSF + fname,'-dpng', '-r300');
    saveas(fig, path_fig_save_RSF + fname, 'fig');
    close all;
end
%% 5    :   Theta Dependence
for i = 1:length(ATOM_SYMB)
    fig     = view_rsf_vs_theta(ATOM_SYMB{i});
    fnum    = sprintf('%.2f', 0.5); fnum = strrep(fnum, '.', '');
    fname   = sprintf("RSF_P%s_hv%ieV_phi%ideg_Z%i_%s", fnum, 1000, 0, ATOM_ZNUM(i), ATOM_SYMB{i});
    print(path_fig_save_RSF + fname,'-dpng', '-r300');
    saveas(fig, path_fig_save_RSF + fname, 'fig');
    close all;
end
