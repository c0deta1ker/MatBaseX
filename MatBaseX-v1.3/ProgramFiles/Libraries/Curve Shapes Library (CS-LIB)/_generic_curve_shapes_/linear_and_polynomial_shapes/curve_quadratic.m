function y = curve_quadratic(x, a, b, c)
% y = curve_quadratic(x, a, b, c)
%   A model based a Quadratic model, with 3 input parameters; a, b & c. The
%   coefficients are defined as y = ax^2 + bx + c.
%
%   IN:
%   -   x:              N×1 (or 1×N) vector of the input domain
%   -   a,b,c:          scalars that define the quadratic coefficients.
%
%   OUT:
%   -   y:              N×1 (or 1×N) vector of the output range

%% Default parameters
if nargin < 2; a = 1; end
if nargin < 3; b = 1; end
if nargin < 4; c = 1; end
if isempty(a); a = 1; end
if isempty(b); b = 1; end
if isempty(c); c = 1; end
%% - 1 - Determination of the Quadratic Model
y = a.*x.^2 + b.*x + c;
%% Validity check on the outputs
y(isnan(y)) = 0;
if isrow(x); if size(y, 2) ~= length(x); y = y'; end
elseif iscolumn(x); if size(y, 1) ~= length(x); y = y'; end
end
end