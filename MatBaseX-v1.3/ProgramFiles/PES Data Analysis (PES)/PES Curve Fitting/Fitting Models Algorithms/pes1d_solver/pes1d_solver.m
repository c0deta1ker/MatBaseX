function fitStr = pes1d_solver(xdat, ydat, cType, cParams, bType, bParams, solve_type)
% fitStr = pes1d_solver(xdat, ydat, cType, cParams, bType, bParams, solve_type)
%   Function that runs an optimisation algorithm to solve for the best fit
%   to the PES data using N curves.
%   
%   IN:
%   -   xdat:       N×1 column vector of the input domain (binding energy for PES).
%   -   ydat:       N×1 column vector of the intensity range (intensity for PES).
%   -   cType:      1xM row vector of the type of curve to use for the nth state.
%   -   cParams:    3 cells {x0}{lb}{ub} with Nx8 arrays: the n'th peak parameters [BE,INT,FWHM,MR,LSE,LSI,LSW,ASY]
%   -   bType:      string of the type of background to use for fitting. Default: "S" ("", "L", "P", "S", "SO", "SS", "1T", "2T")
%   -   bParams:    1xL cell vector of the background parameters: {LHS,RHS,WIN,BGR,varargin{:}}
%   -   solve_type:     string of the optimisation algorithm to use; "lsqcurvefit" (very fast, good), "lsqnonlin" (fast, not good), "simulannealbnd" (slow, best) 
%
%   OUT:
%   -   fitStr:         MATLAB data-structure that contains all the fit parameters / variables / information

%% Default parameters
% - Default input parameters to use
if nargin < 7; solve_type = "lsqcurvefit"; end
if nargin < 5
    bType   = "S";
    LHS     = mean(xdat(:)) - abs(0.25*range(xdat(:)));
    RHS     = mean(xdat(:)) + abs(0.25*range(xdat(:)));
    Win     = abs(0.02*range(xdat(:)));
    Bgr     = 0.00;
    bParams = {LHS, RHS, Win, Bgr};
end
if isempty(solve_type); solve_type = "lsqcurvefit"; end
if isempty(bType); bType = "S"; end
if isempty(bParams)
    LHS     = mean(xdat(:)) - abs(0.25*range(xdat(:)));
    RHS     = mean(xdat(:)) + abs(0.25*range(xdat(:)));
    Win     = abs(0.02*range(xdat(:)));
    Bgr     = 0.00;
    bParams = {LHS, RHS, Win, Bgr};
end
%% Validity checks on the input parameters
% - Consistency check and finding the total number of curves
if size(cParams{1}, 1) ~= size(cParams{2}, 1) || size(cParams{2}, 1) ~= size(cParams{3}, 1)
    error('The input parameter cell array is not a consistent size - check cParams input!');
end
% - Validity check on input curve parameters
for i = 1:size(cParams{1}, 1)
    if size(cParams{1}, 2) == 4
        % --- Set the ASY, LSE, LSI and LSW components to zero
        cParams{1}(i,5) = 0; cParams{1}(i,6) = 0; cParams{1}(i,7) = 0; cParams{1}(i,8) = 0;
        cParams{2}(i,5) = 0; cParams{2}(i,6) = 0; cParams{2}(i,7) = 0; cParams{2}(i,8) = 0;
        cParams{3}(i,5) = 0; cParams{3}(i,6) = 0; cParams{3}(i,7) = 0; cParams{3}(i,8) = 0;
    elseif size(cParams{1}, 2) == 5
        % --- Set the LSE, LSI and LSW components to zero
        cParams{1}(i,6) = 0; cParams{1}(i,7) = 0; cParams{1}(i,8) = 0;
        cParams{2}(i,6) = 0; cParams{2}(i,7) = 0; cParams{2}(i,8) = 0;
        cParams{3}(i,6) = 0; cParams{3}(i,7) = 0; cParams{3}(i,8) = 0;
    elseif size(cParams{1}, 2) == 6
        % --- Set the LSI and LSW components to zero
        cParams{1}(i,7) = 0; cParams{1}(i,8) = 0;
        cParams{2}(i,7) = 0; cParams{2}(i,8) = 0;
        cParams{3}(i,7) = 0; cParams{3}(i,8) = 0;
    elseif size(cParams{1}, 2) == 7
        % --- Set the LSW components to zero
        cParams{1}(i,8) = 0;
        cParams{2}(i,8) = 0;
        cParams{3}(i,8) = 0;
    elseif size(cParams{1}, 2) > 8 || size(cParams{1}, 2) < 4 
        error('Not enough input arguments defined - check cParams input!');
    end
end
% - Validity check on values of curve parameters
for i = 1:3
    % --- if INT < 0, then make it 0
    matrix = []; matrix = cParams{i}(:,2); matrix(matrix<0) = 0; cParams{i}(:,2) = matrix;
    % --- if FWHM < 0, then make it 0
    matrix = []; matrix = cParams{i}(:,3); matrix(matrix<0) = 0; cParams{i}(:,3) = matrix;
    % --- if MR < 0, then make it 0 (if MR > 1, then make it 1)
    matrix = []; matrix = cParams{i}(:,4); matrix(matrix<0) = 0; cParams{i}(:,4) = matrix;
    matrix = []; matrix = cParams{i}(:,4); matrix(matrix>1) = 0; cParams{i}(:,4) = matrix;
    % --- if LSI < 0, then make it 0
    matrix = []; matrix = cParams{i}(:,6); matrix(matrix<0) = 0; cParams{i}(:,6) = matrix;
    % --- if LSW < 0, then make it 0
    matrix = []; matrix = cParams{i}(:,7); matrix(matrix<0) = 0; cParams{i}(:,7) = matrix;
    % --- if ASY < 0, then make it 0
    matrix = []; matrix = cParams{i}(:,8); matrix(matrix<0) = 0; cParams{i}(:,8) = matrix;
end
% -- Ensuring consistency in the vector definitions
if iscolumn(xdat) && isrow(ydat); ydat = ydat';
elseif isrow(xdat) && iscolumn(ydat); xdat = xdat';
elseif isrow(xdat) && isrow(ydat); xdat = xdat'; ydat = ydat';
end
%% - 1 - Background subtraction of data
[X, D, B] = PES_BgrndSubCurve(xdat, ydat, bType, bParams{:});
DB = D - B;
%% - 2 - Extracting all fit parameters
% -- Defining the initial conditions
x0          = [cParams{1}(:)];
lb          = [cParams{2}(:)];
ub          = [cParams{3}(:)];
% -- Determining the degrees of freedom for the fitting model
val	= lb + (ub-lb); DoF = 0;
for i = 1:length(val); if val(i) ~= lb(i); DoF = DoF + 1; end; end
%% - 3 - Running the optimization algorithm
solve_type = char(lower(solve_type));
switch solve_type
    case lower({'lsqcurvefit','lsq'});          [params,meta_fits.rnorm,meta_fits.resid,meta_fits.exitflag,meta_fits.output,meta_fits.lambda,meta_fits.J]  = lsqcurvefit(@(x,X) full_pes_function(x,X,cType), x0, X, DB, lb, ub); 
    case lower({'lsqcurvefitunc','lsqunc'});    [params,meta_fits.rnorm,meta_fits.resid,meta_fits.exitflag,meta_fits.output,meta_fits.lambda,meta_fits.J]  = lsqcurvefit(@(x,X) full_pes_function(x,X,cType), x0, X, DB); 
    case lower({'nlinfit','nlin'});             [params,meta_fits.R,meta_fits.J,meta_fits.CovB,meta_fits.MSE,meta_fits.ErrorModelInfo] = nlinfit(X, DB, @(x,X) full_pes_function(x,X,cType), x0);
    case lower({'fminunc', 'func'});            [params,meta_fits.fval,meta_fits.exitflag,meta_fits.output,meta_fits.grad,meta_fits.hessian] = fminunc(@(x) minimize_function(x,X,DB,cType), x0); 
    case lower({'fmincon', 'fcon'});            [params,meta_fits.fval,meta_fits.exitflag,meta_fits.output,meta_fits.lambda,meta_fits.grad,meta_fits.hessian] = fmincon(@(x) minimize_function(x,X,DB,cType), x0, [], [], [], [], lb, ub, []);  
    case lower({'lsqnonlin'});                  [params,meta_fits.rnorm,meta_fits.resid,meta_fits.exitflag,meta_fits.output,meta_fits.lambda,meta_fits.J] = lsqnonlin(@(x) minimize_function(x,X,DB,cType), x0, lb, ub); 
    case lower({'simulannealbnd'});             [params,meta_fits.fval,meta_fits.exitflag,meta_fits.output] = simulannealbnd(@(x) minimize_function(x,X,DB,cType), x0, lb, ub);
    otherwise; error('Please select a valid solve_type!');
end
%% - 4 - Storing the fits as a MATLAB data structure
fitStr              = struct();
% 4.1 - Storing the initial arguments
fitStr.solve_type	= solve_type;
fitStr.cType        = cType;
fitStr.cParams      = cParams;
fitStr.bType        = bType;
fitStr.bParams      = bParams;
fitStr.nStates      = length(cType);
% 4.2 - Storing the XPS data, background, model and minimisation variables
% -- Append the degrees of freedom
fitStr.DoF   	    = DoF;
% -- Storing original data
fitStr.xdat         = xdat;
fitStr.ydat 	    = ydat;
% -- Storing ROI data
fitStr.X            = X;
fitStr.D 	        = D;
fitStr.B            = B;
fitStr.DB 	        = D - B;
fitStr.M            = full_pes_function(params, fitStr.X, cType);
% -- Storing Best fits
fitStr.meta_fits 	= meta_fits;
fitStr.Xi           = min(fitStr.X(:)):0.01:max(fitStr.X(:)); fitStr.Xi = fitStr.Xi';
fitStr.Mi           = full_pes_function(params, fitStr.Xi, cType);
fitStr.cMi          = [];
fitStr.Bi           = interp1(fitStr.X, fitStr.B, fitStr.Xi, 'linear');
fitStr.MiBi         = fitStr.Mi + fitStr.Bi;
% -- Extracting the RESIDUALS (R = D - (M + B))
fitStr.R            = fitStr.D - (fitStr.M + fitStr.B);         % Residuals
fitStr.COST_R2      = sum(fitStr.R.^2);                                 % Cost Function: Sum of Squared Residuals
fitStr.COST_CHISQ   = sum(fitStr.R.^2 ./ abs(fitStr.M));                % Cost Function: Chi-squared
fitStr.COST_STD_RESID   = sqrt(sum(fitStr.R.^2) ./ (length(fitStr.R) - 2)); % Cost Function: Standard Deviation of the Residuals
fitStr.MINFUN       = minimize_function(params, fitStr.X, fitStr.DB, cType);
% 4.3 - Storing the final fit variables of each PES curve component
for i = 1:fitStr.nStates
    % --- Best fit components on new domain
    fitStr.fParams(i,:) = params(i:fitStr.nStates:end);
   	fitStr.cMi(:,i) = PES_SpecIntCurve(fitStr.Xi, fitStr.cType(i),...
        fitStr.fParams(i,1), fitStr.fParams(i,2), fitStr.fParams(i,3),...
        fitStr.fParams(i,4), fitStr.fParams(i,5), fitStr.fParams(i,6),...
        fitStr.fParams(i,7), fitStr.fParams(i,8));
    % --- Storing each curve parameter
    fitStr.BE(i)    = fitStr.fParams(i,1);
    fitStr.INT(i)   = fitStr.fParams(i,2);
    fitStr.FWHM(i)  = fitStr.fParams(i,3);
    fitStr.MR(i)    = fitStr.fParams(i,4);
    fitStr.LSE(i)   = fitStr.fParams(i,5);
    fitStr.LSI(i)   = fitStr.fParams(i,6);
    fitStr.LSW(i)   = fitStr.fParams(i,7);
    fitStr.ASY(i)   = fitStr.fParams(i,8);
    % --- Storing the curve area information
    fitStr.AREA(i)	= trapz(fitStr.Xi, fitStr.cMi(:,i));
end
% --- Storing the normalised area contribution for quantification
fitStr.AREA0        = fitStr.AREA ./ trapz(fitStr.Xi, fitStr.Mi);
% 4.4 - Extracting confidence intervals
warning('off');
[meta_ci.BETA,meta_ci.RESID,meta_ci.J,meta_ci.COVB,meta_ci.MSE] = nlinfit(X, DB, @(x,X) full_pes_function(x,X,cType), params);
ci   = nlparci(meta_ci.BETA,meta_ci.RESID,"covar",meta_ci.COVB);
ci   = range(ci,2) ./ 3.92;     % Standard error
fitStr.meta_ci = meta_ci;
for i = 1:fitStr.nStates
    % --- Best fit components on new domain
    fitStr.ciParams(i,:) = ci(i:fitStr.nStates:end);
    % -- Defining the initial conditions
    lb          = [cParams{2}(:)];
    ub          = [cParams{3}(:)];
    val	        = ub-lb;
    val         = val(i:fitStr.nStates:end);
    % --- Storing each curve parameter
    if val(1) == 0; fitStr.BE_ci(i) = 0; else;      fitStr.BE_ci(i)    = fitStr.ciParams(i,1); end
    if val(2) == 0; fitStr.INT_ci(i) = 0; else;     fitStr.INT_ci(i)   = fitStr.ciParams(i,2); end
    if val(3) == 0; fitStr.FWHM_ci(i) = 0; else;    fitStr.FWHM_ci(i)  = fitStr.ciParams(i,3); end
    if val(4) == 0; fitStr.MR_ci(i) = 0; else;      fitStr.MR_ci(i)    = fitStr.ciParams(i,4); end
    if val(5) == 0; fitStr.LSE_ci(i) = 0; else;     fitStr.LSE_ci(i)   = fitStr.ciParams(i,5); end
    if val(6) == 0; fitStr.LSI_ci(i) = 0; else;     fitStr.LSI_ci(i)   = fitStr.ciParams(i,6); end
    if val(7) == 0; fitStr.LSW_ci(i) = 0; else;     fitStr.LSW_ci(i)   = fitStr.ciParams(i,7); end
    if val(8) == 0; fitStr.ASY_ci(i) = 0; else;     fitStr.ASY_ci(i)   = fitStr.ciParams(i,8); end
    % -- Extracting uncertainty in area
    M_AREA_UB = PES_SpecIntCurve(fitStr.Xi, fitStr.cType(i),...
            fitStr.fParams(i,1) + fitStr.ciParams(i,1), fitStr.fParams(i,2) + fitStr.ciParams(i,2), fitStr.fParams(i,3) + fitStr.ciParams(i,3),...
            fitStr.fParams(i,4) + fitStr.ciParams(i,4), fitStr.fParams(i,5) + fitStr.ciParams(i,5), fitStr.fParams(i,6) + fitStr.ciParams(i,6),...
            fitStr.fParams(i,7) + fitStr.ciParams(i,7), fitStr.fParams(i,8) + fitStr.ciParams(i,8));
    M_AREA_LB = PES_SpecIntCurve(fitStr.Xi, fitStr.cType(i),...
            fitStr.fParams(i,1) - fitStr.ciParams(i,1), fitStr.fParams(i,2) - fitStr.ciParams(i,2), fitStr.fParams(i,3) - fitStr.ciParams(i,3),...
            fitStr.fParams(i,4) - fitStr.ciParams(i,4), fitStr.fParams(i,5) - fitStr.ciParams(i,5), fitStr.fParams(i,6) - fitStr.ciParams(i,6),...
            fitStr.fParams(i,7) - fitStr.ciParams(i,7), fitStr.fParams(i,8) - fitStr.ciParams(i,8));
    % --- Storing the curve area information
    fitStr.AREA_ci(i)	= (trapz(fitStr.Xi, M_AREA_UB) - trapz(fitStr.Xi, M_AREA_LB)) ./3.92;
end
% --- Storing the normalised area contribution for quantification
fitStr.AREA0_ci        = fitStr.AREA_ci ./ trapz(fitStr.Xi, fitStr.Mi);

end

%% DEFINING THE RESIDUAL MINIMISATION FUNCTION TO BE MINIMISED
function MINFUN = minimize_function(x,X,DB,cType)
    M   = full_pes_function(x, X, cType);
    R   = DB - M;
    MINFUN = sum(R.^2 ./ abs(M));
end

%% DEFINING THE FINAL FUNCTION THAT DESCRIBES THE PES CURVE TO BE FITTED
function M = full_pes_function(x, xdat, cType)
    % - 1 - Extract the curve component for each state
    nStates = length(cType);
    comp_int = {};
    for i = 1:nStates
        % -- Extracting the arguments for the component curve
        pes_args    = x(i:nStates:end);
        % -- Extracting the component intensities
        comp_int{i} = PES_SpecIntCurve(xdat, cType(i),...
            pes_args(1), pes_args(2), pes_args(3),...
            pes_args(4), pes_args(5), pes_args(6),...
            pes_args(7), pes_args(8));
    end
    % - 2 - Sum up all of the curve components to get the final model PES curve
    pes_int = zeros(size(xdat));
    for i = 1:nStates; pes_int = pes_int + comp_int{i}; end
    M = pes_int;
    M(isnan(M)) = 0;
    if size(M, 2) > 1; M = M'; end
end