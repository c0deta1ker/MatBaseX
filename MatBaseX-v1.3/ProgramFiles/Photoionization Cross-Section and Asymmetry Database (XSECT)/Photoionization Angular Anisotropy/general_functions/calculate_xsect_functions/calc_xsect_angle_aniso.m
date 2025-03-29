function F = calc_xsect_angle_aniso(hv, element, corelevel, formalism, theta, phi, P, extrapolate, plot_results)
% F = calc_xsect_angle_aniso(hv, element, corelevel, formalism, theta, phi, P, material, plot_results)
%   A general function that calculates the angular anisotropy factor, F, 
%   for a given element & core-level. For the Scofield1973 formalism, F is
%   equal to 2 as no values for the dipole asymmetry factors are defined.
%   For the soft X-ray regime (10 - 1500 eV) the formalism YehLindau1985
%   should be used. For the hard X-ray regime (1000 - 10000 eV) the
%   formalism Cant 2022 should be used.
%
%   IN:
%   -   hv:             scalar or vector of the incident photon energies [eV]
%   -   element:    	string of the element; e.g. "H", "He", "Si", "In"...
%   -   corelevel:      string or vector of the core-levels to be probed; e.g. ["1s1", "2p1", "2p3", "3d3", "3d5", "5f5', "5f7"]
%   -   formalism:      string of the photoionization cross-section formalism to use. Default:"C2022" ["S1973", "Y1985", "T2018", "C2022"]
%   -   theta:          scalar or vector of the polar emission angle of the photoelectrons relative to the surface normal (i.e. at normal emission = 0) [degree]
%   -   phi:            scalar or vector of the azimuthal angle between the photon momentum vector relative to the projection of the photoelectron vector on to the plane perpendicular to the electric field vector (i.e. normal emission = 0) [degree]
%   -   P:              scalar of degree of polarization, where 1 or 0 is equivalent to full linear polarization, and 0.5 is equivalent to unpolarized light.
%   -   plot_results:   if 1, will plot figure summary, otherwise it wont.
%
%   OUT:
%   -   F:      	    4D matrix of the angular anisotropy factor. Matrix is of the form: FU[hv,corelevel,theta,phi].

%% Default parameters
if nargin < 5; theta = 0; end
if nargin < 6; phi = 0; end
if nargin < 7; P = 0.5; end
if nargin < 8; extrapolate = 0;  end
if nargin < 9; plot_results = 0;  end
if isempty(theta); theta = 0; end
if isempty(phi); phi = 0; end
if isempty(P); P = 0.5; end
if isempty(extrapolate);    extrapolate = 0; end
if isempty(plot_results); plot_results = 0; end
%% Validity checks on the input parameters
formalism   = string(formalism);
%% 1 - Defining all variants of formalisms
formalism_s1973     = [...
    "Scofield(1973)", "(1973)Scofield", "Scofield1973", "1973Scofield",...
    "Sco(1973)", "(1973)Sco", "Sco1973", "1973Sco",...
    "Scofield", "Sco", "S", "S1973", "1973"];
formalism_yl1985     = [...
    "YehLindau(1985)", "(1985)YehLindau", "YehLindau1985", "1985YehLindau",...
    "Yeh(1985)", "(1985)Yeh", "Yeh1985", "1985Yeh",...
    "Lindau(1985)", "(1985)Lindau", "Lindau1985", "1985Lindau",...
    "YL(1985)", "(1985)YL", "YL1985", "1985YL",...
    "Y", "L", "YL", "1985YL", "YL1985", "1985"];
formalism_t2018     = [...
    "Trz(2018)", "(2018)Trz", "Trz2018", "2018Trz",...
    "Trzh(2018)", "(2018)Trzh", "Trzh2018", "2018Trzh",...
    "Trzhaskovskaya(2018)", "(2018)Trzhaskovskaya", "Trzhaskovskaya2018", "2018Trzhaskovskaya",...
    "Trzhaskovskaya", "Trz", "T", "2018T", "T2018", "2018"];
formalism_c2022     = [...
    "Cant(2022)", "(2022)Cant", "Cant2022", "2022Cant",...
    "Cant", "Can", "2022C", "C2022", "2022"];
%% 2 - Calculating the angular anisotropy factor
% -- Scofield1973 formalism
if contains(formalism, formalism_s1973, "IgnoreCase", true)
    F = 2.*ones(size(beta));
% -- YehLindau1985 formalism
elseif contains(formalism, formalism_yl1985, "IgnoreCase", true)
    F = calc_xsect_angle_aniso_Fadj(hv, element, corelevel, theta, extrapolate, plot_results);
% -- Trzhaskovskaya2018 formalism
elseif contains(formalism, formalism_t2018, "IgnoreCase", true)
    F = calc_xsect_angle_aniso_FP(hv, element, corelevel, theta, phi, P, extrapolate, plot_results);
% -- Cant2020 formalism
elseif contains(formalism, formalism_c2022, "IgnoreCase", true)
    F = calc_xsect_angle_aniso_FP(hv, element, corelevel, theta, phi, P, extrapolate, plot_results);
else; msg = 'Formalism not found. One of the following must be used: "S1973", "YL1985", "T2018" or "C2022".'; error(msg);
end
end