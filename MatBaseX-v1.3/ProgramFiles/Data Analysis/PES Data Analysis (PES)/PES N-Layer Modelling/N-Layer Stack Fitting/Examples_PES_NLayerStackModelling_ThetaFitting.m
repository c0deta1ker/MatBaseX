%% 1    :   Optimization function for all layers
close all; clear all;
%% 1.1    :   Creating some artificial data
lyr_mat         = {'SiO2', 'Si', 'As', 'Si'}; 
lyr_thick       = {1.0, 0.5, 1.0, Inf};
lyr_ele         = {'Si', 'Si', 'As', 'Si'};
lyr_cls         = {'2p3', '2p3', '3p3', '2p3'};
hv              = 2500;
theta           = 0:5:60;
temp_pes_data    = nlayer_model01_run(lyr_mat, lyr_thick, lyr_ele, lyr_cls, hv, theta);
for i = 1:temp_pes_data.Nlyrs
    temp_pes_data.lyr_Inorm{i} =  0.05 .* (rand(size(temp_pes_data.lyr_Inorm{i})) - 0.5) + temp_pes_data.lyr_Inorm{i};
end
nlayer_model01_view(temp_pes_data); temp_pes_data
% -- Creating a data-structure that contains the data
xpsDat          = struct();
xpsDat.xdat     = temp_pes_data.theta;
xpsDat.ydat   	= cell2mat(temp_pes_data.lyr_Inorm');
%% 1.2    :   Initialising the model to be fitted
close all;
% -- Defining the sample and experimental conditions
modelDat            = struct();
modelDat.lyr_mat    = lyr_mat; 
modelDat.lyr_ele    = lyr_ele;
modelDat.lyr_cls    = lyr_cls;
modelDat.hv         = 2500;
modelDat.theta      = 0:0.2:90;
modelDat.phi        = 0.0;
modelDat.P          = 0.5;
modelDat.formalism_xsect = 'Cant2022';
modelDat.formalism_imfp  = 'S2';
% -- Defining the fit parameters
THICKNESS   = cell2mat(lyr_thick) + 0.95 .* (rand(size(lyr_thick)) - 0.5);
iparams{1} = [THICKNESS(1:end-1)]; 
iparams{1}
% -- Lower bounds
iparams{2}      = iparams{1} - 1.0; 
iparams{2}
% -- Upper bounds
iparams{3}      = iparams{1} + 1.0; 
iparams{3}
% -- Preview the initial conditions of the model vs data
close all;
nlayer2pes_full_theta_solver_view_init(xpsDat, modelDat, iparams);
%% 1.3    :   Running the optimization algorithm
close all; 
solve_type = 'fmincon';
fitStr_01 = nlayer2pes_full_theta_solver(xpsDat, modelDat, iparams, solve_type); fitStr_01
nlayer2pes_full_theta_solver_view_fit(fitStr_01);
%% 1.4    :   Running the optimization algorithm and finding the best solution after 10 runs
close all; 
solve_type = 'fmincon';
n_runs = 10;
[fitStr_02, statStr_02] = nlayer2pes_full_theta_solver_n_runs(xpsDat, modelDat, iparams, solve_type, n_runs); fitStr_02
nlayer2pes_full_theta_solver_view_fit(fitStr_02);
statStr_02

%% 2    :   Optimization function for partial layer fitting
close all; clear all;
which_layers = [2, 4];
%% 2.1    :   Creating some artificial data
lyr_mat         = {'SiO2', 'Si', 'As', 'Si'}; 
lyr_thick       = {1.0, 0.5, 1.0, Inf};
lyr_ele         = {'Si', 'Si', 'As', 'Si'};
lyr_cls         = {'2p3', '2p3', '3p3', '2p3'};
hv              = 2500;
theta           = 0:5:60;
temp_pes_data    = nlayer_pes_model(lyr_mat, lyr_thick, lyr_ele, lyr_cls, hv, theta);
for i = 1:temp_pes_data.Nlyrs
    temp_pes_data.lyr_Inorm{i} =  0.02 .* (rand(size(temp_pes_data.lyr_Inorm{i})) - 0.5) + temp_pes_data.lyr_Inorm{i};
end
view_nlayer_pes_model(temp_pes_data); temp_pes_data
% -- Creating a data-structure that contains the data
xpsDat          = struct();
xpsDat.xdat     = temp_pes_data.theta;
xpsDat.ydat   	= cell2mat(temp_pes_data.lyr_Inorm');
xpsDat.ydat     = xpsDat.ydat(which_layers,:);
xpsDat.ydat     = xpsDat.ydat ./ sum(xpsDat.ydat, 1);
%% 2.2    :   Initialising the model to be fitted
close all;
% -- Defining the sample and experimental conditions
modelDat            = struct();
modelDat.lyr_mat    = lyr_mat; 
modelDat.lyr_ele    = lyr_ele;
modelDat.lyr_cls    = lyr_cls;
modelDat.hv         = 2500;
modelDat.theta      = 0:0.2:90;
modelDat.phi        = 0.0;
modelDat.P          = 0.5;
modelDat.formalism_xsect = 'Cant2022';
modelDat.formalism_imfp  = 'S2';
% -- Defining the fit parameters
% -- ideal thickness: [1, 0.5, 1]
THICKNESS   = cell2mat(lyr_thick) + 0.95 .* (rand(size(lyr_thick)) - 0.5);
iparams{1} = [THICKNESS(1:end-1)]; 
iparams{1}
% -- Lower bounds
iparams{2}      = iparams{1} - 1.0; 
iparams{2}
% -- Upper bounds
iparams{3}      = iparams{1} + 1.0; 
iparams{3}
% -- Preview the initial conditions of the model vs data
close all;
nlayer2pes_partial_theta_solver_view_init(xpsDat, modelDat, iparams, which_layers);
%% 2.3    :   Running the optimization algorithm
close all; 
solve_type = 'fmincon';
fitStr_03 = nlayer2pes_partial_theta_solver(xpsDat, modelDat, iparams, which_layers, solve_type); fitStr_03
nlayer2pes_partial_theta_solver_view_fit(fitStr_03);
%% 2.4    :   Running the optimization algorithm and finding the best solution after 10 runs
close all; 
solve_type = 'fmincon';
n_runs = 10;
[fitStr_04, statStr_04] = nlayer2pes_partial_theta_solver_n_runs(xpsDat, modelDat, iparams, which_layers, solve_type, n_runs);
nlayer2pes_partial_theta_solver_view_fit(fitStr_04);
statStr_04