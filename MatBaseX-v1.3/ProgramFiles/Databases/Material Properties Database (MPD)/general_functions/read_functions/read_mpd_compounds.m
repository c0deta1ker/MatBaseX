function compound_names_list = read_mpd_compounds()
% compound_names_list = read_mpd_compounds()
%   This function returns a cell array containing all compounds defined within 
%   the materials properties database.
%
%   IN: (none)
%
%   OUT:
%   -   compound_names_list:      1xN cell array of the element formula

%% 1 : Extracting all compound names
% -- Loading in the materials database
MatData             = load('MatData.mat'); MatData = MatData.MatData;
% -- Extracting the total number of elements
element_names       = read_mpd_elements();
num_of_elements     = length(element_names);
% -- Extracting the total number of compounds & the index numbers
field_names         = fieldnames(MatData);
id_start            = num_of_elements + 1;
id_end              = numel(field_names);
num_of_compounds    = id_end - id_start + 1;
% -- Extracting all the compound names
compound_names_list = cell(1,num_of_compounds);
for i = id_start:id_end
    compound_data       = MatData.(field_names{i});
    compound_names_list{i-num_of_elements}   = char(compound_data.formula);
end
end