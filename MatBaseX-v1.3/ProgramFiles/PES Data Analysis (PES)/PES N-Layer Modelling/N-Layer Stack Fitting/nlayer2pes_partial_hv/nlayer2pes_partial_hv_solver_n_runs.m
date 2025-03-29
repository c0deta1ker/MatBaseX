function [fitStr0, statStr] = nlayer2pes_partial_hv_solver_n_runs(xpsDat, modelDat, iparams, which_layers, solve_type, n_runs)
% [fitStr0, statStr] = nlayer2pes_partial_hv_solver_n_runs(xpsDat, modelDat, iparams, which_layers, solve_type, n_runs)
%   Function that runs 'nlayer2pes_partial_hv_solver()' N amount of independent 
%   times to solve for the best fit model sample stack of photoelectron intensities. 
%   The initial conditions are randomly sampled over the range of the input 
%   uncertainty. This allows the uncertainty in the best fit parameters to be 
%   determined by looking at the variance of the converged fit parameters. 
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
%   -   which_layers:   1xM vector of which layers in the material stack to fit
%   -   solve_type:     string of the optimisation algorithm to use; "fmincon" (good constrained fit), "fminunc" (good unconstrained fit), "lsqnonlin" (quick fit, not so good), "simulannealbnd" (slow, best). 
%   -   n_runs:         scalar value for the total number of independent runs
%
%   OUT:
%   -   fitStr0:        MATLAB data-structure that contains the absolute best fit
%   -   statStr:        MATLAB data-structure that contains all the statistical analysis

%% -- Default parameters
if nargin < 6; n_runs = 10; end
if nargin < 5; solve_type = "fmincon"; end
if nargin < 4; which_layers = []; end
if isempty(solve_type); solve_type = "fmincon"; end
if isempty(which_layers); which_layers = []; end
if isempty(n_runs); n_runs = 10; end
%% -- Validity check on inputs
% -- Ensure a valid number of runs is made
if n_runs < 0; n_runs = 1; end
%% -- Defining constants
% - Total number of parameters
nParams = length(iparams{1});
%% 1    :   Running the fitting algorithm N independent time for statistical analysis
statStr         = struct();
statStr.n_runs	= 1:n_runs;
fit     = cell(n_runs,1);
params	= zeros(n_runs, nParams);
MINFUN 	= zeros(n_runs,1);
% -- Running the fitting algorithm for N independent times for analysis
for i = statStr.n_runs
    fprintf("Run %i / %i \n", i, n_runs);
    % --- Add perturbation on the initial conditions
    new_init_conds          = iparams;
    new_init_conds{1}       = iparams{2} + (iparams{3}-iparams{2}) .* rand(size(iparams{2}));
    % --- Executing the fit
    if i == 1;  fitStr{1} = nlayer2pes_partial_hv_solver(xpsDat, modelDat, iparams, which_layers, solve_type);
    else;       fitStr{i} = nlayer2pes_partial_hv_solver(xpsDat, modelDat, new_init_conds, which_layers, solve_type);
    end
    % --- Storing the best fits for statistical analysis
    fit{i}       	= fitStr{i};
    % --- Storing the best fit parameters for statistical analysis
    params(i,:)     = fit{i}.params';
    MINFUN(i)       = fit{i}.MINFUN;
end
% -- Assigning variables
statStr.fit     = fit;
statStr.params  = params;
statStr.MINFUN 	= MINFUN';
%% 2    :   Storing the fit structure that has the smallest value of chi-squared
[~, idxBest]    = min(statStr.MINFUN(:));
fitStr0         = statStr.fit{idxBest};
%% 3    :   Extracting the best estimate for each one of the parameters and their standard deviation
for i = 1:size(params, 2)
    label = char(sprintf("L%i", i));
    statStr.(label) = statStr.params(:,i)';
end
end