close all; clear all; clc;
%% Initializing variables
ATOM_ELE   = read_mpd_elements();           % -- List of all elements  
ATOM_CMP   = read_mpd_compounds();          % -- List of all compounds
MAT_SYMB   = horzcat(ATOM_ELE, ATOM_CMP);  % -- List of all elements & compounds
imfp_formalism_list = read_imfp_formalisms(); % -- List of all IMFP formalisms
%% Stress Testing: calc_imfp() & view_imfp()
close all;
% - Random Photon Energy Entries (Scalar, Row & Column)
n = 1e3;
for i = 1:n
    roll_dice = rand(1);
    if roll_dice < 0.33;        eK = 1e4*rand(1,1e3);
    elseif roll_dice < 0.66;    eK = 1e4*rand(1e3,1);
    else;                       eK = 1e4*rand(1);
    end
    eK                  = sort(eK);
    material            = string(MAT_SYMB{randi([1, length(MAT_SYMB)], 1)});
    formalism           = imfp_formalism_list{randi([1, length(imfp_formalism_list)], 1)}; 
    calc_imfp(eK, formalism, material);
    roll_dice = rand(1);
    if roll_dice < 0.10; view_imfp(material);
    end
    % -- Printing Outputs
    fprintf("\nRun: %i / %i \n", i, n);
    fprintf(" Formalism: %s\n", formalism);
    fprintf(" Material: %s\n", material);
end





