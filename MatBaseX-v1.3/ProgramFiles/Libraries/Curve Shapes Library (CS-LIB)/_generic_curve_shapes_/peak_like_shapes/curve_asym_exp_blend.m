function y = curve_asym_exp_blend(x, center, asymmetry)
% y = curve_asym_exp_blend(x, center, asymmetry)
%   A model based on an asymmetric exponential blend (AEB), that is 
%   used to create the asymmetric Voigt-type lineshapes. The asymmetric profile
%   obtained from the blend is: Y(x) = V(x) + AEB(x) * (1 - V(x)), where
%   V(x) is the Voigt-Curve Model. The model has two input parameters: center 
%   and asymmetry (negative, positive and 0 for RHS, LHS and no asymmetric
%   blending respectively). The decay constant coefficient is defined as 
%   K = 0.1, which gives a reasonable span of the asymmetry.
%
%   IN:
%   -   x:              N×1 (or 1×N) vector of the input domain
%   -   center:         scalar that defines the start position of the AEB
%   -   asymmetry:      scalar that defines the asymmetry ratio; 0 for none, 0->1 is for LHS asymmetry, -1->0 is for RHS asymmetry
%
%   OUT:
%   -   y:              N×1 (or 1×N) vector of the output range

%% Default parameters
if nargin < 2;          center      = 0.0; end
if nargin < 3;          asymmetry    = 0.5; end
if isempty(center);     center      = 0; end
if isempty(asymmetry);  asymmetry    = 0.5; end
%% Validity checks on the input parameters
if asymmetry < -1; asymmetry = -1; end    % -- If the asymmetry is <-1, pad it to -1
if asymmetry > 1; asymmetry = 1; end      % -- If the asymmetry is >1, pad it to 1
%% - 1 - Determination of the Exponential Asymmetric Blend intensities
K = 0.1;    % Coefficient
% Evaluating the asymmetric blend
if asymmetry > 0 || asymmetry == 0
    y    = exp(-K/asymmetry.*abs(x - center));
    % For all values where x > x0, set to zero
    [~, indx]       = min(abs(x - center));
    y(indx:end)	= 0;
elseif asymmetry < 0
    y    = exp(K/asymmetry.*abs(x - center));
    % For all values where x < x0, set to zero
    [~, indx]       = min(abs(x - center));
    y(1:indx)	= 0;
end
%% Validity check on the outputs
y(isnan(y)) = 0;
if isrow(x); if size(y, 2) ~= length(x); y = y'; end
elseif iscolumn(x); if size(y, 1) ~= length(x); y = y'; end
end
end