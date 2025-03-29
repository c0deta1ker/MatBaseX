function save_pes_data(dataStr, SaveFullName)
% save_pes_data(dataStr, SaveFullName)
%   Saves the dataStr object as a *.mat MATLAB structure file.
%
%   IN:
%   -   dataStr:            MATLAB data structure containing all the ADRESS data.
%   -   SaveFullName:       string or char of the full path + filename to be saved (if empty, it is prompted)

%% Default parameters
if nargin < 2; SaveFullName = ''; end
if isempty(SaveFullName); SaveFullName = ''; end
if isfield(dataStr, 'FileName');    FileName = dataStr.FileName;
else;                               FileName = '';
end
%% 1 - User defined FileName and Path for the processed data
if isempty(SaveFullName)
    filter = {'*.mat'};
    [save_filename, save_filepath] = uiputfile(filter, 'Save the data...', FileName);
    save_fullfile = char(string(save_filepath) + string(save_filename));
    % - If Cancel is pressed, then return nothing
    if isequal(save_filepath,0) || isequal(save_filename,0); return; end
else
    save_fullfile = char(string(SaveFullName) + ".mat");
end
%% 2 - Executing the saving of the data
save(char(save_fullfile), 'dataStr', '-v7.3');
disp('-> saved data : '); display(dataStr);
end