function xsect_beta = calc_xsect_beta(hv, element, corelevel, formalism, extrapolate, plot_results)
% xsect_beta = calc_xsect_beta(hv, element, corelevel, formalism, extrapolate, plot_results)
%   This is a general function that calculates the cross sections for photoionization
%   from different sources in the literature. The Scofield (1973), Yeh &
%   Lindau (1985), Trzhaskovskaya & Yarzhemsky (2018) and Cant (2022) formalisms 
%   are available. The user can define a scalar or vector of incident photon energies and a
%   interpolation will be made between the dataset to determine the best
%   estimate of the cross sections for photoionization.
%
%   IN:
%   -   hv:             scalar or vector of the incident photon energies [eV]
%   -   element:    	string of the element; e.g. "H", "He", "Si", "In"...
%   -   corelevel:      string or vector of the core-levels to be probed; e.g. ["1s1", "2p1", "2p3", "3d3", "3d5", "5f5', "5f7"]
%   -   formalism:      string of the photoionization cross-section formalism to use. Default:"C2022" ["S1973", "Y1985", "T2018", "C2022"]
%   -   extrapolate:    either 0 or 1; if true, it will extrapolate sigma beyond the conventional range, otherwise not
%   -   plot_results:   if 1, will plot figure summary, otherwise it wont.
%
%   OUT:
%   -   xsect_beta:     N×M vector of the photoelectron angular distribution asymmetry (dipole) parameter beta.
%
%   SEE REFERENCES:
%       [1] Scofield, J H. Theoretical photoionization cross sections from 1 to 1500 keV.. United States: N. p., 1973. Web. doi:10.2172/4545040.
%       [2] J.J. Yeh, I. Lindau. ATOMIC DATA AND NUCLEAR DATA TABLES 32, l-l 55 (1985). Web. doi:10.1016/0092-640X(85)90016-6
%       [3] M.B. Trzhaskovskaya, V.G. Yarzhemsky. Atomic Data and Nuclear Data Tables 119 (2018) 99–174. Web. doi:10.1016/j.adt.2017.04.003
%       [4] David J. H. Cant, Ben F. Spencer, Wendy R. Flavell, Alexander G. Shard. Surf Interface Anal. 2022; 54(4): 442-454. doi:10.1002/sia.7059

%% Default parameters
if nargin < 3; corelevel = [];  end
if nargin < 4; formalism = "C2022";  end
if nargin < 5; extrapolate = 0;  end
if nargin < 6; plot_results = 0;  end
if isempty(corelevel); corelevel = []; end
if isempty(formalism); formalism = "C2022"; end
if isempty(extrapolate); extrapolate = 0; end
if isempty(plot_results); plot_results = 0; end
%% Validity checks on the input parameters
element     = string(element);
corelevel   = string(corelevel);
formalism   = string(formalism);
%% 1 - Defining all variants of formalisms
formalism_s1973     = [...
    "Scofield(1973)", "(1973)Scofield", "Scofield1973", "1973Scofield",...
    "Sco(1973)", "(1973)Sco", "Sco1973", "1973Sco",...
    "Scofield", "Sco", "S", "S1973", "1973"];
formalism_yl1985     = [...
    "YehLindau(1985)", "(1985)YehLindau", "YehLindau1985", "1985YehLindau",...
    "Yeh(1985)", "(1985)Yeh", "Yeh1985", "1985Yeh",...
    "Lindau(1985)", "(1985)Lindau", "Lindau1985", "1985Lindau",...
    "YL(1985)", "(1985)YL", "YL1985", "1985YL",...
    "Y", "L", "YL", "1985YL", "YL1985", "1985"];
formalism_t2018     = [...
    "Trz(2018)", "(2018)Trz", "Trz2018", "2018Trz",...
    "Trzh(2018)", "(2018)Trzh", "Trzh2018", "2018Trzh",...
    "Trzhaskovskaya(2018)", "(2018)Trzhaskovskaya", "Trzhaskovskaya2018", "2018Trzhaskovskaya",...
    "Trzhaskovskaya", "Trz", "T", "2018T", "T2018", "2018"];
formalism_c2022     = [...
    "Cant(2022)", "(2022)Cant", "Cant2022", "2022Cant",...
    "Cant", "Can", "2022C", "C2022", "2022"];
%% 2 - Calculating photoionization parameter
% -- Scofield1973 formalism
if ~isempty(find(strcmpi(formalism_s1973, formalism),1))
    xsect_beta = NaN(length(hv), length(corelevel));
    msg = 'The dipole asymmetry parameter beta is not available in the Scofield1973 database. Beta set to NaN.'; 
    disp(msg);
% -- YehLindau1985 formalism
elseif ~isempty(find(strcmpi(formalism_yl1985, formalism),1))
    xsect_beta = calc_xsect_beta_yehlind1985(hv, element, corelevel, extrapolate, plot_results);
% -- Trzhaskovskaya2018 formalism
elseif ~isempty(find(strcmpi(formalism_t2018, formalism),1))
    xsect_beta = calc_xsect_beta_trzh2018(hv, element, corelevel, extrapolate, plot_results);
% -- Cant2020 formalism
elseif ~isempty(find(strcmpi(formalism_c2022, formalism),1))
    xsect_beta = calc_xsect_beta_cant2022(hv, element, corelevel, plot_results);
else; msg = 'Formalism not found. One of the following must be used: "S1973", "Y1985", "T2018" or "C2022".'; error(msg);
end
end