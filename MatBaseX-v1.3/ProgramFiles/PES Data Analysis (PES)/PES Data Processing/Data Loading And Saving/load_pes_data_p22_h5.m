function dataStr = load_pes_data_p22_h5(PathName, FileName)
% dataStr = load_pes_data_p22_txt(PathName, FileName)
%   Loads a text file from the P22 beamline that consists of many columns. 
%   The first column is the binding energy, all intermediate columns are 
%   spectral intensities from each consecutive sweep and the final column 
%   is the average spectral intensity over all sweeps.
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
disp('Loading in P22 text-file data...')
%% 1 - Loading and reading in the .txt file
H5full                  = string(PathName) + string(FileName);
dataStr.TimeStamp       = datetime;
dataStr.PathName        = PathName;
dataStr.FileName        = FileName;
dataStr.ScanID          = string({h5info(H5full).Groups.Name});
dataStr.Type            = "PES-P22";
dataStr.hv              = [];
dataStr.thtM            = [];
% -- Try to extract the photon energy from h5 file
try dataStr.hv = h5read(H5full,char(sprintf("%s/instrument/DCM/BLenergy/position", dataStr.ScanID))); end
try dataStr.thtM            = h5read(H5full,char(sprintf("%s/instrument/HAXPES/polar/position", dataStr.ScanID)));end
dwellTime = h5read(H5full,char(sprintf("%s/metainfo/mask/dwellTime", dataStr.ScanID)));
% -- Extracting the data into a table
energy                  = h5read(H5full,char(sprintf("%s/data/energy", dataStr.ScanID)));
intensity               = h5read(H5full,char(sprintf("%s/data/intensity", dataStr.ScanID)));
intensity               = intensity ./ dwellTime; % making intensity counts / s
intensity0              = [];
for i = 1:size(intensity, 2); intensity0(:,i) = double(intensity(1,i,:)); end
intensity_mu            = mean(intensity0,2);
data_table              = array2table(double([energy, intensity0, intensity_mu]));
% -- Assigning all sweeps and final data
if size(data_table, 2) == 2
    dataStr.sweeps      = 1;
    dataStr.ydat_sweeps = table2array(data_table(:,2));
else
    dataStr.sweeps      = size(data_table(:,2:end-1), 2);
    dataStr.ydat_sweeps = table2array(data_table(:,2:end-1));
end
dataStr.xdat            = -1.*round(table2array(data_table(:,1)),4);
dataStr.ydat            = round(mean(table2array(data_table(:,end)),2),4);
dataStr.xdat_lims       = round([min(dataStr.xdat(:)), max(dataStr.xdat(:))],4);
dataStr.ydat_lims       = round([min(dataStr.ydat(:)), max(dataStr.ydat(:))],4);
end