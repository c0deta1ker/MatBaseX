function F = calc_angle_aniso(formalism, beta, gamma, delta, theta, phi, P, material)
% F = calc_angle_aniso(formalism, beta, gamma, delta, theta, phi, P, material)
%   Thie function calculates the angular anisotropy factor for
%   photoemission using various formalisms. 
%
%   IN:
%   -   formalism:  string of the angular asymmetry formalism to use. Default:"Cant2022" ["Scofield1973","YehLindau1985","Trzhaskovskaya2018","Cant2022"]
%   -   beta:  	    scalar or Nx1 vector of the dipole asymmetry factor.
%   -   gamma:      scalar or Nx1 vector of the first non-dipole asymmetry factor.
%   -   delta:      scalar or Nx1 vector of the second non-dipole asymmetry factor.
%   -   theta:      scalar or 1xM vector of the polar emission angle of the photoelectrons relative to the surface normal (i.e. at normal emission = 0) [degree]
%   -   phi:        scalar of the azimuthal emission angle of the photoelectrons relative to the surface normal [degree]
%   -   P:          scalar of degree of polarization, where 1 or 0 is equivalent to full linear polarization, and 0.5 is equivalent to unpolarized light.
%   -   material:   char/string of the material beng probed; e.g. "Si", "InAs", "Al2O3"... This is used to determine the average Z number for the Scofield1973 &YehLindau1985 formalisms.
%
%   OUT:
%   -   F:      	scalar or NxM matrix of the angular anisotropy factor

%% Default parameters
if nargin < 5; theta = 0; end
if nargin < 6; phi = 0; end
if nargin < 7; P = 0.5; end
if nargin < 8; material = []; end
if isempty(theta); theta = 0; end
if isempty(phi); phi = 0; end
if isempty(P); P = 0.5; end
if isempty(material); material = []; end
%% Validity checks on the input parameters
formalism   = string(formalism);
material    = string(material); 
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
%% 2 - Calculating photoionization parameter
% -- Scofield1973 formalism
if ~isempty(find(strcmpi(formalism_s1973, formalism),1))
    F = 2.*ones(size(beta)).*ones(size(theta)).*ones(size(phi));
% -- YehLindau1985 formalism
elseif ~isempty(find(strcmpi(formalism_yl1985, formalism),1))
    material_props = get_mpd_props(material); avg_Z = material_props.atom_z;
    F = calc_angle_aniso_Fadj(beta, theta, phi, avg_Z);
% -- Trzhaskovskaya2018 formalism
elseif ~isempty(find(strcmpi(formalism_t2018, formalism),1))
    F = calc_angle_aniso_FP(beta, gamma, delta, theta, phi, P);
% -- Cant2020 formalism
elseif ~isempty(find(strcmpi(formalism_c2022, formalism),1))
    F = calc_angle_aniso_FP(beta, gamma, delta, theta, phi, P);
else; msg = 'Formalism not found. One of the following must be used: "S1973", "YL1985", "T2018" or "C2022".'; error(msg);
end
end