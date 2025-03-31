function y = curve_heaviside(x)
% y = curve_heaviside(x)
%   Function that evaluates a Heaviside step function that returns 0 for 
%   x < 0, 0.5 for x == 0, and 1 for x > 0. Used for defining other step &
%   tophat-like functions.
%
%   IN:
%   -   x:              N×1 (or 1×N) vector of the input domain
%
%   OUT:
%   -   y:              N×1 (or 1×N) vector of the output range

%% - 1 - Determination of the curve intensities
y           = zeros(size(x));       % Initialize output with zeros
y(x > 0)    = 1;                    % Set 1 for x > 0
y(x == 0)   = 0.5;                  % Set 0.5 for x == 0
%% Validity check on the outputs
y(isnan(y)) = 0;
if isrow(x); if size(y, 2) ~= length(x); y = y'; end
elseif iscolumn(x); if size(y, 1) ~= length(x); y = y'; end
end
end