function dataStr = load_pes_data_phelix_xy(PathName, FileName)
% dataStr = load_pes_data_phelix_xy(PathName, FileName)
%   Loads a text file from the PHELIX beamline, SOLARIS that consists of many columns. 
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
disp('Loading in PHELIX text-file data...')
%% 1 - Initializing the .XY file data into a standard format
Traw = readtable(PathName + FileName, 'FileType', 'text', 'NumHeaderLines', 48);
Traw(:,3:end) = []; % keep only first two columns
% Convert to numeric array for fast operations
A = Traw{:, :};     % n-by-2 numeric
% Remove rows with NaN in first column
ok = ~isnan(A(:,1)); A = A(ok, :);
% Find start indices of scans (rows where first column equals first value)
startVal = A(1,1); idx_roi = find(A(:,1) == startVal);
% Determine number of scans and rows per scan
nScans = length(idx_roi);
% compute end indices for each block
ends = [idx_roi(2:end)-1; size(A,1)];
% Preallocate numeric data array: first column x-values, subsequent columns scans' y-values
nrows = ends(1) - idx_roi(1) + 1;         % rows per scan (assumes all scans same length)
ncols = 1 + nScans;                       % 1 for x + one column per scan
data_num = nan(nrows, ncols);
% Fill first column (x) and the scan columns in a vectorized loop over scans
data_num(:,1) = -1 .* A(idx_roi(1):ends(1), 1);   % x (negated)
for k = 1:nScans
    rows_k = idx_roi(k):ends(k);
    data_num(:, k+1) = A(rows_k, 2);
end
% If I0 is present (third column in your original data meaning: one extra column pattern),
% detect and normalize without per-element table ops.
if size(data_num,2) > 2 && data_num(1,3) < 1e-3
    % I0 table: first col = x, others = every second column starting at 3 in original.
    % Here in data_num the I0s are in columns 3:2:end (if that mapping still holds).
    I0_cols = 3:2:size(data_num,2);
    I0_mat = data_num(:, I0_cols);
    % Remove I0 columns from data_num and then normalize the remaining current columns
    data_num(:, I0_cols) = [];                  % remove I0 columns
    % Now normalize columns 2:end by corresponding I0 columns
    % Assume correspondence: data_num(:,2:end) pairs with I0_mat(:,1:end)
    data_num(:,2:end) = data_num(:,2:end) ./ I0_mat;
end
% Compute mean across scans (columns 2:end) ignoring NaNs, round to 4 decimals
mean_col    = round(mean(data_num(:,2:end), 2), 4);
% Convert back to table if needed with VariableNames
varNames    = ["BE", strcat("Scan", string(1:(size(data_num,2)-1))) , "Mean"];
Tfinal      = array2table([data_num, mean_col], 'VariableNames', cellstr(varNames));

%% 2 - Assigning to data structure
data_table              = Tfinal;
dataStr.TimeStamp       = datetime;
dataStr.PathName        = PathName;
dataStr.FileName        = FileName;
dataStr.Type            = "PES-PHELIX";
dataStr.hv              = [];
dataStr.thtM            = [];
dataStr.i0              = I0_mat;
if size(data_table, 2) == 2
    dataStr.sweeps      = 1;
    dataStr.ydat_sweeps = table2array(data_table(:,2));
else
    dataStr.sweeps      = size(data_table(:,2:end-1), 2);
    dataStr.ydat_sweeps = table2array(data_table(:,2:end-1));
end
dataStr.xdat            = round(table2array(data_table(:,1)),4);
dataStr.ydat            = round(mean(table2array(data_table(:,end)),2),4);
dataStr.xdat_lims       = round([min(dataStr.xdat(:)), max(dataStr.xdat(:))],4);
dataStr.ydat_lims       = round([min(dataStr.ydat(:)), max(dataStr.ydat(:))],4);
end