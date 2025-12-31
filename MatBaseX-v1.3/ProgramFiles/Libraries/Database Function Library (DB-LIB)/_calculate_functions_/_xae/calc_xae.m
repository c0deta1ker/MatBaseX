function [edge_energy, edge_name, edge_width, edge_jump] = calc_xae(element, edgenames, formalism, plot_results)
% [edge_energy, edge_name, edge_width, edge_jump] = calc_xae(element, edgenames, formalism, plot_results)
%   This is a general function that extracts the x-ray absorption edge
%   characteristics for a given element & absorption edge. Currently, only
%   one formalism is used (see ref. [1]), the IXAS(2025) database.
%
%   IN:
%   -   element:    	string of the element; e.g. "H", "He", "Si", "In"...
%   -   edgenames:      M×1 string array of the edges to be probed; e.g. ["K", "L2"]... (If empty, will return all known absorption edges.)
%   -   formalism:      string of the x-ray absorption edge cross-section formalism to use. Default:"IXAS2025" ["IXAS2025"]
%   -   plot_results:   if 1, will plot figure summary, otherwise it wont.
%
%   OUT:
%   OUT:
%   -   edge_energy:    M×1 vector of the absorption edge energies [eV]. Returns NaN for undefined edge energies.
%   -   edge_name:      M×1 vector of the absorption edge names.
%   -   edge_width:     M×1 vector of the absorption edge width [eV]. Returns NaN for undefined edge energies.
%   -   edge_jump:      M×1 vector of the absorption edge jump. Returns NaN for undefined edge energies.
%
%   SEE REFERENCES:
%   [1] https://xraydb.xrayabsorption.org/element/

%% Default parameters
if nargin < 2; edgenames = [];  end
if nargin < 3; formalism = "IXAS2025";  end
if nargin < 4; plot_results = 0;  end
if isempty(edgenames); edgenames = []; end
if isempty(formalism); formalism = "IXAS2025"; end
if isempty(plot_results); plot_results = 0; end
%% Validity checks on the input parameters
formalism   = string(formalism);
%% 1 - Defining all variants of EDGE formalisms
formalism_IXAS2025     = [...
    "IXAS(2025)", "(2025)IXAS", "IXAS2025", "2025IXAS",...
    "I(2025)", "(2025)I", "I2025", "I2025",...
    "IXAS", "2025"];
%% 2 - Determination of the x-ray absorption edges
% -- IXAS2025 formalism
if ~isempty(find(strcmpi(formalism_IXAS2025, formalism),1))
   [edge_energy, edge_name, edge_width, edge_jump] = calc_xae_ixas2025(element, edgenames, plot_results);
else; msg = 'Formalism not found. One of the following must be used: "IXAS2025".'; error(msg);
end
end