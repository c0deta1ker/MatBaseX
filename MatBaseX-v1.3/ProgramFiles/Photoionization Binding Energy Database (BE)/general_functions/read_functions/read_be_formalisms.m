function be_formalism_list = read_be_formalisms()
% be_formalism_list = read_be_formalisms()
%   This function returns a cell array containing all the formalisms used 
%   for the atomic binding energy determinations.
%
%   IN: (none)
%
%   OUT:
%   -   be_formalism_list:      1x4 cell array of all BE formalisms

%% 1 : Defining all IMFP formalisms
be_formalism_list   = {...
    "Constantinou(2023)"...
    "Cant(2022)",...
    "Trzhaskovskaya(2018)",...
    "Moulder(1993)",...
    };
end