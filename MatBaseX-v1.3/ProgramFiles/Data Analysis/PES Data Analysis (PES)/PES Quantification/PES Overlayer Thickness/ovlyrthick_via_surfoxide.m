function oxide_thickness = ovlyrthick_via_surfoxide(alpha, I_metal, N_metal, lambda_metal, I_oxide, N_oxide, lambda_oxide)
% oxide_thickness = ovlyrthick_via_surfoxide(alpha, I_metal, N_metal, lambda_metal, I_oxide, N_oxide, lambda_oxide)
%   Function that determines the thickness of an oxide layer via XPS using
%   and empirical formula that is know to be accurate [1]. The thickness is 
%   calculated from the relative photoelectron intensity, volume density and
%   inelastic mean free path (IMFP) of the metal and oxide photoelectron
%   peak. The model assumes that the substrate is infinitely thick, 
%   with a uniform oxide on top. 
%   [1] M. R. Alexander, Quantification of oxide film thickness at the surface of aluminium using XPS (2002)
%
%   IN:
%   -   alpha:              photoelectron take-off angle relative to the surface normal (i.e. normal emission = 0) [degrees]
%   -   I_metal:  	        total peak area of the underlying metal photoelectron peak.
%   -   N_metal:  	        volume density of the underlying metal [g/cc].
%   -   lambda_metal:  	    attenuation length of electrons in the underlying metal [nm or Angstrom].
%   -   I_oxide:  	        total peak area of the overlayer oxide photoelectron peak.
%   -   N_oxide:  	        volume density of the overlayer oxide [g/cc].
%   -   lambda_oxide:  	    attenuation length of electrons in the overlayer oxide [nm or Angstrom].
%
%   OUT:
%   -   oxide_thickness:    thickness of the oxide layer [nm or Angstrom].
%
%   USEFUL INFORMATION:
%       - Si: 
%               Nm / No = 1.8 (Si = 2.33 g/cc, SiO2 = 2.65 g/cc); 
%               lambda_m / lambda_ox = 0.95 (lambda_Si = 2.29 nm, lambda_SiO2 = 2.41 nm);
%       - AlOx: 
%               Nm / No = 1.6 (Al = 2.7 g/cc, AlOx = 3.1 g/cc); 
%               lambda_m / lambda_ox = 0.78 (lambda_Al = 2.58 nm, lambda_AlOx = 3.28 nm);
%       - PbOx: 
%               Nm / No = 1.19 (Pb = 11.35 g/cc, PbOx = 9.53 g/cc); 
%               lambda_m / lambda_ox = 1.22 (lambda_Pb = 2.28 nm, lambda_PbOx = 1.87 nm);

%% 1 : Determination of the oxide thickness
oxide_thickness = lambda_oxide .* cos(deg2rad(alpha)) .* log(1 + (I_oxide./(N_oxide.*lambda_oxide)) ./ (I_metal./(N_metal.*lambda_metal)));
oxide_thickness
end