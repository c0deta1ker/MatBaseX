function y = pes_atom_conc_curve(x, Type, varargin)
% y = pes_atom_conc_curve(x, Type, varargin)
%   Function that evaluates a generic atomic concentration curve profile by
%   defining the type, along with the necessary arguments. See below for
%   all available curve types and what input arguments are required for
%   each case. Options for a step-like and tophat-like distribution are
%   available. Additionally, the Error-, Gaussian- and
%   Exponential-Broadened versions of the LHS/RHS or both sides of the
%   distribution are available.
%
%   IN:
%   -   x:          N×1 (or 1×N) vector of the input domain along the x-axis (typically the depth axis)
%   -   Type:       string of the type of atomic concentration curve profile from the following list:
%                       - Step:                                         "StLHS", "StRHS"
%                       - Step Erf Broadened:                           "StErfLHS", "StErfRHS"
%                       - Step Gaussian Broadened:                      "StGaLHS", "StGaRHS"
%                       - Step Gaussian Broadened & Truncated:          "StGaTrLHS", "StGaTrRHS"
%                       - Step Exponential Broadened:                   "StExLHS", "StExRHS"
%                       - Step Exponential Broadened & Truncated:       "StExTrLHS", "StExTrRHS"
%                       - TopHat:                                       "ToHa"
%                       - TopHat Erf Broadened:                         "ToHaErf", "ToHaErfLHS", "ToHaErfRHS"
%                       - TopHat Gaussian Broadened:                    "ToHaGa", "ToHaGaLHS", "ToHaGaRHS"
%                       - TopHat Gaussian Broadened & Truncated:        "ToHaGaTrLHS", "ToHaGaTrRHS"
%                       - TopHat Exponential Broadened:                 "ToHaEx", "ToHaExLHS", "ToHaExRHS"
%                       - TopHat Exponential Broadened & Truncated:     "ToHaExTrLHS", "ToHaExTrRHS"
%   -   varargin:   arguments to be inserted depending on the type of atomic concentration curve profile defined.
%                       - Step:                                         [center, amplitude]
%                       - Step Erf Broadened:                           [center, amplitude, fwhm]
%                       - Step Gaussian Broadened:                      [center, amplitude, fwhm]
%                       - Step Gaussian Broadened & Truncated:          [center, amplitude, fwhm, cutoff]
%                       - Step Exponential Broadened:                   [center, amplitude, cdl]
%                       - Step Exponential Broadened & Truncated:       [center, amplitude, cdl, cutoff]
%                       - TopHat:                                       [center, amplitude, width]
%                       - TopHat Erf Broadened:                         [center, amplitude, width, fwhm]
%                       - TopHat Gaussian Broadened:                    [center, amplitude, width, fwhm]
%                       - TopHat Gaussian Broadened & Truncated:        [center, amplitude, width, fwhm, cutoff]
%                       - TopHat Exponential Broadened:                 [center, amplitude, width, cdl]
%                       - TopHat Exponential Broadened & Truncated:     [center, amplitude, width, cdl, cutoff]
%
%   OUT:
%   -   y:     	    N×1 (or 1×N) vector of the output atomic concentration curve profile

%% Default parameters
if nargin < 3; varargin = {}; end
if isempty(varargin); varargin = {}; end
%% - 1 - Determination of the PES Atomic Concentration Curve
Type = char(lower(Type));
switch Type
    % - Step Functions
    case lower({'Step(LHS)','StLHS','SLHS'});                           y = curve_step_lhs(x, varargin{:}); label="StLHS";
    case lower({'Step(RHS)','StRHS','SRHS'});                           y = curve_step_rhs(x, varargin{:}); label="StRHS";
    case lower({'Step(LHS-Erf)','StErfLHS','SERFLHS'});                  y = curve_step_lhs_erf(x, varargin{:}); label="StErfLHS";
    case lower({'Step(RHS-Erf)','StErfRHS','SERFRHS'});                  y = curve_step_rhs_erf(x, varargin{:}); label="StErfRHS";
    case lower({'Step(LHS-Exp)','StExLHS','SELHS'});                    y = curve_step_lhs_exp(x, varargin{:}); label="StExLHS";
    case lower({'Step(RHS-Exp)','StExRHS','SERHS'});                    y = curve_step_rhs_exp(x, varargin{:}); label="StExRHS";
    case lower({'Step(LHS-Exp-Trunc)','StExTrLHS','SETLHS'});           y = curve_step_lhs_exp_trunc(x, varargin{:}); label="StExTrLHS";
    case lower({'Step(RHS-Exp-Trunc)','StExTrRHS','SETRHS'});           y = curve_step_rhs_exp_trunc(x, varargin{:}); label="StExTrRHS";
    case lower({'Step(LHS-Gauss)','StGaLHS','SGLHS'});                  y = curve_step_lhs_gauss(x, varargin{:}); label="StGaLHS";
    case lower({'Step(RHS-Gauss)','StGaRHS','SGLHS'});                  y = curve_step_rhs_gauss(x, varargin{:}); label="StGaRHS";
    case lower({'Step(LHS-Gauss-Trunc)','StGaTrLHS','SGTLHS'});         y = curve_step_lhs_gauss_trunc(x, varargin{:}); label="StGaTrLHS";
    case lower({'Step(RHS-Gauss-Trunc)','StGaTrRHS','SGTRHS'});         y = curve_step_rhs_gauss_trunc(x, varargin{:}); label="StGaTrRHS";
    % - Top-Hat Functions
    case lower({'TopHat','ToHa','TH'});                                    y = curve_tophat(x, varargin{:}); label="ToHa";
    case lower({'TopHat(Erf)','ToHaErf','THERF'});                          y = curve_tophat_erf(x, varargin{:}); label="ToHaErf";
    case lower({'TopHat(LHS-Erf)','ToHaErfLHS','THERFLHS'});                y = curve_tophat_lhs_erf(x, varargin{:}); label="ToHaErfLHS";
    case lower({'TopHat(RHS-Erf)','ToHaErfRHS','THERFRHS'});                y = curve_tophat_rhs_erf(x, varargin{:}); label="ToHaErfRHS";
    case lower({'TopHat(Exp)','ToHaEx','THE'});                             y = curve_tophat_exp(x, varargin{:}); label="ToHaEx";
    case lower({'TopHat(LHS-Exp)','ToHaExLHS','THELHS'});                   y = curve_tophat_lhs_exp(x, varargin{:}); label="ToHaExLHS";
    case lower({'TopHat(RHS-Exp)','ToHaExRHS','THERHS'});                   y = curve_tophat_rhs_exp(x, varargin{:}); label="ToHaExRHS";
    case lower({'TopHat(LHS-Exp-trunc)','ToHaExTrLHS','THETLHS'});          y = curve_tophat_lhs_exp_trunc(x, varargin{:}); label="ToHaExTrLHS";
    case lower({'TopHat(RHS-Exp-trunc)','ToHaExTrRHS','THETRHS'});          y = curve_tophat_rhs_exp_trunc(x, varargin{:}); label="ToHaExTrRHS";
    case lower({'TopHat(Gauss)','ToHaGa','THG'});                           y = curve_tophat_gauss(x, varargin{:}); label="ToHaGa";
    case lower({'TopHat(LHS-Gauss)','ToHaGaLHS','THGLHS'});                 y = curve_tophat_lhs_gauss(x, varargin{:}); label="ToHaGaLHS";
    case lower({'TopHat(RHS-Gauss)','ToHaGaRHS','THGRHS'});                 y = curve_tophat_rhs_gauss(x, varargin{:}); label="ToHaGaRHS";
    case lower({'TopHat(LHS-Gauss-trunc)','ToHaGaTrLHS','THGTLHS'});        y = curve_tophat_lhs_gauss_trunc(x, varargin{:}); label="ToHaGaTrLHS";
    case lower({'TopHat(RHS-Gauss-trunc)','ToHaGaTrRHS','THGTRHS'});        y = curve_tophat_rhs_gauss_trunc(x, varargin{:}); label="ToHaGaTrRHS";
    otherwise; label=""; y = NaN(size(x)); warning('Curve type not recognised, return NaN values.'); 
end
%% Validity check on the outputs
y(isnan(y)) = 0;
if isrow(x); if size(y, 2) ~= length(x); y = y'; end
elseif iscolumn(x); if size(y, 1) ~= length(x); y = y'; end
end
%% -- For Debugging
plot_result = 0;
if plot_result == 1
    % - Initialising the figure object
    figure(); hold on;
    plot(x, y, 'b-', 'linewidth', 2);
    title(sprintf("PES_AtmConcCurve(%s)",label), 'interpreter', 'none'); 
    xlabel(' X ', 'fontweight', 'bold');
    ylabel(' Y ', 'fontweight', 'bold');
    % -- Determining the best limits for the plot
    axis([min(x(:)), max(x(:)), min(y(:)), 1.1*max(y(:))]);
end
end