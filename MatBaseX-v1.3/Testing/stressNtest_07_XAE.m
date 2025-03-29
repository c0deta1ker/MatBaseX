close all; clear all; clc;
%% Initializing variables
ATOM_ELE   = read_mpd_elements();           % -- List of all elements  
ATOM_ELE   = ATOM_ELE(1:98);
ATOM_CMP   = read_mpd_compounds();          % -- List of all compounds
MAT_SYMB   = horzcat(ATOM_ELE, ATOM_CMP);  % -- List of all elements & compounds
xae_formalism_list = read_xae_formalisms(); % -- List of all IMFP formalisms
edge_names = read_xae_edges();
%% Stress Testing: calc_xae() & view_xae()
%% - Random Elements w/o defining edges
close all;
n = 1e2;
for i = 1:n
    element         = string(ATOM_ELE{randi([1, 98], 1)});
    formalism_id    = randi([1, length(xae_formalism_list)], 1);
    [edge_energy, edge_name, edge_width, edge_jump] = calc_xae(element, [], xae_formalism_list{formalism_id});
    % -- Printing Outputs
    fprintf("\n\nRun: %i / %i \n", i, n);
    fprintf(" Formalism: %s\n", xae_formalism_list{formalism_id});
    fprintf(" Element: %s\n", element);
    for j = 1:length(edge_energy)
        fprintf(" -- %s \n", edge_name(j));
        fprintf(" --- Energy = %.2f eV \n", edge_energy(j));
        fprintf(" --- Width = %.2f eV \n", edge_width(j));
        fprintf(" --- Jump = %.2f \n", edge_jump(j));
    end
end
%% - Random Elements with edges defined
close all;
n = 1e2;
for i = 1:n
    element             = string(ATOM_ELE{randi([1, 98], 1)});
    num_of_corelevels   = randi([1, 5], 1);
    edgename           = "";
    for j = 1:num_of_corelevels
        edgename(j) = string(edge_names{randi([1, length(edge_names)], 1)});
    end
    formalism_id    = randi([1, length(xae_formalism_list)], 1);
    [edge_energy, edge_name, edge_width, edge_jump] = calc_xae(element, edgename, xae_formalism_list{formalism_id});
    % -- Printing Outputs
    fprintf("\n\nRun: %i / %i \n", i, n);
    fprintf(" Formalism: %s\n", xae_formalism_list{formalism_id});
    fprintf(" Element: %s\n", element);
    for j = 1:length(edge_energy)
        fprintf(" -- %s \n", edge_name(j));
        fprintf(" --- Energy = %.2f eV \n", edge_energy(j));
        fprintf(" --- Width = %.2f eV \n", edge_width(j));
        fprintf(" --- Jump = %.2f \n", edge_jump(j));
    end
end

%% Stress Testing: view_xae()
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
    view_xae(material, parity); 
    fprintf("Material: %s\n", material);
end
%% Stress Testing: overlay_xae()
% -- plot #1
close all; 
figure(); hold on;
overlay_xae(["Si", "Au"], 1);
axis([0, 200, 0, 1]);
% -- plot #2 
figure(); hold on;
overlay_xae(["Si", "Au"], 1, [0, 100]);
axis([0, 200, 0, 1]);