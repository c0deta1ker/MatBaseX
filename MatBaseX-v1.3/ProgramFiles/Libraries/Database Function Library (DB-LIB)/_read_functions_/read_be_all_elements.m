function atom_be_table = read_be_all_elements()
% atom_be_table = calc_be_all_elements()
%   This function returns a table with all the atomic elements, core-levels
%   and binding energies.
%
%   IN: (none)
%
%   OUT:
%   -   atom_be_table:      3 column table, returning the atomic symbol, core-level and binding energy of all elements / core-levels available in literature

%% 1 - Extracting a comprehensive list of all binding energies
ATOM_SYMB = read_mpd_elements();
ATOM_SYMB = ATOM_SYMB(1:98);
for i = 1:length(ATOM_SYMB)
    [ATOM_BE{i}, ATOM_CL{i}] = calc_be(ATOM_SYMB{i});
end
%% 2 - Creating a table from the list of all binding energies
symbol = {}; cl = {}; be = {};
for i = 1:length(ATOM_SYMB)
    for j = 1:length(ATOM_BE{i})
        symbol{end+1}  = ATOM_SYMB{i};
        cl{end+1}      = ATOM_CL{i}(j);
        be{end+1}      = ATOM_BE{i}(j);
    end
end
% Creating the data table
atom_be_table = table(symbol', cl', be', 'VariableNames', {'ATOM_SYMB', 'ATOM_CL', 'ATOM_BE'});
end