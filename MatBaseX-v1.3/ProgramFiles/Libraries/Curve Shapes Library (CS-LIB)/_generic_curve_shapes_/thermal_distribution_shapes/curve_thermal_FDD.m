function y = curve_thermal_FDD(x, center, temperature)
% y = curve_thermal_FDD(x, center, temperature)
%   A model based on the Fermi-Dirac Distribution (FDD). The model has 2
%   input parameters; center (fermi-energy) and temperature. This is the pure, 
%   theoretical FDD function. The parameter kt should be defined in the same 
%   units as x (kB = 8.617e-5 eV/K). This distribution function is used to
%   describe identical indistinguishable particles with half-integer spin
%   (fermions).
%
%   IN:
%   -   x:              N×1 (or 1×N) vector of the input domain
%   -   center:         scalar that defines the center along the x-axis (Fermi-level position)
%   -   temperature:    scalar that defines the temperature of the system
%
%   OUT:
%   -   y:              N×1 (or 1×N) vector of the output range

%% Default parameters
if nargin < 2; center = 0; end
if nargin < 3; temperature = 12;  end
if isempty(center); center = 0; end
if isempty(temperature); temperature = 12; end
%% Validity checks on the input parameters
if temperature < 0; temperature = 0; end        % -- If the temperature is <0, pad it to 0
%% 1 - Determination of the Fermi-Dirac Distribution
% Evaluating the FDD
y = 1 ./ (exp((x - center) ./ (8.617e-5 .* temperature)) + 1);
%% Validity check on the outputs
y(isnan(y)) = 0;
if isrow(x); if size(y, 2) ~= length(x); y = y'; end
elseif iscolumn(x); if size(y, 1) ~= length(x); y = y'; end
end
end