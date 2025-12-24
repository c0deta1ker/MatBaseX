function core_levels = read_be_core_levels(element)
% core_levels = read_be_core_levels(element)
%   This function returns a cell array containing electron core-levels
%   that are defined for an element. If no element is entered, then all
%   core-levels with principle quantum numbers 1 - 7, with angular momentum
%   quantum numbers s, p, d & f are returned. These are the most commonly 
%   probed core-levels.
%
%   IN:
%   -   element:    	string of the element; e.g. "H", "He", "Si", "In"...
%
%   OUT:
%   -   core_levels:    1xN cell array of the core-levels

%% Default parameters
if nargin < 1; element = [];  end
if isempty(element); element = []; end
%% Validity checks on the input parameters
element   = string(element);
%% 1 : Defining Core-Levels
if ~isempty(element)
    [~, core_levels] = calc_be(element);
else
    core_levels   = {...
        '1s1',...
        '2s1', '2p1', '2p3',...
        '3s1', '3p1', '3p3', '3d3', '3d5',...
        '4s1', '4p1', '4p3', '4d3', '4d5', '4f5', '4f7',...
        '5s1', '5p1', '5p3', '5d3', '5d5', '5f5', '5f7',...
        '6s1', '6p1', '6p3', '6d3', '6d5', '6f5', '6f7',...
        '7s1', '7p1', '7p3', '7d3', '7d5', '7f5', '7f7',...
        };
end
end