close all; clear all;
%% 1 :  Importing all IMFP databases
run import2matlab_IMFP_DB_NIST1999.m; close all; clear all;
%% 2 :  Comparing IMFP using all formalisms
% -- Initializing save path
path_matbase    = what('Electron Inelastic Mean Free Path Database (IMFP)'); path_matbase = string(path_matbase.path);
path_fig_save   = path_matbase + "\0_figs\";
% -- Defining all of the variables
ATOM_ELE   = read_mpd_elements();           % -- List of all elements  
ATOM_CMP   = read_mpd_compounds();          % -- List of all compounds
MAT_SYMB   = horzcat(ATOM_ELE, ATOM_CMP);   % -- List of all elements & compounds
% -- Plotting IMFP of all elements
for i = 1:length(MAT_SYMB)
    save_fullname = path_fig_save + sprintf("id%i_%s_IMFP", i, MAT_SYMB{i});
    figX = view_imfp(MAT_SYMB{i});  
    print(save_fullname,'-dpng', '-r500');
    saveas(figX, save_fullname, 'fig');
    close all;
end