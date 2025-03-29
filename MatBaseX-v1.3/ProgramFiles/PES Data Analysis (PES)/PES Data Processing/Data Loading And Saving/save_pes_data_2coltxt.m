function save_pes_data_2coltxt(xdat, ydat, SaveFullName)
% save_pes_data_2coltxt(xdat, ydat, SaveFullName)
%   Saves the input data as a *.txt file with 2 columns.
%
%   IN:
%   -   xdat:               [nX×1] array of the x-axis (binding energy)
%   -   ydat:               [nY×1] array of the y-axis (intensity)
%   -   SaveFullName:       string or char of the full path + filename to be saved (if empty, it is prompted)

%% Default parameters
if nargin < 3; SaveFullName = ''; end
if isempty(SaveFullName); SaveFullName = ''; end
if isrow(xdat); xdat = xdat'; end           % -- Ensure x-data is a column vector
if isrow(ydat); ydat = ydat'; end           % -- Ensure y-data is a column vector
%% 1 - User defined FileName and Path for the processed data
if isempty(SaveFullName)
    FileName = string(yyyymmdd(datetime)) + "_";
    filter = {'*.mat'};
    [save_filename, save_filepath] = uiputfile(filter, 'Save the data...', FileName);
    save_fullfile = char(string(save_filepath) + string(save_filename));
    % - If Cancel is pressed, then return nothing
    if isequal(save_filepath,0) || isequal(save_filename,0); return; end
else
    save_fullfile = char(string(SaveFullName) + ".mat");
end
%% 2 - Executing the saving of the data
T = table(xdat, ydat);
writetable(T, save_fullfile);
disp('-> saved data : '); display(T);
end