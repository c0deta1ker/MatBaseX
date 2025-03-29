function y = curve_exponential(x, amplitude, decay)
% y = curve_exponential(x, amplitude, decay)
%   A model based on an exponential decay function. The model has 2 input
%   parameters; amplitude and decay.
%
%   IN:
%   -   x:              N×1 (or 1×N) vector of the input domain
%   -   amplitude:      scalar that defines the amplitude of the exponential decay
%   -   decay:          scalar that defines the decay (or rate) constant
%
%   OUT:
%   -   y:              N×1 (or 1×N) vector of the output range

%% Default parameters
if nargin < 2;          amplitude   = 1; end
if nargin < 3;          decay       = 1; end
if isempty(amplitude);  amplitude   = 1; end
if isempty(decay);      decay       = 1; end
%% - 1 - Determination of the Exponential Model
y = amplitude .* exp(-x / decay);
%% Validity check on the outputs
y(isnan(y)) = 0;
if isrow(x); if size(y, 2) ~= length(x); y = y'; end
elseif iscolumn(x); if size(y, 1) ~= length(x); y = y'; end
end
end