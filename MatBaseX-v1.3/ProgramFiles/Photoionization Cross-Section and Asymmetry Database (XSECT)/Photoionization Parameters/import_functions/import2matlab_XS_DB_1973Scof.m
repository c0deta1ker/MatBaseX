close all; clear all;
path_matbase    = what('1973Scofield_Photoionization_Cross_Sections'); path_matbase = string(path_matbase.path);
path_data_sigma     = path_matbase + "\data_sigma\";
path_data_save      = path_matbase + "\";
path_fig_save_sigma = path_matbase + "\figs_sigma\";
%% 1 :  Defining all of the variables
% -- Defining the elements whose photoionization cross-sections are available
ATOM_SYMB = read_mpd_elements();
ATOM_SYMB = ATOM_SYMB(1:100);
% -- Defining the Z number for each one of these elements
ATOM_ZNUM = 1:length(ATOM_SYMB);
% -- Defining all of the core-levels that are probed
ATOM_CL = {...
    '1s1',...
    '2s1', '2p1', '2p3',...
    '3s1', '3p1', '3p3', '3d3', '3d5',...
    '4s1', '4p1', '4p3', '4d3', '4d5', '4f5', '4f7',...
    '5s1', '5p1', '5p3', '5d3', '5d5', '5f5', '5f7',...
    '6s1', '6p1', '6p3',...
    '7s1',...
    };
%% 2 :  Iterating through all the data-files and extracting the photoionization cross-sections, sigma
% -- Extracting all the filenames for the photoionization data
file_names              = dir(path_data_sigma);
file_names              = {file_names(~[file_names.isdir]).name};
% -- Filing through all the elements to isolate each element
file_names_all          = strings(length(ATOM_ZNUM),1);
for i = ATOM_ZNUM
    % --- Finding the index number for the element
    findx               = find(contains(file_names, "_"+string(ATOM_SYMB{i}+".csv")));
    selected_names      = file_names(findx);
    % --- Appending the filename to a cell array
    file_names_all(i)   = string(selected_names{1});
end
% -- Loading in all the data for each data file
DATA_TABLE = {}; XSECT_SIGMA_TOTAL = {}; XSECT_SIGMA_SHELL = {}; XSECT_SIGMA = {};
for i = ATOM_ZNUM
    raw_table           = readtable(string(path_data_sigma) + string(file_names_all(i)), 'VariableNamingRule','preserve');
    raw_table(end,:)    = [];
    raw_table.(1)       = 1000*raw_table.(1);
    DATA_TABLE{1,i}     = raw_table;
    % -- Fragmenting the tables for different variables
    HV{i}               = DATA_TABLE{1,i}(:,1);
    if i == 1
        XSECT_SIGMA_TOTAL{1,i}      = DATA_TABLE{1,i}(:,2);
        XSECT_SIGMA_SHELL{1,i}      = DATA_TABLE{1,i}(:,3);
        XSECT_SIGMA{1,i}            = DATA_TABLE{1,i}(:,4);
    else
        XSECT_SIGMA_TOTAL{1,i}      = DATA_TABLE{1,i}(:,2);
        XSECT_SIGMA_SHELL{1,i}      = DATA_TABLE{1,i}(:,3:6);
        XSECT_SIGMA{1,i}            = DATA_TABLE{1,i}(:,7:end);
    end
    init_names                      = XSECT_SIGMA{i}.Properties.VariableNames;
    for k = 1:length(init_names); init_names{k} = init_names{k}(1:3); end
    XSECT_SIGMA{i}.Properties.VariableNames = init_names;
end
XS_DB_Scof1973                   = struct();
XS_DB_Scof1973.file_names        = file_names_all;
XS_DB_Scof1973.ATOM_SYMB         = ATOM_SYMB;
XS_DB_Scof1973.ATOM_ZNUM         = ATOM_ZNUM;
XS_DB_Scof1973.ATOM_CL           = ATOM_CL;
XS_DB_Scof1973.DATA_TABLE        = DATA_TABLE;
XS_DB_Scof1973.HV                = HV;
XS_DB_Scof1973.XSECT_SIGMA          = XSECT_SIGMA;
XS_DB_Scof1973.XSECT_SIGMA_SHELL    = XSECT_SIGMA_SHELL;
XS_DB_Scof1973.XSECT_SIGMA_TOTAL    = XSECT_SIGMA_TOTAL;
save(char(path_data_save + "XS_DB_Scof1973"), 'XS_DB_Scof1973', '-v7.3');
XS_DB_Scof1973
%% 3 :  Running through all elements and plotting the cross-sections
close all;
hv_domain       = 0;
extrapolate     = 0;
plot_results    = 1;
for i = ATOM_ZNUM
    % -- Plotting Sigma
    save_fullname = path_fig_save_sigma + sprintf("Z%i_%s_XS_sigma_Scof1973", ATOM_ZNUM(i), ATOM_SYMB{i});
    calc_xsect_sigma_scof1973(hv_domain, ATOM_SYMB{i}, [], extrapolate, plot_results);  
    figX = gca;
    print(save_fullname,'-dpng', '-r500');
    saveas(figX, save_fullname, 'fig');
    close all;
end