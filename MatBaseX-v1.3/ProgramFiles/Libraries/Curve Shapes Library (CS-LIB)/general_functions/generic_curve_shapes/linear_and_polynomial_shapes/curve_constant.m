function y = curve_constant(x, constant)
% y = curve_constant(x, constant)
%   A model based a Constant model, with a single parameter. Note that this 
%   is ‘constant’ in the sense of having no dependence on the independent 
%   variable x, not in the sense of being non-varying. Thus, the single
%   input parameter is expected to be varied in the fitting model.
%
%   IN:
%   -   x:              N×1 (or 1×N) vector of the input domain
%   -   constant:       scalar that defines the constant value
%
%   OUT:
%   -   y:              N×1 (or 1×N) vector of the output range

%% Default parameters
if nargin < 2;          constant   = 0; end
if isempty(constant);   constant   = 0; end
%% - 1 - Determination of the Constant Model
y = ones(size(x)).*constant;
%% Validity check on the outputs
y(isnan(y)) = 0;
if isrow(x); if size(y, 2) ~= length(x); y = y'; end
elseif iscolumn(x); if size(y, 1) ~= length(x); y = y'; end
end
end