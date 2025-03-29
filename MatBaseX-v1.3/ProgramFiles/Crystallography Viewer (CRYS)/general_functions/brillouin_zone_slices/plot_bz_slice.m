function h = plot_bz_slice(bzSlice, varargin)
% h = plot_bz_slice(bzSlice, varargin)
%   This is a function that plots the planar Brilluoin zone 
%   extracted from the 'get_bz_slice()' function.
%
%   IN:
%   -   bzSlice:        MATLAB data structure containing BZ slice data from 'get_bz_slice()'
%   -   varargin:       LineSpec arguments: Line style, marker, and color, specified as a string scalar or character vector containing symbols.
%
%   OUT:
%   -   h:              Line properties

%% Default parameters
if nargin < 2; varargin = {}; end
if isempty(varargin); varargin = {}; end
%% - 1 - Plotting the BZ slices
hold on;
ax = gca;
XLim = ax.XLim; YLim = ax.YLim; 
for i = 1:length(bzSlice.X)
    h(i) = plot(bzSlice.X{i}, bzSlice.Y{i}, 'k-', varargin{:});
end
axis([XLim, YLim]);
end