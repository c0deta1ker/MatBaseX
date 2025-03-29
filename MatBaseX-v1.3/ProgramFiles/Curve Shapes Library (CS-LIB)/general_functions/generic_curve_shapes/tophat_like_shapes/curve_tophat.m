function y = curve_tophat(x, center, amplitude, width)
% y = curve_tophat(x, center, amplitude, width)
%   Function that evaluates a Top-Hat curve profile after defining the
%   position of the centre, its amplitude and width. 
%   For all values of x outside of the Top-Hat function, the output is zero, 
%   whereas all values inside the width of the Top-Hat function yield a value
%   equal to the amplitude.
%   Used to simulate a top-hat profile that is ideal & abrupt on each side.
%
%   IN:
%   -   x:              N×1 (or 1×N) vector of the input domain
%   -   center:         scalar of the position of the step along the x-axis
%   -   amplitude:      scalar of the maximum amplitude of the step
%   -   width:          scalar of the total width of the top-hat function and should be a positive number
%
%   OUT:
%   -   y:              N×1 (or 1×N) vector of the output range

%% Default parameters
if nargin < 2; center = 0; end
if nargin < 3; amplitude = 1; end
if nargin < 4; width = 1; end
if isempty(center); center = 0; end
if isempty(amplitude); amplitude = 1; end
if isempty(width); width = 1; end
%% Validity check on the input parameters
if width < 0; width = 0; end        % -- Ensure width is a positive number
%% - 1 - Determination of the curve intensities
% -- Extract a Heaviside function centered at x0 with a defined width
H1 = heaviside(x - center + 0.5*width);
H2 = heaviside(-x + center + 0.5*width);
% -- Scaling the curve profile to match the desired peak
y = H1 + H2;
y = y - min(y(:));
y = amplitude .* y ./ max(y);
% -- Checking y-values are consistent
y((x>=center-0.5*width) & (x<center+0.5*width)) = amplitude;   % -- Ensure values on LHS edge are correct
y(y<amplitude) = 0;                     % -- Ensure all values <I0 are equal to zero
%% Validity check on the outputs
y(isnan(y)) = 0;
if isrow(x); if size(y, 2) ~= length(x); y = y'; end
elseif iscolumn(x); if size(y, 1) ~= length(x); y = y'; end
end
end