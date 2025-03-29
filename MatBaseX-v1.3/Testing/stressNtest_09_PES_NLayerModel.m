close all; clear all; clc;
%% Initializing variables
ATOM_ELE    = read_mpd_elements();           % -- List of all elements  
ATOM_ELE    = ATOM_ELE(1:92);
ATOM_CMP    = read_mpd_compounds();          % -- List of all compounds
MAT_SYMB    = horzcat(ATOM_ELE, ATOM_CMP);   % -- List of all elements & compounds
%% Stress Testing: N-Layer Modelling
close all;
n = 1e2;
for i = 1:n
    % -- Extracting material stack parameters
    lyr_mat = {};
    Nlyrs       = randi([1, 10], 1);
    for j = 1:Nlyrs
        lyr_mat{j}      = string(MAT_SYMB{randi([1, length(MAT_SYMB)], 1)});
        formula         = parse_chemical_formula(lyr_mat{j});
        vformula        = formula(randi([1, length(formula)], 1));
        lyr_ele{j}      = vformula.element;
        [be, cls]       = calc_be(vformula.element);
        lyr_cls{j}      = cls(randi([1, length(cls)], 1));
        lyr_thick{j}    = 10*rand(1);
    end
    lyr_density     = {};
    lyr_exclude     = {};
    fig = simul_pes_nlayer_sample(lyr_mat, lyr_thick);
    % -- Extracting experimental geometry parameters
    roll_dice = rand(1);
    if roll_dice < 0.33;        hv = 1e4*rand(1,20);    theta = 90*rand(1);     phi = 90*rand(1);
    elseif roll_dice < 0.66;    hv = 1e4*rand(1);       theta = 90*rand(1,30);  phi = 90*rand(1);
    else;                       hv = 1e4*rand(1);       theta = 90*rand(1);     phi = 90*rand(1,30);
    end
    hv      = sort(hv);
    theta   = sort(theta);
    phi     = sort(phi);
    P = rand(1);
    % -- Defining formalisms to use
    imfp_formalisms = read_imfp_formalisms();
    formalism_imfp  = imfp_formalisms(randi([1, length(imfp_formalisms)], 1));
    xsect_formalisms = read_xsect_formalisms();
    formalism_xsect  = xsect_formalisms(randi([1, length(xsect_formalisms)], 1));
    roll_dice = rand(1);
    if roll_dice < 0.20;    plot_result = 1;
    else;                   plot_result = 0;
    end
    % -- Running Simulations
    ke = 500 + 5e3*rand(1); thtM = 80*rand(1);
    [info_depth, lyr_depth, lyr_Int0] = simul_pes_nlayer_info_depth(lyr_mat, lyr_thick, ke, thtM, formalism_imfp, 1);
    [lyr_I, lyr_Inorm] = simul_pes_nlayer_intensity(...
        lyr_mat, lyr_ele, lyr_cls, lyr_thick, lyr_density, lyr_exclude,...
        hv, theta,phi,P,formalism_xsect,formalism_imfp,plot_result);
    pause(1);
end
%% Current Breakdowns
