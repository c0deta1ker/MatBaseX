function [be, cls] = calc_be(element, corelevel, formalism, plot_results)
% [be, cls] = calc_be(element, corelevel, formalism, plot_results)
%   This is a general function that extracts the electron binding energies 
%   from elements with Z from 1 to 98 of the individual subshells. The
%   values are from different sources in the literature. The Moulder (1993) [1],  
%   Trzhaskovskaya (2018) [2] and Cant (2022) [3] formalisms are currently
%   available. The Constantinou (2023) database is a combination of all
%   core-level data from all previous work. The user can define the element 
%   and core-level/s.
%
%   IN:
%   -   element:    	string of the element; e.g. "H", "He", "Si", "In"...
%   -   corelevel:      M×1 string array of the core-levels to be probed; e.g. ["2s1", "5p3"]... (If empty, will return all core-levels with a known binding energy.)
%   -   formalism:      string of the photoionization cross-section formalism to use. Default:"C2023" ["M1993", "T2018", "C2022", "C2023"]
%   -   plot_results:   if 1, will plot figure summary, otherwise it wont.
%
%   OUT:
%   -   be:             M×1 vector of the binding energies of the chosen core-levels [eV]. Returns [] for undefined core-level energies.
%   -   cls:            M×1 vector of the core-level labels. Returns [] for undefined core-level energies.
%
%   SEE REFERENCES:
%   [1] John F. Moulder, Handbook of X-ray Photoelectron Spectroscopy, 1993.
%   [2] M.B. Trzhaskovskaya, V.G. Yarzhemsky. Atomic Data and Nuclear Data Tables 119 (2018) 99–174. Web. doi:10.1016/j.adt.2017.04.003
%   [3] David J. H. Cant, Ben F. Spencer, Wendy R. Flavell, Alexander G. Shard. Surf Interface Anal. 2022; 54(4): 442-454. doi:10.1002/sia.7059

%% Default parameters
if nargin < 2; corelevel = [];  end
if nargin < 3; formalism = "C2023";  end
if nargin < 4; plot_results = 0;  end
if isempty(corelevel); corelevel = []; end
if isempty(formalism); formalism = "C2023"; end
if isempty(plot_results); plot_results = 0; end
%% Validity checks on the input parameters
formalism   = string(formalism);
%% 1 - Defining all variants of BE formalisms
formalism_m1993     = [...
    "Moulder(1993)", "(1993)Moulder", "Moulder1993", "1993Moulder",...
    "Mou(1993)", "(1993)Mou", "Mou1993", "1993Mou",...
    "Moulder", "Mou", "M", "M1993", "1993"];
formalism_t2018     = [...
    "Trz(2018)", "(2018)Trz", "Trz2018", "2018Trz",...
    "Trzh(2018)", "(2018)Trzh", "Trzh2018", "2018Trzh",...
    "Trzhaskovskaya(2018)", "(2018)Trzhaskovskaya", "Trzhaskovskaya2018", "2018Trzhaskovskaya",...
    "Trzhaskovskaya", "Trz", "T", "T2018", "2018"];
formalism_c2022     = [...
    "Cant(2022)", "(2022)Cant", "Cant2022", "2022Cant",...
    "Cant", "Can", "C2022", "2022"];
formalism_c2023     = [...
    "Constantinou(2023)", "(2023)Constantinou", "Constantinou2023", "2023Constantinou",...
    "Cons(2023)", "(2023)Cons", "Cons2023", "2023Cons",...
    "Constantinou", "Constant", "Con", "C2023", "2023"];
%% 2 - Determination of the atomic photoionization BE
% -- Moulder1993 formalism
if contains(formalism, formalism_m1993, "IgnoreCase", true)
   [be, cls] = calc_be_moulder1993(element, corelevel, plot_results);
% -- Trzhaskovskaya2018 formalism
elseif contains(formalism, formalism_t2018, "IgnoreCase", true)
   [be, cls] = calc_be_trzh2018(element, corelevel, plot_results);
% -- Cant2020 formalism
elseif contains(formalism, formalism_c2022, "IgnoreCase", true)
   [be, cls] = calc_be_cant2022(element, corelevel, plot_results);
% -- Constantinou2023 formalism
elseif contains(formalism, formalism_c2023, "IgnoreCase", true)
    [be, cls] = calc_be_constantinou2023(element, corelevel, plot_results);
else; msg = 'Formalism not found. One of the following must be used: "Mou1993", "Trz2018", "Cant2022" or "Cons2023".'; error(msg);
end
end