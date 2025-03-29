close all; clear all; clc;
%% Initializing variables
ATOM_ELE   = read_mpd_elements();           % -- List of all elements  
ATOM_ELE   = ATOM_ELE(1:98);
ATOM_CMP   = read_mpd_compounds();          % -- List of all compounds
MAT_SYMB   = horzcat(ATOM_ELE, ATOM_CMP);  % -- List of all elements & compounds
be_formalism_list = read_be_formalisms(); % -- List of all IMFP formalisms
core_levels = read_be_core_levels();
%% Stress Testing: calc_be() & view_be()
%% - Random Elements w/o defining core-levels
close all;
n = 2e3;
for i = 1:n
    element         = string(ATOM_ELE{randi([1, 98], 1)});
    formalism_id    = randi([1, length(be_formalism_list)], 1);
    [be, cls]       = calc_be(element, [], be_formalism_list{formalism_id});
    % -- Printing Outputs
    fprintf("\nRun: %i / %i \n", i, n);
    fprintf(" Formalism: %s\n", be_formalism_list{formalism_id});
    fprintf(" Element: %s\n", element);
    for j = 1:length(be)
        fprintf(" -- %s (%.2f eV) \n", cls(j), be(j));
    end
end
%% - Random Elements with Core-levels defined
close all;
n = 2e3;
for i = 1:n
    element             = string(ATOM_ELE{randi([1, 98], 1)});
    num_of_corelevels   = randi([1, 10], 1);
    corelevel           = "";
    for j = 1:num_of_corelevels
        corelevel(j) = string(core_levels{randi([1, length(core_levels)], 1)});
    end
    formalism_id    = randi([1, length(be_formalism_list)], 1);
    [be, cls]       = calc_be(element, corelevel, be_formalism_list{formalism_id});
    % -- Printing Outputs
    fprintf("\nRun: %i / %i \n", i, n);
    fprintf(" Formalism: %s\n", be_formalism_list{formalism_id});
    fprintf(" Element: %s\n", element);
    fprintf(" Core-Levels: %i \n", num_of_corelevels);
    for j = 1:num_of_corelevels
        fprintf(" -- %s (%.2f eV) \n", cls(j), be(j));
    end
end

%% Stress Testing: find_be_top_matches()
%% - Random binding energies between 0 - 100000 eV
close all;
n = 20;
for i = 1:n
    binding_energy      = 100000*rand(1);
    top_matches         = calc_be_top_matches(binding_energy, 1);
end
%% Stress Testing: view_be()
close all;
n           = 50;
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
    view_be(material, hv, parity); 
    fprintf("\n\nMaterial: %s\n", material);
    fprintf(" hv : %.0f eV\n", hv);
end
%% Stress Testing: overlay_be()
% -- plot #1
close all; 
figure(); hold on;
overlay_be(["Si", "Au"], 1);
axis([0, 200, 0, 1]);
% -- plot #2 
figure(); hold on;
overlay_be(["Si", "Au"], 1, [0, 100]);
axis([0, 200, 0, 1]);