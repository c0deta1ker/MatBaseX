close all; clear all;

%% Modeller 02 - Uniform and Varying Concentration Layer Stack
%% 1    :   Plotting an arbitrary stack
close all; clear all;
lyr_mat         = {"SiO2", "Si"};
lyr_ele         = {"Si", "Si"};
lyr_cls         = {"2p3", "2p3"};
lyr_thick       = {2.0, Inf};
lyr_density     = {[], []};
lyr_exclude     = {};
hv              = 1500:100:10000;
simul_pes_nlayer_intensity(...
    lyr_mat, lyr_ele, lyr_cls, lyr_thick, lyr_density, lyr_exclude,...
    hv, [],[],[],[],[],1);

%% 1    :   Plotting an arbitrary stack
close all; clear all;
lyr_mat         = {"SiO2", "Si"};
lyr_ele         = {"Si", "Si"};
lyr_cls         = {"2p3", "2p3"};
lyr_thick       = {2.0, Inf};
lyr_density     = {[], []};
lyr_exclude     = {};
hv              = 5000;
theta           = 0:5:90;
phi             = 0;
simul_pes_nlayer_intensity(...
    lyr_mat, lyr_ele, lyr_cls, lyr_thick, lyr_density, lyr_exclude,...
    hv, theta,[],[],[],[],1);

%% 1    :   Plotting an arbitrary stack
close all; clear all;
lyr_mat         = {"SiO2", "Si"};
lyr_ele         = {"Si", "Si"};
lyr_cls         = {"2p3", "2p3"};
lyr_thick       = {2.0, Inf};
lyr_density     = {[], []};
lyr_exclude     = {};
hv              = 5000;
theta           = 0;
phi             = 0:5:180;
simul_pes_nlayer_intensity(...
    lyr_mat, lyr_ele, lyr_cls, lyr_thick, lyr_density, lyr_exclude,...
    hv, theta,phi,[],[],[],1);

%% 1    :   Plotting an arbitrary stack
close all; clear all;
lyr_mat         = {"SiO2", "Si"};
lyr_ele         = {"Si", "Si"};
lyr_cls         = {"2p3", "2p3"};
lyr_thick       = {2.0, Inf};
lyr_density     = {[], []};
lyr_exclude     = {};
hv              = 5000;
theta           = 45;
phi             = 45;
simul_pes_nlayer_intensity(...
    lyr_mat, lyr_ele, lyr_cls, lyr_thick, lyr_density, lyr_exclude,...
    hv, theta,phi,[],[],[],1);

%% 3        :    Varying concentration layer
close all;
lyr_mat         = {'SiO2', 'Al', 'Al','In', 'InAs'};
lyr_ele         = {'Si','Al','Al','In','In'};
lyr_cls         = {'2p3','2p3','2p3','3p3','3p3'};
lyr_thick       = {3, 5, 5, 5, Inf};
lyr_density     = {};
lyr_exclude     = {};
hv              = 1500:100:10000;
theta           = 0;
phi             = 0;
simul_pes_nlayer_intensity(...
    lyr_mat, lyr_ele, lyr_cls, lyr_thick, lyr_density, lyr_exclude,...
    hv, theta,phi,[],[],[],1);

%% 3        :    Varying concentration layer
close all;
lyr_mat         = {'SiO2', 'Al', 'Al','In', 'InAs'};
lyr_ele         = {'Si','Al','Al','In','In'};
lyr_cls         = {'2p3','2p3','2p3','3p3','3p3'};
lyr_thick       = {3, 5, 5, 5, Inf};
lyr_density     = {};
lyr_exclude     = {0, 0, 1, 1, 1};
hv              = 1000;
theta           = 0:5:90;
phi             = 0;
simul_pes_nlayer_intensity(...
    lyr_mat, lyr_ele, lyr_cls, lyr_thick, lyr_density, lyr_exclude,...
    hv, theta,phi,[],[],[],1);

%%
eK = 1000;
theta = 0;
lyr_mat         = {'SiO2', 'U', 'Pb','Al', 'InAs'};
lyr_thick       = {3, 6, 5, 5, Inf};
formalism_imfp = "TPP2m";
info_depth = simul_pes_nlayer_info_depth(lyr_mat, lyr_thick, eK, theta, formalism_imfp, 1);



%%
close all;
lyr_mat         = {'SiO2', 'U', 'Pb','Al2O3', 'InAs'};
lyr_thick       = {3, 6, 5, 5, Inf};
fig = simul_pes_nlayer_sample(lyr_mat, lyr_thick);
