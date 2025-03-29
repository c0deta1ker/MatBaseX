function y = curve_powerlaw(x, amplitude, exponent)
% ydat = curve_powerlaw(x, amplitude, exponent)
%   A model based on a Power Law. The model has 2 input parameters;
%   amplitude and exponent.
%
%   IN:
%   -   x:              N×1 (or 1×N) vector of the input domain
%   -   amplitude:      scalar that defines the amplitude
%   -   exponent:       scalar that defines the exponent
%
%   OUT:
%   -   y:              N×1 (or 1×N) vector of the output range

%% Default parameters
if nargin < 2;          amplitude   = 1; end
if nargin < 3;          exponent       = 1; end
if isempty(amplitude);  amplitude   = 1; end
if isempty(exponent);   exponent       = 1; end
%% - 1 - Determination of the Power Law Model
y = amplitude .* x .^(exponent);
%% Validity check on the outputs
y(isnan(y)) = 0;
if isrow(x); if size(y, 2) ~= length(x); y = y'; end
elseif iscolumn(x); if size(y, 1) ~= length(x); y = y'; end
end
end