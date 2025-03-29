close all; clear all;
path_matbase    = what('1993Moulder_BindingEnergies'); path_matbase = string(path_matbase.path);
path_data       = path_matbase + "\data\";
path_data_save  = path_matbase + "\";
path_fig_save   = path_matbase + "\figs\";
%% 1 :  Loading in binding energies (eV)
% -- Loading in binding energies
T1_Ebe      = readtable(string(path_data) + "T1_Ebe_Moulder1993.csv", 'VariableNamingRule','preserve');
ATOM_SYMB   = T1_Ebe.Element;
ATOM_ZNUM   = T1_Ebe.Z; ATOM_ZNUM = ATOM_ZNUM';
ATOM_CL     = T1_Ebe.Properties.VariableNames(3:end);
ATOM_BE     = T1_Ebe(:,3:end);
% -- Loading in the short-form of the core-level notation
for i = 1:length(ATOM_CL); ATOM_CL{i} = ATOM_CL{i}(1:end-2); end
ATOM_BE.Properties.VariableNames = ATOM_CL;
% -- Loading in fluorescence parameters
T2_hvFluor_Ene      = readtable(string(path_data) + "T2_hvFluor_Ene.csv", 'VariableNamingRule','preserve');
T3_hvFluor_Int      = readtable(string(path_data) + "T3_hvFluor_Int.csv", 'VariableNamingRule','preserve');
T4_hvFluor_Pro      = readtable(string(path_data) + "T4_hvFluor_Pro.csv", 'VariableNamingRule','preserve');
% -- Saving the data to a MATLAB data structure
BE_DB_Moulder1993                   = struct();
BE_DB_Moulder1993.ATOM_SYMB         = ATOM_SYMB;
BE_DB_Moulder1993.ATOM_ZNUM         = ATOM_ZNUM;
BE_DB_Moulder1993.ATOM_CL           = ATOM_CL;
BE_DB_Moulder1993.BE                = ATOM_BE;
BE_DB_Moulder1993.FL_ENERGY         = T2_hvFluor_Ene;
BE_DB_Moulder1993.FL_INTENSITY      = T3_hvFluor_Int;
BE_DB_Moulder1993.FL_PROBABILITY    = T4_hvFluor_Pro;
save(char(path_data_save + "BE_DB_Moulder1993"), 'BE_DB_Moulder1993', '-v7.3');
BE_DB_Moulder1993
%% 2 :  Running through all elements and plotting the binding energy spectra
close all;
for i = ATOM_ZNUM
    save_fullname = path_fig_save + sprintf("Z%i_%s_BE_Moulder1993", ATOM_ZNUM(i), ATOM_SYMB{i});
    calc_be_moulder1993(ATOM_SYMB{i}, [], 1); 
    print(save_fullname,'-dpng', '-r500');
    figX = gca;
    saveas(figX, save_fullname, 'fig');
    close all;
end