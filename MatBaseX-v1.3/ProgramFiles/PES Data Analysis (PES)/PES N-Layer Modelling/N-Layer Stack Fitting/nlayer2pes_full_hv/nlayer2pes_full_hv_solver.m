function fitStr = nlayer2pes_full_hv_solver(xpsDat, modelDat, iparams, solve_type)
% fitStr = nlayer2pes_full_hv_solver(xpsDat, modelDat, iparams, solve_type)
%   Function that runs an optimisation algorithm to solve for the best fit
%   model sample stack of photoelectron intensities. This function requires 
%   that the user has XPS data on the full sample stack, with photoelectron 
%   intensites that originate from all layers in the sample stack.
%   
%   IN:
%   -   xpsDat:         data structure that contains the XPS data.
%           .xdat                   Nx1 column vector of the XPS photon energy domain (eV).
%           .ydat                   Nx1 column vector of the XPS normalised photoelectron intensities.
%   -   modelDat:       data structure that contains the Model PES data from a defined sample stack.
%           .lyr_mat:  	            Mx1 cell-vector of the material for each layer in the stack; e.g. "Si", "SiO2", "Al2O3"...
%           .lyr_thick:	            Mx1 cell-vector of the thickness of each layer in the stack (nm)
%           .lyr_ele:               Mx1 cell-vector of strings of the element to be probed; e.g. "H", "He", "Si", "In"...
%           .lyr_cls:  	            Mx1 cell-vector of strings of the core-level to be probed; e.g. "5s1", "5p1", "5p3", "5d3", "5d5", "5f5', "5f7"...
%           .hv:                    scalar or N×1 vector of the incident photon energies [eV]
%           .theta:                 scalar of the polar angle between the photoelectron vector relative to electric field vector (i.e. at normal emission: LV (p-pol, E//MP) = 0, LH (s-pol, E⊥MP) = 90) [degree]
%           .phi:                   scalar of the azimuthal angle between the photon momentum vector relative to the projection of the photoelectron vector on to the plane perpendicular to the electric field vector (i.e. normal emission = 0) [degree]
%           .P:                     scalar of degree of polarization, where 1 or 0 is equivalent to full linear polarization, and 0.5 is equivalent to unpolarized light.
%           .formalism_xsect:       string of the photoionization cross-section formalism to use. Default:"Cant2022" ["Cant2022","YehLindau1985","Trzhaskovskaya2018","Cant2022"]
%           .formalism_imfp:        string for imfp calculator formalism. Default:"S2" ["Universal","TPP2M","TPP2M-avg","Optical","S1","S2","S3","S3-organic","S4"]
%   -   iparams:        3 cells {x0}{lb}{ub} with Mx1 vectors of the initial guess layer thicknesses (nm)
%   -   solve_type:     string of the optimisation algorithm to use; "fmincon" (good constrained fit), "fminunc" (good unconstrained fit), "lsqnonlin" (quick fit, not so good), "simulannealbnd" (slow, best). 
%
%   OUT:
%   -   fitStr:         MATLAB data-structure that contains all the fit parameters / variables / information

%% -- Default parameters
if nargin < 4; solve_type = "fmincon"; end
if isempty(solve_type); solve_type = "fmincon"; end
%% 1    :   Extracting all data and information
% -- Extracting the xps data
X       = xpsDat.xdat;
D       = xpsDat.ydat;
% -- Extracting the defined model sample
lyr_mat         = modelDat.lyr_mat;
lyr_ele         = modelDat.lyr_ele;
lyr_cls         = modelDat.lyr_cls;
hv              = modelDat.hv;
theta           = modelDat.theta;
phi             = modelDat.phi;
P               = modelDat.P;
formalism_xsect = modelDat.formalism_xsect;
formalism_imfp  = modelDat.formalism_imfp;
% -- Extracting the layer thicknesses
lyr_thick       = [iparams{1}, Inf];
% -- Extracting the PES model data
pes_model       = nlayer_pes_model(lyr_mat, lyr_thick, lyr_ele, lyr_cls, X, theta, phi, P, formalism_xsect, formalism_imfp);
M   = cell2mat(pes_model.lyr_Inorm);
%% 2    :   Determination of the residuals and chi-squared
R           = M - D;                        % Residuals
CHISQ       = sum(R.^2 ./ std(R).^2, 2);	% Chi-squared
%% 3    :   Constraining the fit parameters to physical values
% -- Defining the initial conditions and limits of the optimisation method
x0 = [iparams{1}(:)]; x0(x0 < 0) = 0;
lb = [iparams{2}(:)]; lb(lb < 0) = 0;
ub = [iparams{3}(:)]; ub(ub < 0) = 0;
% -- Determining the degrees of freedom for the fitting model
val	= lb + (ub-lb); DoF = 0;
for i = 1:length(val); if val(i) ~= lb(i); DoF = DoF + 1; end; end
%% 4    :   Defining the XPS data object and fitting arguments
XPSObj              = struct();
XPSObj.xpsDat       = xpsDat;
XPSObj.modelDat     = modelDat;
XPSObj.X            = X;
XPSObj.D   	        = D;
XPSObj.M   	        = M;
%% 5   :   RUNNING THE SOLVER
% -- Local solver properties
MaxFunEvals = 1e6;
MaxIter     = 5e4;
FuncTol     = 1e-8; % 1e-7;
StepTol     = 1e-8; % 1e-7;
OptTol      = 1e-8; % 1e-7;
ConTol      = 1e-8; % 1e-7;
FinDiffRelStep = 1e-8; % 1e-5;
%% 5.1  :   LOCAL SOLVER: FIND MINIMUM OF UNBOUNDED MULTIVARIATE FUNCTION
if solve_type == "fminunc"
    % -- Defining the optimisation options for the simulated annealing method
    options = optimoptions('fminunc',...
        'MaxFunctionEvaluations', MaxFunEvals,...
        'FunctionTolerance', FuncTol,...
        'StepTolerance', StepTol,...
        'OptimalityTolerance', OptTol,...
        'MaxIterations', MaxIter,...
        'FinDiffRelStep', FinDiffRelStep,...
        'FinDiffType', 'central');
    % -- Defining the optimisation options for the hybrid minimisation that takes place after convergence
    [params,fval,exitflag,output,grad,hessian] = fminunc(@(x) minimize_function(x,XPSObj), x0, options); 

%% 5.2  :   LOCAL SOLVER: FIND MINIMUM OF BOUNDED MULTIVARIATE FUNCTION
elseif solve_type == "fmincon"
    % -- Defining the optimisation options for the simulated annealing method
    options = optimoptions('fmincon',...
        'MaxFunctionEvaluations', MaxFunEvals,...
        'FunctionTolerance', FuncTol,...
        'StepTolerance', StepTol,...
        'OptimalityTolerance', OptTol,...
        'MaxIterations', MaxIter,...
        'ConstraintTolerance', ConTol,...
        'FinDiffRelStep', FinDiffRelStep,...
        'FinDiffType', 'central');
    % -- Defining the optimisation options for the hybrid minimisation that takes place after convergence
    [params,fval,exitflag,output,lambda,grad,hessian] = fmincon(@(x) minimize_function(x,XPSObj), x0, [], [], [], [], lb, ub, [], options);  

%% 5.3  :   LOCAL SOLVER: BOUNDED LEAST SQUARES FITTING METHOD FOR NON-LINEAR LEAST SQUARES PROBLEMS
elseif solve_type == "lsqnonlin"
    % -- Defining the optimisation options for the simulated annealing method
    options = optimoptions(@lsqnonlin,...
        'Algorithm', 'levenberg-marquardt',...
        'MaxFunctionEvaluations', MaxFunEvals,...
        'FunctionTolerance', FuncTol,...
        'StepTolerance', StepTol,...
        'OptimalityTolerance', OptTol,...
        'MaxIterations', MaxIter);
    % -- Defining the optimisation options for the hybrid minimisation that takes place after convergence
    [params,rnorm,resid,exitflag,output,lambda,jacobian] = lsqnonlin(@(x) minimize_function(x,XPSObj), x0, lb, ub, options);  

%% 5.4  :   GLOBAL SOLVER: BOUNDED SIMULATED ANNEALING TO MINIMISE RESIDUALS
elseif solve_type == "simulannealbnd"
    % -- Defining the optimisation options for the hybrid minimisation that takes place after convergence
    hybridopts = optimoptions('fmincon',...
        'MaxFunctionEvaluations', MaxFunEvals,...
        'OptimalityTolerance', OptTol,...
        'StepTolerance', StepTol,...
        'ConstraintTolerance', ConTol);
    % -- Defining the optimisation options for the simulated annealing method
    options = optimoptions(@simulannealbnd,...
        'TemperatureFcn', TempFcn,...
        'InitialTemperature', InitTemp,...
        'ReannealInterval', ReannealInt,...
        'MaxFunctionEvaluations', MaxFunEvals,...
        'MaxIterations', MaxIter,...
        'TolFun', FuncTol,...
        'FunctionTolerance', FuncTol,...
        'HybridFcn' , {'fmincon' , hybridopts});
    % to view annealing, add:
    % 'PlotFcn',{@saplotbestf,@saplottemperature,@saplotf,@saplotstopping}, 'MaxIterations', 50,
    % -- Run the simulated annealing method
    % --- (1) Initially optimise all parameters
    [params,fval,exitflag,output] = simulannealbnd(@(x) minimize_function(x,XPSObj), x0, lb, ub, options);
end

%% 6    :   STORING THE FITS AS A MATLAB STRUCTURE
fitStr              = struct();
%% 6.1  :   Storing the initial arguments
fitStr.solve_type	= solve_type;
fitStr.xpsDat       = xpsDat;
fitStr.modelDat     = modelDat;
fitStr.iparams      = iparams;
%% 6.2  :   Storing the XPS data, background, model and minimisation variables
fitStr.params       = params;
fitStr.lyr_thick    = [params', Inf];
fitStr.opt_pes_model    = nlayer_pes_model(lyr_mat, fitStr.lyr_thick, lyr_ele, lyr_cls, hv, theta, phi, P, formalism_xsect, formalism_imfp);
fitStr.Nlyrs        = length(fitStr.lyr_thick);
% -- Extracting the original data 
fitStr.X            = xpsDat.xdat;
fitStr.D 	        = xpsDat.ydat;
% -- Extracting the MODEL
fitStr.M            = fit_model(fitStr.params, fitStr.X, XPSObj);
fitStr.XX           = hv;
fitStr.MM           = fit_model(params, fitStr.XX, XPSObj);
% -- Extracting the RESIDUALS (R = D - M)
fitStr.R            = fitStr.D - fitStr.M;
% -- Extracting the CHI-SQUARED value to be minimised
fitStr.MINFUN       = minimize_function(params, XPSObj);
% -- Append the degrees of freedom
fitStr.DoF   	    = DoF;
end

%% DEFINING THE RESIDUAL MINIMISATION FUNCTION TO BE MINIMISED
function MINFUN = minimize_function(x, XPSObj)
    % - 1 - Extracting the DATA
    [X, D]  = fit_data(x, XPSObj);
    % - 2 - Extracting the MODEL
    M       = fit_model(x, X, XPSObj);
    % - 3 - Extracting the RESIDUALS (residuals = data - (model + background))
    R       = D - M;
    % - 4 - Extracting the CHI-SQUARED value to be minimised
    MINFUN = sum(sum(R.^2) ./ std(R).^2);
end
%% DEFINING THE FUNCTION THAT EXTRACTS THE XPS DATA TO BE FITTED
function [X, D] = fit_data(x, XPSObj)
    X   = XPSObj.X;
    D   = XPSObj.D;
end
%% DEFINING THE FUNCTION THAT DETERMINES THE TOTAL PES CURVE FIT
function M = fit_model(x, hv, XPSObj)
    % -- Define the domain
    X               = hv;
    % -- Extracting the defined model sample
    lyr_mat         = XPSObj.modelDat.lyr_mat;
    lyr_ele         = XPSObj.modelDat.lyr_ele;
    lyr_cls         = XPSObj.modelDat.lyr_cls;
    theta           = XPSObj.modelDat.theta;
    phi             = XPSObj.modelDat.phi;
    P               = XPSObj.modelDat.P;
    formalism_xsect = XPSObj.modelDat.formalism_xsect;
    formalism_imfp  = XPSObj.modelDat.formalism_imfp;
    % -- Extracting the layer thicknesses
    lyr_thick       = [x', Inf];
    % -- Extracting the PES model data
    pes_model       = nlayer_pes_model(lyr_mat, lyr_thick, lyr_ele, lyr_cls, X, theta, phi, P, formalism_xsect, formalism_imfp);
    M               = cell2mat(pes_model.lyr_Inorm);
end