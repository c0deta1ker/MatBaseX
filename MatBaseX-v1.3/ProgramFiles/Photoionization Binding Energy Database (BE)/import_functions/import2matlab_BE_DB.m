close all; clear all;
%% 1 :  Importing all Binding Energy (BE) databases
run import2matlab_BE_DB_1993Moulder.m; close all; clear all;
run import2matlab_BE_DB_2018Trzh.m; close all; clear all;
run import2matlab_BE_DB_2022Cant.m; close all; clear all;
run import2matlab_BE_DB_2023Constantinou.m; close all; clear all;
%% 2 :  Plotting BE for all elements & compounds
% -- Initializing save path
path_matbase    = what('Photoionization Binding Energy Database (BE)'); path_matbase = string(path_matbase.path);
path_fig_save   = path_matbase + "\0_figs\";
% -- Defining all of the variables
ATOM_ELE   = read_mpd_elements();           % -- List of all elements
ATOM_ELE = ATOM_ELE(1:98);
ATOM_CMP   = read_mpd_compounds();          % -- List of all compounds
MAT_SYMB   = horzcat(ATOM_ELE, ATOM_CMP);   % -- List of all elements & compounds
% -- Plotting IMFP of all elements
for i = 1:length(MAT_SYMB)
    fprintf(" Material: %s\n", MAT_SYMB{i});
    mat_props = get_mpd_props(MAT_SYMB{i});
    save_fullname = path_fig_save + sprintf("id%i_%s_BE", mat_props.id, MAT_SYMB{i});
    figX = view_be(MAT_SYMB{i});  
    print(save_fullname,'-dpng', '-r500');
    saveas(figX, save_fullname, 'fig');
    close all;
end