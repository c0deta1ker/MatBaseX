function dataStr = load_pes_data(PathName, FileName)
% dataStr = load_pes_data(PathName, FileName)
%   Load in the dataStr object already saved as a *.mat MATLAB structure file.
%
%   IN:
%   -   dataStr:            MATLAB data structure containing all the ADRESS data.
%   -   PathName:           char of the input .mat directory path.
%   -   FileName:           char of the input .mat file-name.

%% Default parameters
if nargin < 1; PathName = ''; end
if nargin < 2; FileName = ''; end
if isempty(FileName);   FileName = '';  end
if isempty(PathName);   PathName = '';  end
% - Verifying inputs are characters
FileName = char(FileName);
PathName = char(PathName);
%% 1 - Loading in the data
dataStr     = load(char(string(PathName) + string(FileName)));
dataStr     = dataStr.dataStr;
if isstruct(dataStr) && isfield(dataStr, 'FileName')
    dataStr.FileName = FileName(1:end-4);
end
end