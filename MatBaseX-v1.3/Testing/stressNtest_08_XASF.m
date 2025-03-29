close all; clear all; clc;
%% Initializing variables
ATOM_SYMB   = read_mpd_elements();      % -- Defining all possible elements
ATOM_SYMB   = ATOM_SYMB(1:92);
COMP_SYMB   = read_mpd_compounds();     % -- Defining all possible compounds
MAT_SYMB    = horzcat(ATOM_SYMB, COMP_SYMB);% -- List of all materials
ATOM_CL     = read_be_core_levels();       % -- Defining core-levels
FORMS       = ["Henke1993", "NIST2005"];
%% Stress Testing: calc_xasf()
close all;
% - Random Photon Energy Entries (Scalar, Row & Column)
n = 3e2;
for i = 1:n
    roll_dice = rand(1);
    if roll_dice < 0.33;        hv = 1e8*rand(1,1e3);
    elseif roll_dice < 0.66;    hv = 1e4*rand(1e3,1);
    else;                       hv = 1e4*rand(1);
    end
    hv                  = sort(hv);
    material            = string(MAT_SYMB{randi([1, length(MAT_SYMB)], 1)});
    extrapolate         = round(rand(1),0);
    plot_results        = round(rand(1),0);
    formalism           = FORMS(randi([1, 2], 1));
    [f1, f2] = calc_xasf(hv, material, formalism, extrapolate, plot_results);
    % -- Printing Outputs
    fprintf("\nRun: %i / %i \n", i, n);
    fprintf(" Formalism: %s\n", formalism);
    fprintf(" Material: %s\n", material);
end