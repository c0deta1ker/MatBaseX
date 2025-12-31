function edge_names = read_xae_edges(element)
% edge_names = read_xae_edges(element)
%   This function returns a cell array containing x-ray absorption edges
%   that are defined for a given element. If no element is entered, then all
%   absorption edges are defined with principle quantum numbers 1 - 7 
%   (K,L,M,N,O,P,Q), with angular momentum quantum numbers s, p, d & f. 
%   These are the most commonly probed core-levels.
%
%   IN:
%   -   element:    	string of the element; e.g. "H", "He", "Si", "In"...
%
%   OUT:
%   -   edge_name:      1xN cell array of the edge names

%% Default parameters
if nargin < 1; element = [];  end
if isempty(element); element = []; end
%% Validity checks on the input parameters
element   = string(element);
%% 1 : Defining Absorption edges
if ~isempty(element)
    [~, edge_names] = calc_xae(element);
else
    edge_names   = {...
        'K1',...
        'L1', 'L2', 'L3',...
        'M1', 'M2', 'M3', 'M4', 'M5',...
        'N1', 'N2', 'N3', 'N4', 'N5', 'N6', 'N7',...
        'O1', 'O2', 'O3', 'O4', 'O5', 'O6', 'O7',...
        'P1', 'P2', 'P3', 'P4', 'P5', 'P6', 'P7',...
        'Q1', 'Q2', 'Q3', 'Q4', 'Q5', 'Q6', 'Q7',...
        };
end
end