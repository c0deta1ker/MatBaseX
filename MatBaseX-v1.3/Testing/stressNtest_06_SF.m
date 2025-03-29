close all; clear all; clc;
%% Initializing variables
ATOM_SYMB   = generate_mat_elements();      % -- Defining all possible elements
ATOM_CL     = generate_core_levels();       % -- Defining core-levels
xsect_formalisms        = {"S1973", "YL1985", "T2018", "C2022"};
imfp_formalisms         = ["Universal","TPP2M","TPP2M-avg","Optical","S1","S2","S3","S3O","S4","JTP"];
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
    if roll_dice < 0.33;        theta = 1.0e4*rand(1,50);
    elseif roll_dice < 0.66;    theta = 1.0e4*rand(50,1);
    else;                       theta = 1.0e4*rand(1);
    end
    if roll_dice < 0.33;        phi = 1.0e4*rand(1,50);
    elseif roll_dice < 0.66;    phi = 1.0e4*rand(50,1);
    else;                       phi = 1.0e4*rand(1);
    end
    hv                  = sort(hv+500);
    theta               = sort(theta);
    phi                 = sort(phi);
    element             = string(ATOM_SYMB{randi([1, 98], 1)});
    num_of_corelevels   = rand(1);
    corelevel           = string(ATOM_CL{randi([1, length(ATOM_CL)], 1)});
    formalism_xsect     = xsect_formalisms{randi([1, length(xsect_formalisms)], 1)};
    formalism_imfp      = imfp_formalisms{randi([1, length(imfp_formalisms)], 1)};
    P = rand(1);
    % -- Printing Outputs
    fprintf("\nRun: %i / %i \n", i, n);
    fprintf(" XSect Formalism: %s\n", formalism_xsect);
    fprintf(" IMFP Formalism: %s\n", formalism_imfp);
    fprintf(" Element: %s\n", element);
    fprintf(" Core-Levels: %i \n", num_of_corelevels);
    fprintf(" P: %.2f \n", P);
    fprintf(" hv: %.i \n", length(hv));
    fprintf(" theta: %.i \n", length(theta));
    fprintf(" phi: %.i \n", length(phi));
    calc_sf([], element, corelevel, hv, theta, phi, P, formalism_xsect, formalism_imfp);
end
%% -- Current Tests
close all;
material = "Si";
element = "Si";
corelevel = "1s1"; hv = 10000;
% corelevel = "2p3"; hv = 5000;
theta   = linspace(0,90,1e2);
phi     = linspace(0,360,1e2)';
P = 1;
% SF = calc_sf(material, element, corelevel, hv, theta, phi, P, "Scofield1973");
% SF = calc_sf(material, element, corelevel, hv, theta, phi, P, "YehLindau1985");
% SF = calc_sf(material, element, corelevel, hv, theta, phi, P, "Trz");
SF = calc_sf(material, element, corelevel, hv, theta, phi, P, "Cant2022");
X = theta .* cos(deg2rad(phi));
Y = theta .* sin(deg2rad(phi));
figure(); 
hold on; grid on; grid minor;
ImData(X, Y, SF);
contour(X, Y, SF, 5, 'w');
colorbar();
axis square;
axis([-90, 90, -90, 90]);
yline(0, 'r:', 'LineWidth', 1);
xline(0, 'r:', 'LineWidth', 1);

figure(); 
hold on; grid on; grid minor;
ImData(theta, phi, SF);
contour(theta, phi, SF, 5, 'w');
colorbar();
axis equal;
axis([0, 90, 0, 360]);
yline(0, 'r:', 'LineWidth', 1);
xline(0, 'r:', 'LineWidth', 1);


