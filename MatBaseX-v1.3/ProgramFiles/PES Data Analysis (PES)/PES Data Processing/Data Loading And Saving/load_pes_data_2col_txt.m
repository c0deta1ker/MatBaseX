function dataStr = load_pes_data_2col_txt(PathName, FileName)
% pesStr = load_pes_data_2col_txt(PathName, FileName)
%   Loads a simple 2-column text file where the first column represents 
%   binding energy and the second column represents intensity.
%
%   IN:
%   -   PathName:       string of the full directory path to the data file
%   -   FileName:       string of the filename of the data file to be loaded
%
%   OUT:
%   -   dataStr:        MATLAB data structure for PES data

%% Default parameters
if nargin < 1; PathName = ''; end
if nargin < 2; FileName = ''; end
if isempty(FileName);   FileName = '';  end
if isempty(PathName);   PathName = '';  end
disp('Loading in a simple 2-column text-file data...')
%% 1 - Loading and reading in the .txt file
data_table          = readtable(string(PathName) + string(FileName));
dataStr.TimeStamp    = datetime;
dataStr.PathName     = PathName;
dataStr.FileName     = FileName;
dataStr.Type         = "PES";
dataStr.hv           = [];
dataStr.thtM         = [];
dataStr.sweeps       = 1;
dataStr.ydat_sweeps  = round(table2array(data_table(:,2)),3);
dataStr.xdat         = round(table2array(data_table(:,1)),3);
dataStr.ydat         = round(table2array(data_table(:,2)),3);
dataStr.xdat_lims    = round([min(dataStr.xdat(:)), max(dataStr.xdat(:))],3);
dataStr.ydat_lims    = round([min(dataStr.ydat(:)), max(dataStr.ydat(:))],3);
end