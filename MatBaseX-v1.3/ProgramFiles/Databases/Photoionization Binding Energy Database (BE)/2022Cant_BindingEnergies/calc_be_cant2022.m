function [be, cls] = calc_be_cant2022(element, corelevel, plot_results)
% [be, cls] = calc_be_cant2022(element, corelevel, plot_results)
%   This is a function that extracts the electron binding energies from elements
%   with Z from 1 to 98 of the individual subshells. This is from the original
%   work of David J. H. Cant [1], which has now been digitised here for use in
%   MATLAB.
%   [1] David J. H. Cant, Ben F. Spencer, Wendy R. Flavell, Alexander G. Shard. Surf Interface Anal. 2022; 54(4): 442-454. doi:10.1002/sia.7059
%
%   IN:
%   -   element:    	string of the element; e.g. "H", "He", "Si", "In"...
%   -   corelevel:      M×1 string array of the core-levels to be probed; e.g. ["2s1", "5p3"]... (If empty, will return all core-levels with a known binding energy.)
%   -   plot_results:   if 1, will plot figure summary, otherwise it wont.
%
%   OUT:
%   -   be:             M×1 vector of the binding energies of the chosen core-levels [eV]. Returns NaN for undefined binding energies.
%   -   cls:            M×1 vector of the core-level labels.

%% Default parameters
if nargin < 2; corelevel = [];  end
if nargin < 3; plot_results = 0;  end
if isempty(corelevel); corelevel = []; end
if isempty(plot_results); plot_results = 0; end
%% Disable warning back-trace
warning('off', 'backtrace');
%% Validity checks on the input parameters
element     = string(element);
corelevel   = string(corelevel);
%% 1 - Loading the MATLAB data structure
BE_DB_Cant2022	= load('BE_DB_Cant2022.mat'); BE_DB_Cant2022 = BE_DB_Cant2022.BE_DB_Cant2022;
ATOM_SYMB   = string(BE_DB_Cant2022.ATOM_SYMB);
ATOM_CL     = string(BE_DB_Cant2022.ATOM_CL);
ATOM_BE     = table2array(BE_DB_Cant2022.BE);
%% 2 - Find the database index of the defined element
ele_indx 	= find(strcmpi(ATOM_SYMB, element), 1);
if isempty(ele_indx); msg = 'Element could not be identified. Only use atomic-symbols for elements 1 - 98; H, He, Li, Be..., Bk, Cf'; error(msg); end
%% 3 - Find the database index of the defined core-levels
% If no core-level is defined, use all available ones
if isempty(corelevel); cl_indx = 1:length(ATOM_CL); 
% Otherwise, parse the input
else
    % - If 1 core-level is entered
    if isscalar(corelevel)
        cl_indx 	= find(strcmpi(ATOM_CL, corelevel), 1);
        if isempty(cl_indx)
            cl_indx = 0; msg = sprintf("Core-level %s not found. Only the following exist for %s : %s . NaN values returned.", corelevel, element, join(string(ATOM_CL), ', ')); warning(msg); 
        end
    % - If a string array of core-levels is entered
    else
        cl_indx = zeros(size(corelevel));
        for i = 1:length(corelevel)
            ith_corelevel   = corelevel(i);
            idx             = find(ATOM_CL == ith_corelevel);
            % --- If the core-level is not found
            if ~isempty(idx);   cl_indx(i) = idx;
            else;               cl_indx(i) = 0;
                msg = sprintf("Core-level %s not found. Only the following exist for %s : %s . NaN values returned.", corelevel(i), element, join(string(ATOM_CL), ', ')); warning(msg); 
            end
        end
    end
end
%% 4 - Extracting the relevant binding energies
be = []; cls = "";
for i = 1:length(cl_indx)
    if cl_indx(i) == 0
        cls(i)  = NaN(1);
        be(i)   = NaN(1);
    else
        cls(i)  = ATOM_CL(cl_indx(i));
        be(i)   = ATOM_BE(ele_indx,cl_indx(i));
    end
end
%% Validity check on the outputs
% -- If no initial corelevel input was made, then remove all NaN entries
if isempty(corelevel)
    NaN_idx         = isnan(be);
    cls(NaN_idx)    = [];
    be(NaN_idx)     = [];
% -- Otherwise, preserve the labels that were user-defined
else
    NaN_idx         = find(cl_indx == 0);
    cls(NaN_idx)    = corelevel(NaN_idx);
end
% -- Ensure that the outputs are in columns
if size(cls, 2) > 1;  cls = cls'; end
if size(be, 2) > 1;  be = be'; end
%% Enable warning back-trace
warning('on', 'backtrace');
%% -- Plot for debugging
if plot_results == 1
    formalismList   = read_formalisms('be');
    formalism       = formalismList{2}; 
    plt_result_be(element, formalism, be, cls);
end
end