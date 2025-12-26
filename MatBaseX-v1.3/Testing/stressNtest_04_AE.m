close all; clear all; clc;
%% Initializing variables
ATOM_ELE   = read_mpd_elements();           % -- List of all elements  
ATOM_ELE   = ATOM_ELE(1:98);
ATOM_CMP   = read_mpd_compounds();          % -- List of all compounds
MAT_SYMB   = horzcat(ATOM_ELE, ATOM_CMP);  % -- List of all elements & compounds
auger_formalism_list = read_auger_formalisms(); % -- List of all IMFP formalisms
core_levels = read_auger_transitions();
%% Stress Testing: calc_auger()
%% - Random Elements w/o defining auger transitions
close all;
n = 1e2;
for i = 1:n
    element         = string(ATOM_ELE{randi([1, 93], 1)});
    formalism_id    = randi([1, length(auger_formalism_list)], 1);
    hv = 10000 .* rand(1);
    [auger_energy_be, auger_norm_mult, auger_transition] = calc_auger(element, hv, auger_formalism_list{formalism_id});
    % -- Printing Outputs
    fprintf("\nRun: %i / %i \n", i, n);
    fprintf(" Formalism: %s\n", auger_formalism_list{formalism_id});
    fprintf(" Element: %s\n", element);
    for j = 1:length(auger_energy_be)
        fprintf(" -- %s (%.2f eV) \n", auger_transition(j), auger_energy_be(j));
    end
end
%% Stress Testing: view_auger()
close all;
n           = 20;
formula     = {};
for i = 1:n
    material = "";
    gen = randi([1, 5], 1);
    idx = randi([1, length(ATOM_ELE)], 1, gen);
    coeff = randi([1, 5], 1, gen);
    for j = 1:gen
        if mod(j, 2) == 0;  material = sprintf("%s%i", material, coeff(j));
        else;               material = sprintf("%s%s", material, ATOM_ELE{idx(j)});
        end
    end
    roll_dice = rand(1);
    if roll_dice < 0.50;    parity = -1;
    else;                   parity = +1;
    end
    hv = 1000 + 9000*rand(1);
    view_auger(material, hv, parity); 
    fprintf("\n\nMaterial: %s\n", material);
    fprintf(" hv : %.0f eV\n", hv);
end
%% Stress Testing: overlay_auger()
hv = rand(1)*5000;
% -- plot #1
close all; 
figure(); hold on;
overlay_auger(["Si", "Au"], hv, 1);
% -- plot #2 
figure(); hold on;
overlay_auger(["Si", "Au"], hv, 1);