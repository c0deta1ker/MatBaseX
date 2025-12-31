function auger_formalism_list = read_auger_formalisms()
% auger_formalism_list = read_auger_formalisms()
%   This function returns a cell array containing all the formalisms used 
%   for the auger electron transition energies.
%
%   IN: (none)
%
%   OUT:
%   -   auger_formalism_list:      cell array of all Auger formalisms

%% 1 : Defining all IMFP formalisms
auger_formalism_list   = {...
    "Perkins(1991)",...
    };
end