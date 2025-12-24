function [dr, dz] = calc_pyxl_resolution(theta, num_of_proj, actv_lyr_thickness)
% [dr, dz] = calc_pyxl_resolution(theta, num_of_proj, actv_lyr_thickness)
%   This is a function that calculates the in-plane and out-of-plane
%   spatial resolution for Ptychographic X-Ray Laminography (PyXL) using
%   the equations from reference [1]. Given the x-ray incidence angle,
%   total number of projections and active layer thickness, this can be
%   determined.
%
%   IN:
%   -   theta:    	            scalar of the angle of incidence of the x-ray radiation relative to the surface parallel line (i.e. normal emission = 90) [degrees]
%   -   num_of_proj:            scalar or vector of the total number of projections to be measured
%   -   actv_lyr_thickness:     scalar or vector of the active layer thickness probed by x-rays [μm]
%
%   OUT:
%   -   dr:                     scalar, vector or array output of the planar resolution using PyXL technique [nm]
%   -   dz:                     scalar, vector or array output of the out-of-plane resolution using PyXL technique [nm]
%
%   SEE REFERENCES:
%       [1] Holler, M.; Odstrcil, M.; Guizar-Sicairos, M.; Lebugle, M.; Müller, E.; Finizio, S.; Tinti, G.; David, 
%           C.; Zusman, J.; Unglaub, W.; Bunk, O.; Raabe, J.; Levi, A. F. J.; Aeppli, G. 
%           Three-Dimensional Imaging of Integrated Circuits with Macro- to Nanoscale Zoom. Nat Electron 2019, 2 (10), 464–470. https://doi.org/10.1038/s41928-019-0309-z.

%% 1 - Calculating Spatial Resolutions
dr      = pi * (actv_lyr_thickness ./ num_of_proj) *tan(deg2rad(theta));
dr      = dr*1000;
dz      = dr ./ sin(deg2rad(theta));
end