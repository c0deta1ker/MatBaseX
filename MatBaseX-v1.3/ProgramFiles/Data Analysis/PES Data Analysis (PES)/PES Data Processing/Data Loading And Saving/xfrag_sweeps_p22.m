function dataStr_frag = xfrag_sweeps_p22(dataStr)
% dataStr_frag = xfrag_sweeps_p22(dataStr)
%   This function cross-fragments the scans over the defined 
%   sweeps for p22 text file.

%% 1 - Initializing the Fragmented Data
dataStr_frag = cell(1,dataStr.sweeps);
for i = 1:length(dataStr)
    for j = 1:dataStr.sweeps
        dataStr_frag{j}.TimeStamp      = dataStr.TimeStamp;
        dataStr_frag{j}.PathName       = dataStr.PathName;
        dataStr_frag{j}.FileName       = dataStr.FileName;
        dataStr_frag{j}.Type           = "PES-P22";
        dataStr_frag{j}.hv             = dataStr.hv;
        dataStr_frag{j}.thtM           = dataStr.thtM;
        dataStr_frag{j}.sweeps         = 1;
        dataStr_frag{j}.ydat_sweeps    = dataStr.ydat_sweeps(:,j);
        dataStr_frag{j}.xdat           = dataStr.xdat;
        dataStr_frag{j}.ydat           = dataStr.ydat_sweeps(:,j);
        dataStr_frag{j}.xdat_lims      = round([min(dataStr_frag{j}.xdat(:)), max(dataStr_frag{j}.xdat(:))],4);
        dataStr_frag{j}.ydat_lims      = round([min(dataStr_frag{j}.ydat(:)), max(dataStr_frag{j}.ydat(:))],4);
    end
end
end
