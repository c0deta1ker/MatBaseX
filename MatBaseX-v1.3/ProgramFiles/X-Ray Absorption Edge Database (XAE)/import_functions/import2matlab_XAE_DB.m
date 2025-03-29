close all; clear all;
%% 1 :  Importing all X-ray Absorption Edge (XAE) databases
run import2matlab_XAE_DB_2025IXAS.m; close all; clear all;
%% 2 :  Plotting XAE for all elements & compounds
% -- Initializing save path
path_matbase    = what('X-Ray Absorption Edge Database (XAE)'); path_matbase = string(path_matbase.path);
path_fig_save   = path_matbase + "\0_figs\";
% -- Defining all of the variables
ATOM_ELE   = read_mpd_elements();           % -- List of all elements
ATOM_ELE    = ATOM_ELE(1:98);
ATOM_CMP   = read_mpd_compounds();          % -- List of all compounds
MAT_SYMB   = horzcat(ATOM_ELE, ATOM_CMP);   % -- List of all elements & compounds
% -- Plotting IMFP of all elements
for i = 1:length(MAT_SYMB)
    fprintf(" Material: %s\n", MAT_SYMB{i});
    mat_props = get_mpd_props(MAT_SYMB{i});
    save_fullname = path_fig_save + sprintf("id%i_%s_XAE", mat_props.id, MAT_SYMB{i});
    figX = view_xae(MAT_SYMB{i});  
    print(save_fullname,'-dpng', '-r500');
    saveas(figX, save_fullname, 'fig');
    close all;
end