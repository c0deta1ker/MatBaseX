function atom_edge_table = read_xae_all_elements()
% atom_edge_table = read_xae_all_elements()
%   This function returns a table with all the atomic elements, edge names
%   and energies.
%
%   IN: (none)
%
%   OUT:
%   -   atom_edge_table:      3 column table, returning the atomic symbol, edge name and energy of all elements / edges available in literature

%% 1 - Extracting a comprehensive list of all binding energies
ATOM_SYMB = read_mpd_elements();
ATOM_SYMB = ATOM_SYMB(1:98);
for i = 1:length(ATOM_SYMB)
    [ATOM_EDGE_ENERGY{i}, ATOM_EDGE{i}] = calc_xae(ATOM_SYMB{i});
end
%% 2 - Creating a table from the list of all binding energies
symbol = {}; edgename = {}; edgeenergy = {};
for i = 1:length(ATOM_SYMB)
    for j = 1:length(ATOM_EDGE_ENERGY{i})
        symbol{end+1}       = ATOM_SYMB{i};
        edgename{end+1}     = ATOM_EDGE{i}(j);
        edgeenergy{end+1}   = ATOM_EDGE_ENERGY{i}(j);
    end
end
% Creating the data table
atom_edge_table = table(symbol', edgename', edgeenergy', 'VariableNames', {'ATOM_SYMB', 'ATOM_EDGE', 'ATOM_ENERGY'});
end