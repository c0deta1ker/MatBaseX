close all; clear all; clc;
%% Initializing variables
ATOM_ELE   = read_mpd_elements();           % -- List of all elements  
ATOM_CMP   = read_mpd_compounds();          % -- List of all compounds
MAT_SYMB   = horzcat(ATOM_ELE, ATOM_CMP);   % -- List of all elements & compounds
ATOM_CL    = read_be_core_levels();         % -- Defining core-levels
%% Stress Testing: Angular Anisotropy
close all;
% - Random Photon Energy Entries (Scalar, Row & Column)
n = 1e2;
for i = 1:n
    roll_dice = rand(1);
    if roll_dice < 0.33;        hv = 1e4*rand(1,20);
    elseif roll_dice < 0.66;    hv = 1e4*rand(20,1);
    else;                       hv = 1e4*rand(1);
    end
    hv                  = sort(hv);
    element             = string(ATOM_ELE{randi([1, 98], 1)});
    num_of_corelevels   = randi([1, 5], 1);
    corelevel           = "";
    for j = 1:num_of_corelevels
        corelevel(j)    = string(ATOM_CL{randi([1, length(ATOM_CL)], 1)});
    end
    roll_dice = rand(1);
    if roll_dice < 0.25; corelevel = []; end
    roll_dice = rand(1);
    if roll_dice < 0.33;        theta = 90*rand(1,30);
    elseif roll_dice < 0.66;    theta = 90*rand(30,1);
    else;                       theta = 90*rand(1);
    end
    if roll_dice < 0.33;        phi = 90*rand(1,30);
    elseif roll_dice < 0.66;    phi = 90*rand(30,1);
    else;                       phi = 90*rand(1);
    end
    plot_results         = round(rand(1),0);
    roll_dice = rand(1);
    if roll_dice < 0.25
        formalism = "Fadj";
        Fadj = calc_xsect_angle_aniso_Fadj(hv, element, corelevel, theta, plot_results);
    elseif roll_dice < 0.50
        formalism = "FL";
        FL = calc_xsect_angle_aniso_FL(hv, element, corelevel, theta, phi, plot_results);
    elseif roll_dice < 0.75
        formalism = "FP";
        P = rand(1);
        FP = calc_xsect_angle_aniso_FP(hv, element, corelevel, theta, phi, P, plot_results);
    else
        formalism = "FU";
        FU = calc_xsect_angle_aniso_FU(hv, element, corelevel, theta, plot_results);
    end
    % -- Printing Outputs
    fprintf("\nRun: %i / %i \n", i, n);
    fprintf(" Formalism: %s\n", formalism);
    fprintf(" Element: %s\n", element);
    fprintf(" Core-Levels: %i \n", num_of_corelevels);
end