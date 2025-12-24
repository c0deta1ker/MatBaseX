close all; clear all;
path_matbase    = what('1999NIST_IMFP_NIST_Optical_Experiments'); path_matbase = string(path_matbase.path);
path_data       = path_matbase + "\data_optical\";
path_data_save  = path_matbase + "\";
%% 1 :  Defining all of the variables
% -- Defining the elements whose data is available
ATOM_SYMB = read_mpd_elements();
ATOM_SYMB = ATOM_SYMB(1:92);
% -- Defining the Z number for each one of these elements
ATOM_ZNUM = 1:length(ATOM_SYMB);
%% 2 :  Iterating through all the data-files and extracting the IMFPs
% -- Extracting all the filenames for the photoionisation data
file_names = dir(path_data);
file_names = {file_names(~[file_names.isdir]).name};
% -- Filing through all the elements to isolate each element
for i = ATOM_ZNUM
    % --- Finding the index number for the element
    findx           = find(contains(file_names, "_"+string(ATOM_SYMB{i})+"_"));
    selected_names  = file_names(findx);
    file_names_all{i} = selected_names;
end
nist_imfp_data      = {};
% -- Loading in all the data for each text file
for i = ATOM_ZNUM
    ke_dat      = [];
    imfp_dat    = [];
    for j = 1:length(file_names_all{i})
        % -- Loading in all of the data
        data_00     = readtable(string(path_data) + string(file_names_all{i}{j}));
        % -- Modify variable names
        data_00.Properties.VariableNames{1} = 'Energy';
        data_00.Properties.VariableNames{2} = 'IMFP';
        % -- Finding the first NaN value to crop to
        indx    = max(find(isnan(data_00.Energy)));
        ke_dat      = data_00.Energy(indx+1:end);
        imfp_dat    = data_00.IMFP(indx+1:end);
        % -- Storing the data into a cell array
        nist_imfp_data{i}{j} = [ke_dat, imfp_dat];
    end
end
% -- Finding the total number of text-files loaded for each element
nist_imfp_num_of_files    = [];
for i = ATOM_ZNUM; nist_imfp_num_of_files(i) = length(nist_imfp_data{i}); end
%% 3 :  Interpolating the IMFPs
nist_imfp_data_interp = {};
for i = 1:length(nist_imfp_data)
    ke_dat      = [];
    imfp_dat    = [];
    for j = 1:length(nist_imfp_data{i})
        % -- Loading in the original data
        ke_dat      = nist_imfp_data{i}{j}(:,1);   % -- Electron Kinetic Energy
        imfp_dat    = nist_imfp_data{i}{j}(:,2);   % -- Inelastic Mean Free Path
        % -- Storing the data into a cell array
        ek_V    = linspace(min(ke_dat(:)), max(ke_dat(:)), 1000);
        imfp_V  = interp1(ke_dat, imfp_dat, ek_V, 'linear', NaN);
        % -- Appending the interpolated data into a cell array
        nist_imfp_data_interp{i}{j} = [ek_V', imfp_V'];
    end
end
%% 4 :  Create a table for each element that summarizes all of the IMFP data
for i = 1:length(nist_imfp_data)
    imfp_table{i}  = table();
    for j = 1:length(nist_imfp_data{i})
        ek_name     = "ek_" + string(j);
        imfp_name   = "imfp_" + string(j);
        imfp_table{i}.(ek_name)    = nist_imfp_data_interp{i}{j}(:,1);
        imfp_table{i}.(imfp_name)  = nist_imfp_data_interp{i}{j}(:,2);
    end
end
IMFPD_NIST1999                  = struct();
IMFPD_NIST1999.ATOM_SYMB        = ATOM_SYMB;                % Atomic symbols used
IMFPD_NIST1999.ATOM_ZNUM        = ATOM_ZNUM;                % Atomic Z number for each one of these elements
IMFPD_NIST1999.FileNames        = file_names_all;           % Cell-array of all the text file names
IMFPD_NIST1999.Length           = nist_imfp_num_of_files;   % Array where; {Atom Z number}(total number of files used)
IMFPD_NIST1999.DataRaw          = nist_imfp_data;           % Cell-array where; {Atom Z number}{File Index}(electron kinetic energy [eV], imfp [Ang])
IMFPD_NIST1999.DataInterp       = nist_imfp_data_interp;    % Cell-array where; {Atom Z number}{Core-level}(electron kinetic energy [eV], imfp [Ang])
IMFPD_NIST1999.Data             = imfp_table;               % MATLAB Table where; {Atom Z number}
save(char(path_data_save + "IMFPD_NIST1999"), 'IMFPD_NIST1999', '-v7.3');