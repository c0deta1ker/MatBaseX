close all; clear all;
path_matbase    = what('1993Henke_AtomicScatteringFactors'); path_matbase = string(path_matbase.path);
path_data       = path_matbase + "\data\";
path_data_save  = path_matbase + "\";
path_fig_save   = path_matbase + "\figs\";
%% 1 :  Defining span of elements
ATOM_SYMB = read_mpd_elements();
ATOM_SYMB = ATOM_SYMB(1:92);
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
    DATA_TABLE{1,i} = raw_table;
    % -- Reading in all the values from the table
    HV{1,i}         = table2array(raw_table(:,1))';
    F1{1,i}         = table2array(raw_table(:,2))';
    F2{1,i}         = table2array(raw_table(:,3))';
    % -- Ensuring all data points are unique
    [HV{1,i}, idx, ~]   = unique(HV{1,i});
    F1{1,i}             = F1{1,i}(idx);
    F2{1,i}             = F2{1,i}(idx);
end
XASF_DB_Henke1993                 = struct();
XASF_DB_Henke1993.file_names      = file_names_all;
XASF_DB_Henke1993.ATOM_SYMB       = ATOM_SYMB;
XASF_DB_Henke1993.ATOM_ZNUM       = ATOM_ZNUM;
XASF_DB_Henke1993.DATA_TABLE      = DATA_TABLE;
XASF_DB_Henke1993.HV              = HV;
XASF_DB_Henke1993.F1              = F1;
XASF_DB_Henke1993.F2              = F2;
save(char(path_data_save + "XASF_DB_Henke1993"), 'XASF_DB_Henke1993', '-v7.3');
XASF_DB_Henke1993
%% 3 :  Running through all elements and plotting the data
close all;
hv_domain       = 0;
extrapolate     = 0;
plot_results    = 1;
for i = ATOM_ZNUM
    save_fullname = path_fig_save + sprintf("Z%i_%s_XASF_Henke1993", ATOM_ZNUM(i), ATOM_SYMB{i});
    calc_xasf_henke1993(hv_domain, ATOM_SYMB{i}, extrapolate, plot_results);      
    print(save_fullname,'-dpng', '-r500');
    figX = gca;
    saveas(figX, save_fullname, 'fig');
    close all;
end
