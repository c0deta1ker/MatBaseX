function [auger_transition, auger_energy_ke, auger_energy_be, auger_norm_mult] = calc_auger_perkins1991(element, hv, plot_results)
% [auger_transition, auger_energy_ke, auger_energy_be, auger_norm_mult] = calc_auger_perkins1991(element, hv, plot_results)
%   This function extracts Auger electron kinetic and binding energies
%   for elements with atomic numbers Z = 1–93, based on the tabulated data
%   from S. T. Perkins et al. [1]. The dataset has been digitized here for
%   direct use within MATLAB.
%   [1] S.T.Perkins, D.E.Cullen, et al., Tables and graphs of atomic 
%       sub-shell and relaxation data derived from the LLNL Evaluated Atomic Data Library (EADL), 
%       Z = 1--100 Lawrence Livermore National Laboratory, UCRL-50400, Vol. 30
%
%   IN:
%   -   element:    	string of the element; e.g. "H", "He", "Si", "In"...
%   -   hv:             scalar of the incident photon energies [eV].
%   -   plot_results:   if 1, will plot figure summary, otherwise it wont.
%
%   OUT:
%   -   auger_transition:   M×1 vector of the Auger transition labels.
%   -   auger_energy_ke:    M×1 vector of the Auger kinetic energies [eV].
%   -   auger_energy_be:    M×1 vector of the Auger binding energies, calculated using the input hv [eV].
%   -   auger_norm_mult:    M×1 vector of the Auger normalization multiplier [unitless].

%% Default parameters
if nargin < 2; hv = [];  end
if nargin < 3; plot_results = 0;  end
if isempty(hv); hv = []; end
if isempty(plot_results); plot_results = 0; end
%% Validity checks on the input parameters
element     = string(element);
hv          = double(hv);
%% 1 - Loading the MATLAB data structure
AE_DB_Perkins1991	= load('AE_DB_Perkins1991.mat'); AE_DB_Perkins1991 = AE_DB_Perkins1991.AE_DB_Perkins1991;
ATOM_SYMB           = string(AE_DB_Perkins1991.ATOM_SYMB);
AUGER_DATA          = AE_DB_Perkins1991.AUGER_DATA;
%% 2 - Find the database index of the defined element
ele_indx 	= find(strcmpi(ATOM_SYMB, element), 1);
if isempty(ele_indx); msg = 'Element could not be identified. Only use atomic-symbols for elements 1 - 93; H, He, Li, Be..., U, Np'; error(msg); end
%% 3 - Find the database values of the defined element
T = AUGER_DATA{ele_indx};
% If no photon energy is defined, use all available ones
if isempty(hv) || hv == 0 || hv < 0
    auger_transition    = T.Auger_Transition;
    auger_energy_ke     = T.Auger_Energies_KE;
    auger_energy_be     = auger_energy_ke;
    auger_norm_mult     = T.Norm_Mult;
% Otherwise, parse the input
else
    rows_to_delete          = T.Auger_Energies_KE > hv;
    T(rows_to_delete, :)    = [];
    auger_transition        = T.Auger_Transition;
    auger_energy_ke         = T.Auger_Energies_KE;
    auger_energy_be         = hv - auger_energy_ke;
    auger_norm_mult         = T.Norm_Mult;
end
%% -- Plot for debugging
if plot_results == 1
    formalismList   = read_formalisms('auger');
    formalism       = formalismList{1}; 
    plt_result_auger(element, formalism, hv, auger_transition, auger_energy_be, auger_norm_mult);
end
end