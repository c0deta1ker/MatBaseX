close all; clear all; clc;

%%  1   :   New Read Functions
% -- basic calc functions
element = "Au"; hv = 0;
[auger_energy_be, auger_norm_mult, auger_transition]    = calc_auger(element, hv, [], 1);
[be, cls]                                               = calc_be(element,[],[],1);
[edge_energy, edge_name, edge_width, edge_jump]         = calc_xae(element,[],[],1);
% -- read_formalisms()
form_auger          = read_formalisms('auger');
form_be             = read_formalisms('be');
form_imfp           = read_formalisms('imfp');
form_xae            = read_formalisms('xae');
form_xasf           = read_formalisms('xasf');
form_xsect          = read_formalisms('xsect');
% -- read_spectroscopy_colors()
color_list00        = read_spectroscopy_colors(cls);
color_list11        = read_spectroscopy_colors(auger_transition);
color_list22        = read_spectroscopy_colors(edge_name);
% -- read_spectroscopy_element_data()
atom_table_be           = read_spectroscopy_element_data('be',[]);
atom_table_auger        = read_spectroscopy_element_data('auger',[]);
atom_table_xae          = read_spectroscopy_element_data('xae','');
atom_table_xsect        = read_spectroscopy_element_data('xsect',"");
si_atom_table_be        = read_spectroscopy_element_data('be','Au');
si_atom_table_auger     = read_spectroscopy_element_data('auger','Au');
si_atom_table_xae       = read_spectroscopy_element_data('xae','Au');
si_atom_table_xsect     = read_spectroscopy_element_data('xsect','Au');

%%  2   :   New plt_result_x() Functions
%% 2.1  --  AUGER
close all;
element = "Au";
formalismList   = read_formalisms('auger');
for i = 1:length(formalismList)
    calc_auger(element, 0, formalismList{i}, 1);
    calc_auger(element, 2500, formalismList{i}, 1);
end
%% 2.2  --  XAE
close all;
formalismList   = read_formalisms('xae');
for i = 1:length(formalismList)
    calc_xae("Au", [], formalismList{i}, 1);
end
%% 2.3  --  BE
close all;
formalismList   = read_formalisms('be');
for i = 1:length(formalismList)
    calc_be("Au",[],formalismList{i}, 1);
end
%% 2.4  --  XSECT
close all;
formalismList   = read_formalisms('xsect');
%% 2.4.1 : Sigma
close all;
hv = 1000:2000:50000;
for i = 1:length(formalismList)
    calc_xsect_sigma(hv, "Au", [], formalismList{i}, 1, 1);
end
%% 2.4.2 : XSECT-Beta
close all;
hv = 1000:2000:50000;
for i = 1:length(formalismList)
    calc_xsect_beta(hv, "Au", [], formalismList{i}, 1, 1);
end
%% 2.4.3 : XSECT-Gamma
close all;
hv = 2500:250:6500;
for i = 1:length(formalismList)
    calc_xsect_gamma(hv, "Au", [], formalismList{i}, 1, 1);
end
%% 2.4.4 : XSECT-Delta
close all;
hv = 2500:250:6500;
for i = 1:length(formalismList)
    calc_xsect_delta(hv, "Au", [], formalismList{i}, 1, 1);
end
%% 2.5  --  XASF
close all;
hv = 1000:50:6500;
formalismList   = read_formalisms('xasf');
for i = 1:length(formalismList)
    calc_xasf(hv, "Au", formalismList{i}, 1, 1);
    calc_xasf(hv, "InAs", formalismList{i}, 1, 1);
end
%% 2.6  --  XSECT - ANGULAR ANISO
close all;
hv              = 650;
element         = "Au";
corelevel       = "4f7";
theta           = 0:5:90;
phi             = 0;
extrapolate     = 1;
plot_results    = 1;
calc_xsect_angle_aniso_Fadj(hv, element, corelevel, theta, phi, extrapolate, plot_results);
calc_xsect_angle_aniso_FL(hv, element, corelevel, theta, phi, extrapolate, plot_results);
calc_xsect_angle_aniso_FP(hv, element, corelevel, theta, phi, 1, extrapolate, plot_results);
calc_xsect_angle_aniso_FU(hv, element, [], theta, extrapolate, plot_results);

%%  3   :   New view() Functions


