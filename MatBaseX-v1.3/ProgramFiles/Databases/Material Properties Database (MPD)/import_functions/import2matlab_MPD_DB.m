close all; clear all;
path_matbase            = what('Material Properties Database (MPD)'); path_matbase = string(path_matbase.path);
path_data               = path_matbase + "\data\";
%% 1 :  Extracting all database information
% -- Database of Elements
database_of_elements    = readtable(path_data + "01_element_database.xlsx", 'NumHeaderLines', 2);
MatData                 = struct();
for i = 1:length(database_of_elements.id)
    fprintf(" element idx: %i/%i \n", i, max(database_of_elements.id));
    el_name                                 = database_of_elements.formula{i};
    MatData.(el_name)                       = struct();
    MatData.(el_name).id                    = double(database_of_elements.id(i));
    MatData.(el_name).type                  = string(database_of_elements.type{i});
    MatData.(el_name).class                 = string(database_of_elements.class{i});
    MatData.(el_name).name                  = string(database_of_elements.name{i});
    MatData.(el_name).formula               = string(database_of_elements.formula{i});
    MatData.(el_name).atom_stoic            = double(database_of_elements.atom_stoic(i));                   % Stoichiometry
    MatData.(el_name).atom_z                = double(database_of_elements.atom_z(i));                       % Atomic Z Number
    MatData.(el_name).atom_mass             = double(database_of_elements.atom_mass(i));                    % Atomic Mass (amu)
    MatData.(el_name).atom_radius           = double(database_of_elements.atom_radius(i));                  % Atomic Radius (pm)
    MatData.(el_name).atom_term             = string(database_of_elements.atom_term{i});                    % Term Symbol
    MatData.(el_name).elec_config           = string(database_of_elements.elec_config{i});                  % Electron Configuration
    MatData.(el_name).elec_valency          = double(database_of_elements.elec_valency(i));                 % Electron Valency
    MatData.(el_name).elec_negativity       = double(database_of_elements.elec_negativity(i));              % Electronegativity (Pauling scale)
    MatData.(el_name).elec_affinity         = double(database_of_elements.elec_affinity(i));                % Electron Affinity (molar eV)
    MatData.(el_name).elec_first_ionization = double(database_of_elements.elec_first_ionization(i));        % First Ionization Energy (molar eV)
    MatData.(el_name).elec_resistivity      = double(database_of_elements.elec_resistivity(i));             % Resistivity (m Ohm)
    MatData.(el_name).elec_work_function    = double(database_of_elements.elec_work_function(i));           % Work Function (eV)
    MatData.(el_name).elec_band_gap         = double(database_of_elements.elec_band_gap(i));                % Band Gap (eV)
    MatData.(el_name).radioactivity         = string(database_of_elements.radioactivity{i});                % Radioactivity
    MatData.(el_name).neut_number           = double(database_of_elements.neut_number(i));                  % Neutron Number
    MatData.(el_name).neut_xsect            = double(database_of_elements.neut_xsect(i));                   % Neutron Cross-Section (barn)
    MatData.(el_name).phase_stp             = string(database_of_elements.phase_stp{i});                    % Phase at STP
    MatData.(el_name).specific_heat         = double(database_of_elements.specific_heat(i));                % Specifit Heat (J/g/K)
    MatData.(el_name).density               = double(database_of_elements.density(i));                      % Mass density (g/cm^3)
    MatData.(el_name).crystal_structure     = string(database_of_elements.crystal_structure{i});            % Crystal Structure
    MatData.(el_name).crystal_a             = double(database_of_elements.crystal_a(i));                    % a (pm)
    MatData.(el_name).crystal_b             = double(database_of_elements.crystal_b(i));                    % b (pm)
    MatData.(el_name).crystal_c             = double(database_of_elements.crystal_c(i));                    % c (pm)
    MatData.(el_name).crystal_alpha         = double(database_of_elements.crystal_alpha(i));                % alpha (degree)
    MatData.(el_name).crystal_beta          = double(database_of_elements.crystal_beta(i));                 % beta (degree)
    MatData.(el_name).crystal_gamma         = double(database_of_elements.crystal_gamma(i));                % gamma (degree)
    MatData.(el_name).magn_type             = string(database_of_elements.magn_type{i});                    % Magnetic Type
    MatData.(el_name).magn_susceptibility   = double(database_of_elements.magn_susceptibility(i));          % Magnetic Susceptibility (cm3/kg)
end
% -- Database of Compounds
database_of_compounds    = readtable(path_data + "02_compound_database.xlsx", 'NumHeaderLines', 2);
for i = 1:length(database_of_compounds.id)
    fprintf(" compound idx: %i/%i \n", i, size(database_of_compounds, 1));
    el_name                                 = database_of_compounds.formula{i};
    MatData.(el_name)                       = struct();
    MatData.(el_name).id                    = double(database_of_compounds.id(i));
    MatData.(el_name).type                  = string(database_of_compounds.type{i});
    MatData.(el_name).class                 = string(database_of_compounds.class{i});
    MatData.(el_name).name                  = string(database_of_compounds.name{i});
    MatData.(el_name).formula               = string(database_of_compounds.formula{i});
    MatData.(el_name).atom_stoic            = calc_stoichiometry(MatData.(el_name).formula);           % Stoichiometry
    MatData.(el_name).atom_z                = calc_average_z_number(MatData.(el_name).formula);        % Atomic Z Number
    MatData.(el_name).atom_mass             = calc_molar_mass(MatData.(el_name).formula);              % Atomic Mass (amu)
    MatData.(el_name).elec_valency          = calc_elec_valency(MatData.(el_name).formula);            % Electron Valency
    MatData.(el_name).elec_work_function    = double(database_of_compounds.elec_work_function(i));         % Work Function (eV)
    MatData.(el_name).elec_band_gap         = double(database_of_compounds.elec_band_gap(i));              % Band Gap (eV)
    MatData.(el_name).density               = double(database_of_compounds.density(i));                    % Mass density (g/cm^3)
    MatData.(el_name).elec_resistivity      = double(database_of_compounds.elec_resistivity(i));           % Resistivity (m Ohm)
    MatData.(el_name).crystal_structure     = string(database_of_compounds.crystal_structure{i});          % Crystal Structure
    MatData.(el_name).crystal_a             = double(database_of_compounds.crystal_a(i));                  % a (pm)
    MatData.(el_name).crystal_b             = double(database_of_compounds.crystal_b(i));                  % b (pm)
    MatData.(el_name).crystal_c             = double(database_of_compounds.crystal_c(i));                  % c (pm)
    MatData.(el_name).crystal_alpha         = double(database_of_compounds.crystal_alpha(i));              % alpha (degree)
    MatData.(el_name).crystal_beta          = double(database_of_compounds.crystal_beta(i));               % beta (degree)
    MatData.(el_name).crystal_gamma         = double(database_of_compounds.crystal_gamma(i));              % gamma (degree)
end
display(MatData);
%% 2 :  Saving the final database
save_fullfile = path_data + sprintf("v20250222_MatData");
save(char(save_fullfile), 'MatData', '-v7.3');