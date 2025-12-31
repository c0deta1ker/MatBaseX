function overlay_auger(elements, hv, parity)
% overlay_auger(elements, hv, parity)
%   This is a function that plots the binding energies of all the core-levels 
%   for a list of elements defined by the user. This can be used to 
%   quickly view all the available data for a particular element.
%
%   IN:
%   -   elements:	    1xN cell vector of strings of the element names; e.g. "H", "He", "Si", "In"...
%   -   hv:             scalar of the incident photon energy used to estimate the peak height [eV]
%   -   parity:	        either +1 or -1; 
%                               +1 plots the binding energies as positive. 
%                               -1 plots the binding energies as negative.
%
%   OUT: (none)

%% Initializing variables
ATOM_SYMB = read_mpd_elements();
ATOM_SYMB = ATOM_SYMB(1:93);
%% Default parameters
if nargin < 1; elements = ATOM_SYMB;  end
if nargin < 2; hv = [];  end
if nargin < 3; parity = 1;  end
if isempty(elements); elements = ATOM_SYMB; end
if isempty(hv); hv = []; end
if isempty(parity); parity = 1; end
%% Validity checks on the input parameters
elements            = string(elements);
%% 1 - Filing through all the selected elements and extracting Auger energies
num_of_elements     = length(elements);
for i = 1:num_of_elements
    [auger_energy_be{i}, auger_norm_mult{i}, auger_transition{i}] = calc_auger(elements{i}, hv, [], 0);
end
if parity == -1
    for i = 1:numel(auger_energy_be); auger_energy_be{i} = -auger_energy_be{i}; end
end
%% 2 - Overlaying the binding energy lines
hold on;
ax_lims = axis;
yval    = 0.75*max(ax_lims(3:4));
for i = 1:length(elements)
    colorList    = parula(num_of_elements+2);
    for j = 1:length(auger_energy_be{i})
        text(auger_energy_be{i}(j),  yval.*auger_norm_mult{i}(j), sprintf('%s%s(%.2f)', elements{i}, auger_transition{i}{j}, auger_energy_be{i}(j)),...
            'Rotation', 90, 'FontWeight','normal', 'FontSize' ,8, 'color', colorList(i,:));
        stem(auger_energy_be{i}(j), yval.*auger_norm_mult{i}(j), '-', 'linewidth', 1.50, 'marker', 'none', 'color', colorList(i,:)); 
    end
end
end