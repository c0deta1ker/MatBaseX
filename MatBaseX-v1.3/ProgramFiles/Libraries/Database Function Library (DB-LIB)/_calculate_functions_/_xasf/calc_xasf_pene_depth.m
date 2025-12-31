function penetration_depth = calc_xasf_pene_depth(mu, alpha)
% penetration_depth = calc_xasf_pene_depth(mu, alpha)
%   This function calculates the x-ray penetration depth, which is defined
%   as the depth at which the intensity of the x-rays inside the material 
%   falls to 1/e (about 37%) of its original value.
%
%   IN:
%   -   mu:                 scalar or vector of the mass linear attenuation coefficient [cm]
%   -   alpha:              scalar or vector of the x-ray incidence angle
%
%   OUT:
%   -   penetration_depth:  scalar or vector of the penetration depth [nm]

%% Default parameters
if nargin < 2; alpha = 0; end
if isempty(alpha); alpha = 0; end
%% - 1 - Determination of the ID
penetration_depth = ((1./mu).* sin(deg2rad(alpha))).*1e7;
end