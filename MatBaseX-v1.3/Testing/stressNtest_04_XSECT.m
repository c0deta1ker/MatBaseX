close all; clear all; clc;
%% Initializing variables
ATOM_ELE   = read_mpd_elements();           % -- List of all elements  
ATOM_CMP   = read_mpd_compounds();          % -- List of all compounds
MAT_SYMB   = horzcat(ATOM_ELE, ATOM_CMP);  % -- List of all elements & compounds
ATOM_CL    = read_be_core_levels();       % -- Defining core-levels
formalisms = read_xsect_formalisms(); % -- List of all XSECT formalisms
%% Stress Testing: General
close all;
% - Random Photon Energy Entries (Scalar, Row & Column)
n = 100;
for i = 1:n
    roll_dice = rand(1);
    if roll_dice < 0.33;        hv = 1.0e4*rand(1,50);
    elseif roll_dice < 0.66;    hv = 1.0e4*rand(50,1);
    else;                       hv = 1.0e4*rand(1);
    end
    hv                  = sort(hv+500);
    element             = string(ATOM_ELE{randi([1, 98], 1)});
    num_of_corelevels   = randi([1, 10], 1);
    corelevel           = "";
    for j = 1:num_of_corelevels
        corelevel(j)    = string(ATOM_CL{randi([1, length(ATOM_CL)], 1)});
    end
    plot_result         = round(rand(1),0);
    extrapolate         = round(rand(1),0);
    form                = formalisms{randi([1, 4], 1)};
    [sigma, beta, gamma, delta] = calc_xsect(hv, element, corelevel, form, extrapolate, plot_result);
    % -- Printing Outputs
    fprintf("\nRun: %i / %i \n", i, n);
    fprintf(" Formalism: Cant(2022)\n");
    fprintf(" Element: %s\n", element);
    fprintf(" Core-Levels: %i \n", num_of_corelevels);
    if roll_dice > 0.66
        for j = 1:num_of_corelevels
            fprintf(" -- sigma: %s (%.4e barn/atom) \n", corelevel(j), sigma(j));
            fprintf(" -- beta: %s (%.4e) \n", corelevel(j), beta(j));
            fprintf(" -- gamma: %s (%.4e) \n", corelevel(j), gamma(j));
            fprintf(" -- delta: %s (%.4e) \n", corelevel(j), delta(j));
        end
    end
end
%% Stress Testing: Scofield
close all;
% - Random Photon Energy Entries (Scalar, Row & Column)
n = 3e2;
for i = 1:n
    roll_dice = rand(1);
    if roll_dice < 0.33;        hv = 1e6*rand(1,50);
    elseif roll_dice < 0.66;    hv = 1e6*rand(50,1);
    else;                       hv = 1e6*rand(1);
    end
    hv                  = sort(hv);
    element             = string(ATOM_ELE{randi([1, 98], 1)});
    num_of_corelevels   = randi([1, 10], 1);
    corelevel           = "";
    for j = 1:num_of_corelevels
        corelevel(j)    = string(ATOM_CL{randi([1, length(ATOM_CL)], 1)});
    end
    extrapolate         = round(rand(1),0);
    plot_result         = round(rand(1),0);
    xsect               = calc_xsect_sigma_scof1973(hv, element, corelevel, extrapolate, plot_result);
    % -- Printing Outputs
    fprintf("\nRun: %i / %i \n", i, n);
    fprintf(" Formalism: Scofield(1973)\n");
    fprintf(" Element: %s\n", element);
    fprintf(" Core-Levels: %i \n", num_of_corelevels);
    for j = 1:num_of_corelevels
        fprintf(" -- %s (%.4e barn/atom) \n", corelevel(j), xsect(j));
    end
end
%% Stress Testing: Yeh & Lindau
close all;
% - Random Photon Energy Entries (Scalar, Row & Column)
n = 3e2;
for i = 1:n
    roll_dice = rand(1);
    if roll_dice < 0.33;        hv = 2e3*rand(1,50);
    elseif roll_dice < 0.66;    hv = 2e3*rand(50,1);
    else;                       hv = 2e3*rand(1);
    end
    hv                  = sort(hv+20);
    element             = string(ATOM_ELE{randi([1, 98], 1)});
    num_of_corelevels   = randi([1, 10], 1);
    corelevel           = "";
    for j = 1:num_of_corelevels
        corelevel(j)    = string(ATOM_CL{randi([1, length(ATOM_CL)], 1)});
    end
    extrapolate         = round(rand(1),0);
    plot_result         = round(rand(1),0);
    roll_dice = rand(1);
    if roll_dice < 0.50;        xsect = calc_xsect_sigma_yehlind1985(hv, element, corelevel, extrapolate, plot_result);
    else;                       xsect = calc_xsect_beta_yehlind1985(hv, element, corelevel, extrapolate, plot_result);
    end
    % -- Printing Outputs
    fprintf("\nRun: %i / %i \n", i, n);
    fprintf(" Formalism: Yeh&Lindau(1985)\n");
    fprintf(" Element: %s\n", element);
    fprintf(" Core-Levels: %i \n", num_of_corelevels);
    for j = 1:num_of_corelevels
        if roll_dice < 0.50;    fprintf(" -- %s (sigma:%.4e barn/atom) \n", corelevel(j), xsect(j));
        else;                   fprintf(" -- %s (beta: %.4f) \n", corelevel(j), xsect(j));
        end
    end
end
%% Stress Testing: Trzhaskovskaya
close all;
% - Random Photon Energy Entries (Scalar, Row & Column)
n = 3e2;
for i = 1:n
    roll_dice = rand(1);
    if roll_dice < 0.33;        hv = 1.2e4*rand(1,50);
    elseif roll_dice < 0.66;    hv = 1.2e4*rand(50,1);
    else;                       hv = 1.2e4*rand(1);
    end
    hv                  = sort(hv+500);
    element             = string(ATOM_ELE{randi([1, 98], 1)});
    num_of_corelevels   = randi([1, 10], 1);
    corelevel           = "";
    for j = 1:num_of_corelevels
        corelevel(j)    = string(ATOM_CL{randi([1, length(ATOM_CL)], 1)});
    end
    extrapolate         = round(rand(1),0);
    plot_result         = round(rand(1),0);
    roll_dice = rand(1);
    if roll_dice < 0.25;            xsect = calc_xsect_sigma_trzh2018(hv, element, corelevel, extrapolate, plot_result);
    elseif roll_dice < 0.50;        xsect = calc_xsect_beta_trzh2018(hv, element, corelevel, extrapolate, plot_result);
    elseif roll_dice < 0.75;        xsect = calc_xsect_gamma_trzh2018(hv, element, corelevel, extrapolate, plot_result);
    else;                           xsect = calc_xsect_delta_trzh2018(hv, element, corelevel, extrapolate, plot_result);
    end
    % -- Printing Outputs
    fprintf("\nRun: %i / %i \n", i, n);
    fprintf(" Formalism: Trzhaskovskaya(2018)\n");
    fprintf(" Element: %s\n", element);
    fprintf(" Core-Levels: %i \n", num_of_corelevels);
    for j = 1:num_of_corelevels
        if roll_dice < 0.25;            fprintf(" -- %s (sigma:%.4e barn/atom) \n", corelevel(j), xsect(j));
        elseif roll_dice < 0.50;        fprintf(" -- %s (beta: %.4f) \n", corelevel(j), xsect(j));
        elseif roll_dice < 0.75;        fprintf(" -- %s (gamma: %.4f) \n", corelevel(j), xsect(j));
        else;                           fprintf(" -- %s (delta: %.4f) \n", corelevel(j), xsect(j));
        end
    end
end
%% Stress Testing: Cant
close all;
% - Random Photon Energy Entries (Scalar, Row & Column)
n = 100;
for i = 1:n
    roll_dice = rand(1);
    if roll_dice < 0.33;        hv = 1.0e4*rand(1,50);
    elseif roll_dice < 0.66;    hv = 1.0e4*rand(50,1);
    else;                       hv = 1.0e4*rand(1);
    end
    hv                  = sort(hv+500);
    element             = string(ATOM_ELE{randi([1, 98], 1)});
    num_of_corelevels   = randi([1, 10], 1);
    corelevel           = "";
    for j = 1:num_of_corelevels
        corelevel(j)    = string(ATOM_CL{randi([1, length(ATOM_CL)], 1)});
    end
    plot_result         = round(rand(1),0);
    roll_dice           = rand(1);
    if roll_dice < 0.25;            xsect = calc_xsect_sigma_cant2022(hv, element, corelevel, plot_result);
    elseif roll_dice < 0.50;        xsect = calc_xsect_beta_cant2022(hv, element, corelevel, plot_result);
    elseif roll_dice < 0.75;        xsect = calc_xsect_gamma_cant2022(hv, element, corelevel, plot_result);
    else;                           xsect = calc_xsect_delta_cant2022(hv, element, corelevel, plot_result);
    end
    % -- Printing Outputs
    fprintf("\nRun: %i / %i \n", i, n);
    fprintf(" Formalism: Cant(2022)\n");
    fprintf(" Element: %s\n", element);
    fprintf(" Core-Levels: %i \n", num_of_corelevels);
    for j = 1:num_of_corelevels
        if roll_dice < 0.25;            fprintf(" -- %s (sigma:%.4e barn/atom) \n", corelevel(j), xsect(j));
        elseif roll_dice < 0.50;        fprintf(" -- %s (beta: %.4f) \n", corelevel(j), xsect(j));
        elseif roll_dice < 0.75;        fprintf(" -- %s (gamma: %.4f) \n", corelevel(j), xsect(j));
        else;                           fprintf(" -- %s (delta: %.4f) \n", corelevel(j), xsect(j));
        end
    end
end
%% - Current Breakdowns
