function material_props = get_mpd_props(material)
% material_props = get_mpd_props(material)
%   This is a function that extracts all of the parameters from the
%   Materials Properties Database (MPD) for the material defined here by
%   the user.
%
%   IN:
%   -   material:           char/string of the element or compound; e.g. "Si", "SiO2", "Al2O3"...
%
%   OUT:
%   -   material_props:     MATLAB data-structure that contains all of the material parameters.

%% Default parameters
if nargin < 1; material = []; end
if isempty(material); material = []; end
%% - 1 - Extracting the material parameters from the materials properties database
warning('off', 'backtrace');
% -- Loading in the materials database
MatData         = load('MatData.mat'); MatData = MatData.MatData;
s_fields        = fieldnames(MatData);
% --- if material is not defined, return the whole database
if isempty(material);               material_props = MatData;
% --- if the material is defined in terms of its atomic symbols
elseif isstring(material) || ischar(material)
    % --- if the material defined matches exactly a material in the database
    if isfield(MatData, char(material)); material_props = getfield(MatData, char(material));
    % --- Otherwise check that the material matches without case sensitivity
    elseif sum(contains(s_fields, material,'IgnoreCase',true)) > 0
        s_indx          = strcmpi(s_fields, material);
        n_field         = s_fields{s_indx};
        material_props  = MatData.(n_field);
    else; material_props = []; warning('%s material could not be identified or does not exist in database.', material); 
    end
% --- if the material is defined by its id number
elseif isnumeric(material)
    if ~isnan(double(material)) && double(material) <= numel(fieldnames(MatData))
        s_indx          = double(material);
        n_field         = s_fields{s_indx};
        material_props  = MatData.(n_field);
    else;   material_props = []; warning('Material id %i could not be identified or does not exist in database.', material); 
    end
% -- otherwise return an error that the material was not found
else;       material_props = []; warning('%s material could not be identified or does not exist in database.', material); 
end
warning('on', 'backtrace');
end