function xsect_formalism_list = read_xsect_formalisms()
% xsect_formalism_list = read_xsect_formalisms()
%   This function returns a cell array containing all the formalisms used for
%   the photoionization cross-section calculations.
%
%   IN: (none)
%
%   OUT:
%   -   xsect_formalism_list:      1x4 cell array of all photoionization cross-section formalisms

%% 1 : Defining all xsect formalisms
xsect_formalism_list   = {...
    "Cant(2022)"...
    "Trzhaskovskaya(2018)",...
    "YehLindau(1985)",...
    "Scofield(1973)",...
    };
end