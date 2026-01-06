function overlay_auger(elements, hv, parity, energy_lims)
% overlay_auger(elements, hv, parity, energy_lims)
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
% 	-   energy_lims:    [1×2] row vector of energy limits of absorption edges to be plotted
%
%   OUT: (none)

%% Initializing variables
ATOM_SYMB = read_mpd_elements();
ATOM_SYMB = ATOM_SYMB(1:93);
%% Default parameters
if nargin < 1; elements = ATOM_SYMB;  end
if nargin < 2; hv = [];  end
if nargin < 3; parity = 1;  end
if nargin < 4; energy_lims = [];  end
if isempty(elements); elements = ATOM_SYMB; end
if isempty(hv); hv = []; end
if isempty(parity); parity = 1; end
if isempty(energy_lims); energy_lims = []; end
%% Validity checks on the input parameters
elements            = string(elements);
energy_lims         = sort(energy_lims);
num_of_elements     = length(elements);
%% 1 - Filing through all the selected elements and extracting Auger energies
for i = 1:num_of_elements
    [auger_energy_be{i}, auger_norm_mult{i}, auger_transition{i}] = calc_auger(elements{i}, hv, [], 0);
end
%% 2 - Extracting the parity of the Auger transition energies
if parity == -1;        for i = 1:length(auger_energy_be); auger_energy_be{i} = -1 .* auger_energy_be{i}; end
elseif parity == +1;    for i = 1:length(auger_energy_be); auger_energy_be{i} = +1 .* auger_energy_be{i}; end
end
% -- Removing all entries that lies outside of the energy limits
for i = 1:num_of_elements
    if ~isempty(energy_lims)
        % -- Lower bound
        auger_transition{i}(auger_energy_be{i}<energy_lims(1)) = []; 
        auger_norm_mult{i}(auger_energy_be{i}<energy_lims(1)) = []; 
        auger_energy_be{i}(auger_energy_be{i}<energy_lims(1)) = [];
        % -- Upper bound
        auger_transition{i}(auger_energy_be{i}>energy_lims(2)) = []; 
        auger_norm_mult{i}(auger_energy_be{i}>energy_lims(2)) = []; 
        auger_energy_be{i}(auger_energy_be{i}>energy_lims(2)) = []; 
    end
end
%% 3 - Overlaying the binding energy lines
hold on;
ax_lims = axis;
aheight = linspace(0.60, 0.80, length(auger_energy_be));
for i = 1:length(elements)
    cols    = lines(length(auger_energy_be));
    yval    = aheight(i)*max(ax_lims(3:4));
    for j = 1:length(auger_energy_be{i})
        ae_ij = auger_energy_be{i}(j);
        stem(ae_ij, yval, ':',...
            'linewidth', 1.25, 'marker', 'none', 'color', cols(i,:), 'HandleVisibility','off');
        str = sprintf('%s%s(%.2f)', elements{i}, auger_transition{i}{j}, ae_ij);
        text(ae_ij, yval, str,...
            'Rotation', 90, 'FontWeight','normal', 'FontSize', 8, 'color', cols(i,:),...
            'HorizontalAlignment','left'); 
    end
end
end