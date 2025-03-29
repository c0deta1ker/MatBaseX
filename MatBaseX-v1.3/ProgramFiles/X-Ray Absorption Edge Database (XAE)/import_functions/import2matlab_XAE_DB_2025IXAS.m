close all; clear all;
path_matbase    = what('2025IXAS_XrayEdgesAndLines'); path_matbase = string(path_matbase.path);
path_data       = path_matbase + "\data\";
path_data_save  = path_matbase + "\";
path_fig_save   = path_matbase + "\figs\";
%% 1 :  Defining span of elements
ATOM_SYMB = read_mpd_elements();
ATOM_SYMB = ATOM_SYMB(1:98);
ATOM_ZNUM = 1:length(ATOM_SYMB);
%% 2 :  Iterating through all the data-files and storing the data
% -- Extracting all the filenames for the photoionization data
file_names      = dir(path_data);
file_names      = {file_names(~[file_names.isdir]).name};
file_names_all  = strings(length(ATOM_ZNUM),1);
% -- Filing through all the elements to find each element data
for i = ATOM_ZNUM
    % - Extracting raw data
    findx               = find(contains(file_names, "_"+string(ATOM_SYMB{i} + ".txt")));
    fname               = file_names(findx);
    file_names_all(i)   = string(fname);
    raw_table           = readtable(string(path_data) + string(fname), 'VariableNamingRule','preserve');
    raw_table.Properties.VariableNames(1:5) = {'Edge_Label', 'Energy_eV', ' Width_eV', 'Fluorescence_Yield', 'Edge_Jump'};
    DATA_TABLE{1,i}     = raw_table;
    % -- Reading in all the values from the table
    Edge_Label{1,i}             = table2array(raw_table(:,1)); Edge_Label{1,i}(1) = {'K1'};
    Energy_eV{1,i}              = table2array(raw_table(:,2))';
    Width_eV{1,i}               = table2array(raw_table(:,3))';
    Fluorescence_Yield{1,i}     = table2array(raw_table(:,4))';
    Edge_Jump{1,i}              = table2array(raw_table(:,5))';
end
XAE_DB_IXAS2025                 = struct();
XAE_DB_IXAS2025.file_names      = file_names_all;
XAE_DB_IXAS2025.ATOM_SYMB       = ATOM_SYMB;
XAE_DB_IXAS2025.ATOM_ZNUM       = ATOM_ZNUM;
XAE_DB_IXAS2025.DATA_TABLE      = DATA_TABLE;
XAE_DB_IXAS2025.ATOM_EDGE_NAME      = Edge_Label;
XAE_DB_IXAS2025.ATOM_EDGE_ENERGY    = Energy_eV;
XAE_DB_IXAS2025.ATOM_EDGE_WIDTH     = Width_eV;
XAE_DB_IXAS2025.ATOM_EDGE_JUMP      = Edge_Jump;
XAE_DB_IXAS2025.ATOM_FLU_YIELD      = Fluorescence_Yield;
save(char(path_data_save + "XAE_DB_IXAS2025"), 'XAE_DB_IXAS2025', '-v7.3');
XAE_DB_IXAS2025
%% 3 :  Running through all elements and plotting the data
close all;
hv_domain       = 0;
extrapolate     = 0;
plot_results    = 1;
for i = ATOM_ZNUM
    save_fullname = path_fig_save + sprintf("Z%i_%s_XAE_IXAS2025", ATOM_ZNUM(i), ATOM_SYMB{i});
    calc_xae_ixas2025(ATOM_SYMB{i}, [], plot_results);
    print(save_fullname,'-dpng', '-r500');
    figX = gca;
    saveas(figX, save_fullname, 'fig');
    close all;
end