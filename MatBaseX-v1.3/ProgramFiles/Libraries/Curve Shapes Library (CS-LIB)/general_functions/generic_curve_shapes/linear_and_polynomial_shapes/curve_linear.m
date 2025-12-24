function y = curve_linear(x, slope, intercept)
% y = curve_linear(x, slope, intercept)
%   A model based a Linear model, with 2 input parameters; slope and
%   intercept.
%
%   IN:
%   -   x:              N×1 (or 1×N) vector of the input domain
%   -   slope:          scalar that defines the slope (dy/dx)
%   -   intercept:      scalar that defines the intercept value of the y-axis
%
%   OUT:
%   -   y:              N×1 (or 1×N) vector of the output range

%% Default parameters
if nargin < 2;          slope       = 1; end
if nargin < 3;          intercept   = 0; end
if isempty(slope);      slope       = 1; end
if isempty(intercept);  intercept   = 0; end
%% - 1 - Determination of the Linear Model
y = slope.*x + intercept;
%% Validity check on the outputs
y(isnan(y)) = 0;
if isrow(x); if size(y, 2) ~= length(x); y = y'; end
elseif iscolumn(x); if size(y, 1) ~= length(x); y = y'; end
end
end