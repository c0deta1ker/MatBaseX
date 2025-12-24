function [auger_energy_be, auger_norm_mult, auger_transition] = calc_auger(element, hv, formalism, plot_results)
% [auger_energy_be, auger_norm_mult, auger_transition] = calc_auger(element, hv, formalism, plot_results)
%   This function extracts Auger electron kinetic and binding energies
%   for elements with atomic numbers Z = 1–93. Based on the tabulated data
%   from S. T. Perkins et al. [1].
%
%   IN:
%   -   element:    	string of the element; e.g. "H", "He", "Si", "In"...
%   -   hv:             scalar of the incident photon energies [eV].
%   -   formalism:      string of the Auger energy formalism to use. Default:"P1991" ["P1991"]
%   -   plot_results:   if 1, will plot figure summary, otherwise it wont.
%
%   OUT:
%   -   auger_transition:   M×1 vector of the Auger transition labels.
%   -   auger_energy_ke:    M×1 vector of the Auger kinetic energies [eV].
%   -   auger_energy_be:    M×1 vector of the Auger binding energies, calculated using the input hv [eV].
%   -   auger_norm_mult:    M×1 vector of the Auger normalization multiplier [unitless].
%
%   SEE REFERENCES:
%   [1] S.T.Perkins, D.E.Cullen, et al., Tables and graphs of atomic 
%       sub-shell and relaxation data derived from the LLNL Evaluated Atomic Data Library (EADL), 
%       Z = 1--100 Lawrence Livermore National Laboratory, UCRL-50400, Vol. 30

%% Default parameters
if nargin < 2; hv = [];  end
if nargin < 3; formalism = "P1991";  end
if nargin < 4; plot_results = 0;  end
if isempty(hv); hv = []; end
if isempty(formalism); formalism = "P1991"; end
if isempty(plot_results); plot_results = 0; end
%% Validity checks on the input parameters
formalism   = string(formalism);
%% 1 - Defining all variants of BE formalisms
formalism_p1991     = [...
    "Perkins(1991)", "(1991)Perkins", "Perkins1991", "1991Perkins",...
    "Per(1991)", "(1991)Per", "Per1991", "1991Per",...
    "Perkins", "Per", "P", "P1991", "1991"];
%% 2 - Determination of the atomic photoionization BE
% -- Perkins1991 formalism
if contains(formalism, formalism_p1991, "IgnoreCase", true)
   [auger_transition, ~, auger_energy_be, auger_norm_mult] = calc_auger_perkins1991(element, hv, plot_results);
else; msg = 'Formalism not found. One of the following must be used: "Per1991".'; error(msg);
end
end