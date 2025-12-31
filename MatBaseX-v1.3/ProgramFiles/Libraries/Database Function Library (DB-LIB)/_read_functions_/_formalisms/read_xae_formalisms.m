function xae_formalism_list = read_xae_formalisms()
% xae_formalism_list = read_xae_formalisms()
%   This function returns a cell array containing all the formalisms used 
%   for the x-ray absorption edge determinations.
%
%   IN: (none)
%
%   OUT:
%   -   xae_formalism_list:      1x4 cell array of all BE formalisms

%% 1 : Defining all IMFP formalisms
xae_formalism_list   = {...
    "IXAS(2025)"...
    };
end