function overlay_be(elements, parity, energy_lims)
% overlay_be(elements, parity, energy_lims)
%   This is a function that plots the binding energies of all the core-levels 
%   for a list of elements defined by the user. This can be used to 
%   quickly view all the available data for a particular element.
%
%   IN:
%   -   element:	    1xN cell vector of strings of the element names; e.g. "H", "He", "Si", "In"...
%   -   parity:	        either 1 or -1; 1 plots the binding energies as positive. -1 plots the binding energies as negative.
% 	-   energy_lims:    [1×2] row vector of binding energy range to plot
%
%   OUT: (none)

%% Initializing variables
ATOM_SYMB = read_mpd_elements();
ATOM_SYMB = ATOM_SYMB(1:98);
%% Default parameters
if nargin < 1; elements = ATOM_SYMB;  end
if nargin < 2; parity = 1;  end
if nargin < 3; energy_lims = [1, 130000];  end
if isempty(elements); elements = ATOM_SYMB; end
if isempty(parity); parity = 1; end
if isempty(energy_lims); energy_lims = [1, 130000]; end
%% Validity checks on the input parameters
elements    = string(elements);
energy_lims = sort(energy_lims);
%% 1 - Filing through all the selected elements and extracting binding energies
be = {}; cls = {};
for i = 1:length(elements)
    % -- Extracting all binding energies of the selected element
    [be{i}, cls{i}] = calc_be(elements{i}); 
    % -- Removing all entries that lies outside of the energy limits
    cls{i}(be{i}<energy_lims(1)) = []; be{i}(be{i}<energy_lims(1)) = [];
    cls{i}(be{i}>energy_lims(2)) = []; be{i}(be{i}>energy_lims(2)) = [];
end
%% 2 - Ensuring consistency in parity and energy limits
if parity == -1
    energy_lims = sort(-1 .* abs(energy_lims));
    for i = 1:length(be); be{i} = -1 .* be{i}; end
elseif parity == +1
    energy_lims = sort(+1 .* abs(energy_lims));
    for i = 1:length(be); be{i} = +1 .* be{i}; end
end
%% 3 - Overlaying the binding energy lines
hold on;
ax_lims = axis;
yval    = 0.75*max(ax_lims(3:4));
for i = 1:length(be)
    cols    = lines(length(be));
    for j = 1:length(be{i})
        be_ij = be{i}(j);
        xline(be_ij, ':', 'linewidth', 1.2, 'color', cols(i,:), 'HandleVisibility','off');
        str = sprintf('%s%s(%.2f)', elements{i}, cls{i}{j}, be_ij);
        text(be_ij+0.15, yval, str, 'Rotation',90, 'FontWeight','normal', 'FontSize', 8, 'color', cols(i,:));
    end
end
end