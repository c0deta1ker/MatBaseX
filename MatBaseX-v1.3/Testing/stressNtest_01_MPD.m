close all; clear all; clc;
%% Initializing variables
ATOM_ELE   = read_mpd_elements();           % -- List of all elements  
ATOM_CMP   = read_mpd_compounds();          % -- List of all compounds
MAT_SYMB    = horzcat(ATOM_ELE, ATOM_CMP);  % -- List of all elements & compounds
%% Stress Testing: parse_chemical_formula()
n           = 1e3;
formula     = {};
for i = 1:n
    material = "";
    gen = randi([1, 10], 1);
    idx = randi([1, length(ATOM_ELE)], 1, gen);
    for j = 1:gen
        if mod(j, 2) == 0;  material = sprintf("%s%i", material, idx(j));
        else;               material = sprintf("%s%s", material, ATOM_ELE{idx(j)});
        end
    end
    formula{i} = parse_chemical_formula(material);
    % -- Printing Outputs
    fprintf("\n\nMaterial: %s\n", material);
    for j = 1:length(formula{i})
        fprintf("\tElement : %s, Quantity : %.4f\n", formula{i}(j).element, formula{i}(j).quantity);
    end
end
%% Stress Testing: get_mpd_props()
n = 1e2;
% -- Known Material
for i = 1:n
    idx       = randi([1, length(MAT_SYMB)], 1, gen);   
    formula   = MAT_SYMB{idx};
    fprintf("Material: %s\n", formula);
    mat_props = get_mpd_props(formula);
end
% -- Unknown Material
n = 1e2;
for i = 1:n
    formula = "";
    gen = randi([1, 10], 1);
    idx = randi([1, length(ATOM_ELE)], 1, gen);
    for j = 1:gen
        if mod(j, 2) == 0;  formula = sprintf("%s%i", formula, idx(j));
        else;               formula = sprintf("%s%s", formula, ATOM_ELE{idx(j)});
        end
    end
    fprintf("Material: %s\n", formula);
    mat_props = get_mpd_props(formula);
end
%% Stress Testing: calc_mpd_elemental_ratio()
n       = 1e3;
ratio   = [];
for i = 1:n
    material = "";
    gen = randi([1, 10], 1);
    idx = randi([1, length(ATOM_ELE)], 1, gen);
    for j = 1:gen
        if mod(j, 2) == 0;  material = sprintf("%s%i", material, idx(j));
        else;               material = sprintf("%s%s", material, ATOM_ELE{idx(j)});
        end
    end
    idx(2:2:end) = [];
    element_of_interest = ATOM_ELE{idx(randi([1, length(idx)], 1))};
    ratio(i)            = calc_elemental_ratio(material, element_of_interest);
    % -- Printing Outputs
    fprintf("\n\nMaterial: %s\n", material);
    fprintf("\tElement : %s, Ratio : %.4f\n", element_of_interest, ratio(i));
end
%% Stress Testing: General calculators
n = 1e2;
for i = 1:n
    formula = "";
    gen = randi([1, 10], 1);
    idx = randi([1, length(ATOM_ELE)], 1, gen);
    for j = 1:gen
        if mod(j, 2) == 0;  formula = sprintf("%s%i", formula, idx(j));
        else;               formula = sprintf("%s%s", formula, ATOM_ELE{idx(j)});
        end
    end
    Z   = calc_average_z_number(formula);
    V   = calc_elec_valency(formula);
    Mm  = calc_molar_mass(formula);
    S   = calc_stoichiometry(formula);
    fprintf("Material: %s\n", formula);
    fprintf(" Avg.Z: \t\t%.3f\n", Z);
    fprintf(" Elect.Val.: \t%.3f\n", V);
    fprintf(" Stoichiometry: %.3f\n", S);
    fprintf(" Molar Mass: \t%.3f g/mol\n", Mm);
end
%% -- Current Errors
formula = parse_chemical_formula('In0.9Al0.1As0.9Sb0.1');

