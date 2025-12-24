function rsf = calc_rsf(material, element, corelevel, hv, theta, phi, P, formalism_xsect, formalism_imfp, extrapolate)
% rsf = calc_rsf(material, element, corelevel, hv, theta, phi, P, formalism_xsect, formalism_imfp, extrapolate)
%   Function that determines the Relative Sensitivity Factor (RSF) in X-ray 
%   photoelectron spectroscopy (XPS) using only fundamental parameters. The 
%   RSF is calcualted relative to the C(1s) core-level, as is typically 
%   standard. For more details on the SF calculation, see calc_sf() or [1].
%       [1] David J. H. Cant, Ben F. Spencer, Wendy R. Flavell, Alexander G. Shard. Surf Interface Anal. 2022; 54(4): 442-454. doi:10.1002/sia.7059
%
%   IN:
%   -   material:           char/string of the material; e.g. "Si", "InAs", "Al2O3"...
%   -   element:    	    string of the element; e.g. "H", "He", "Si", "In"...
%   -   corelevel:          string of the core-level to be probed; e.g. "5s1", "5p1", "5p3", "5d3", "5d5", "5f5', "5f7"...
%   -   hv:                 scalar or N×1 vector of the incident photon energies [eV]
%   -   theta:              scalar or 1×M of the polar angle between the photoelectron vector relative to electric field vector (i.e. at normal emission: LV (p-pol, E//MP) = 0, LH (s-pol, E⊥MP) = 90) [degree]
%   -   phi:                scalar of the azimuthal angle between the photon momentum vector relative to the projection of the photoelectron vector on to the plane perpendicular to the electric field vector (i.e. normal emission = 0) [degree]
%   -   P:                  scalar of degree of polarization, where 1 or 0 is equivalent to full linear polarization, and 0.5 is equivalent to unpolarized light.
%   -   formalism_xsect:    string of the photoionization cross-section formalism_xsect to use. Default:"Cant2022" ["Scofield1973","YehLindau1985","Trzhaskovskaya2018","Cant2022"]
%   -   formalism_imfp:     string for imfp calculator formalism_xsect. Default:"S2" ["Universal","TPP2M","TPP2M-avg","Optical","S1","S2","S3","S3-organic","S4"]
%   -   extrapolate:        either 0 or 1; if true, it will extrapolate photoionization xsect beyond the conventional range, otherwise not
%
%   OUT:
%   -   rsf:      	        scalar or N×1 vector of the RSF factor

%% -- Validity check on inputs
if nargin < 5; theta = 0;  end
if nargin < 6; phi = 0;  end
if nargin < 7; P = 0.5;  end
if nargin < 8; formalism_xsect = "Cant2022"; end
if nargin < 9; formalism_imfp = "JTP"; end
if nargin < 10; extrapolate = 0;  end
if isempty(material); material = element; end
if isempty(theta); theta = 0; end
if isempty(phi); phi = 0; end
if isempty(P); P = 0.5; end
if isempty(formalism_xsect); formalism_xsect = "Cant2022"; end
if isempty(formalism_imfp); formalism_imfp = "JTP"; end
if isempty(extrapolate); extrapolate = 0; end
%% 1 : XPS Sensitivity Factor of C1s
[sf_C1s, ~]     = calc_sf("C", "C", "1s1", hv, theta, phi, P, formalism_xsect, formalism_imfp, extrapolate);
%% 2 : XPS Sensitivity Factor of Element of Interest
[sf, ~]         = calc_sf(material, element, corelevel, hv, theta, phi, P, formalism_xsect, formalism_imfp, extrapolate);
%% 3 : Relative Sensitivity Factor
rsf = sf ./ sf_C1s;
end