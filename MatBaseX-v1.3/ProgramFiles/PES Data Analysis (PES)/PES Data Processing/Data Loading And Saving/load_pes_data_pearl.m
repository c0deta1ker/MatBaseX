function dataStr = load_pes_data_pearl(PathName, FileName)
% dataStr = load_pes_data_pearl(PathName, FileName)
%   This function loads in the HDF5 data files of ARPES / XPS data from 
%   the PEARL beamline at the SLS. The output is a MATLAB
%   data-structure that yields all the data and information. This function 
%   should be used to load in a single PEARL data-file that is unprocessed
%   or has been previously processed using PESTools. Last updated in
%   November 2022
%
%   REQ. FUNCTIONS: (none)
%
%   IN:
%   -   PathName:           char of the input .h5 or .mat directory path.
%   -   FileName:           char of the input .h5 or .mat file-name.
%
%   OUT:
%   dataStr - MATLAB data structure containing all fields below;
%	 .(FileName):       string of the current filename of the data file.
%	 .(H5file):         string of the raw .H5 filename of the data file.
%	 .(TimeStamp):      time-stamp of when the file was created.
%	 .(Type):           string "Eb(k)", "Eb(k,i)", "Eb(kx,ky)" or "Eb(kx,kz)".
% 	 .(index):          [1xN] vector of the total number of scans.
%	 .(meta):           structure that contains all meta information.
%	    .(meta.general):    structure with author / sample information.
%	    .(meta.logs):       string array with acuisition logs.
%	    .(meta.Pol):        string of the photon polarisation used.
%	    .(meta.Slit):       scalar of the beamline exit slit size.
%	    .(meta.Mode):       string of the Analyzer angular mode used.
%	    .(meta.X):          scalar of the manipulator X position.
%	    .(meta.Y):          scalar of the manipulator Y position.
%	    .(meta.Z):          scalar of the manipulator Z position.
%	    .(meta.dhv):        scalar estimate of the beamline resolution.
%	    .(meta.deb):        scalar of the Analyzer resolution.
%	 .(hv):              scalar or [1×nScan] row vector (if Scan parameter for 3Data data). Photon energy [eV].
%	 .(tltM):            scalar or [1×nScan] row vector (if Scan parameter for 3Data data). Mechanical Tilt [degrees]
%	 .(tltE):            scalar or [1×nScan] row vector (if Scan parameter for 3Data data). Electrostatic Tilt [degrees].
%	 .(thtM):            scalar of the manipulator Theta angle.
%	 .(Temp):            scalar of the sample temperature.
%	 .(raw_data):        2Data [nEnergy x nAngle] or 3Data [nEnergy x nAngle xnScan] data array.
%	 .(raw_tht):         [1×nAngle] row vector of angles.
% 	 .(raw_eb):          [nEnergyx1] column vector of energy.

%% Default parameters
if nargin < 1; PathName = ''; end
if nargin < 2; FileName = ''; end
if isempty(FileName);   FileName = '';  end
if isempty(PathName);   PathName = '';  end
% - Display text
disp('Loading PEARL data...')
% - Verifying inputs are characters
FileName = char(FileName);
PathName = char(PathName);

%% 1 - Loading and reading in the HDF5 data file
% - If no filename if defined, load in an empty data structure
if isempty(FileName); return;
% - Verify that a .h5 file has been parsed and load the variables
elseif string(FileName(end-2:end)) == ".h5"
    %% 1.1 -- Extracting file information
    FileInfo    = dir(char(string(PathName) + string(FileName))); 
    TimeStamp   = string(FileInfo.date);
    %% 1.2 -- Extracting all of the data variables
    initStr = struct();
    full_h5_file_name = char(string(PathName) + string(FileName));
    %% 1.2.1 -- Extracting all of the data variables - Regular '\scan1' XPS Spectrum
    Type = "Eb(k)";
    group_names = string({h5info(full_h5_file_name).Groups.Name});
    if group_names(1) == '/__DATA_TYPES__'; group_names(1) = []; end
    % -- Filing through each group and extracting all the data
    for i = 1:length(group_names)
        % Validity check on group name
        % ---- Ensuring the group name does not include prefix '/'
        group_name = group_names(i); group_name = char(group_name); group_name = group_name(2:end);
        % ---- Removing all spaces from the group name
        group_name = strrep(group_name," ","_");
        % Extracting element names
        element_names = string({h5info(full_h5_file_name, char(group_names(i)+"/")).Datasets.Name});
        % --- Filing through each element in the group
        for j = 1:length(element_names)
            % Validity check on element name
            element_name = element_names(j);
            % ---- Extracting the PEARL dataset
            initStr.(group_name).(element_name) = h5read(full_h5_file_name, char(group_names(i)+"/"+element_names(j)));
        end
        % --- Extracting all the data attributes
        if group_name == "scan1"
            attr_names = string({h5info(full_h5_file_name, char("/scan1/attrs")).Datasets.Name});
            for j = 1:length(attr_names)
                initStr.scan1.attrs.(attr_names(j)) = h5read(full_h5_file_name, char("/scan1/attrs"+"/"+attr_names(j)));
            end
        end
    end
    % Extracting all the scan attributes
    general = initStr.general;
    logs    = initStr.logs.logs;
    %% 1.2.2 -- Extracting all of the data variables - MultiRegionScan '\scan1'
    if sum(contains(group_names, "/scan 1")) ~= 0
        % For custom 'MultiRegionScan' files
        Type = "Eb(k,i)";
        group_names = string({h5info(full_h5_file_name, char("/scan 1")).Groups.Name});
        % -- Filing through each group and extracting all the data
        for i = 1:length(group_names)
            % ---- Ensuring the group name does not include prefix '/'
            group_name = group_names(i); group_name = char(group_name); group_name = group_name(9:end);
            % Extracting element names
            element_names = string({h5info(full_h5_file_name, char(group_names(i)+"/")).Datasets.Name});
            % --- Filing through each element in the group
            for j = 1:length(element_names)
                initStr.scan_1.(group_name).(element_names(j)) = h5read(full_h5_file_name, char(group_names(i)+"/"+element_names(j)));
            end
        end
        % initStr.scan_1 % FOR DEBUGGING
    end
    %% 1.2.3 -- Collecting all spectral data
    spectra = struct();
    if isfield(initStr,'scan_1')  
        if isfield(initStr.scan_1,'Eph');   spectra = initStr.scan_1;   Type = "Eb(k,hv)";
        else;                               spectra = initStr.scan_1;   Type = "Eb(k,i)";
        end
    elseif isfield(initStr,'scan1');        spectra = initStr.scan1;    Type = "Eb(k)";
    end
    %% 1.3 -- Extracting all of the necessary variables
    % --- Extracting region / type independent variables
    % ----- Extracting experimental parameters & meta data
    Pol     = "LH (s-pol)";
    Slit    = mean(spectra.attrs.ExitSlit);
    Mode    = spectra.attrs.LensMode(1);
    if Type == "Eb(k)" || Type == "Eb(k,i)"; hv = mean(spectra.attrs.MonoEnergy); else; hv = spectra.attrs.MonoEnergy; end
    Temp    = mean(spectra.attrs.ManipulatorTempB);
    % ----- Assinging the main experimental variables
    % ------ Angle
    angle_start = spectra.attrs.ScientaSliceBegin(1);
    angle_end   = spectra.attrs.ScientaSliceEnd(1);
    angle_num   = spectra.attrs.ScientaNumSlices(1);
    Angle       = linspace(angle_start, angle_end, angle_num);
    % -- For an XPSSPectrum
    if Type == "Eb(k)"
        % - Extracting experimental parameters & meta data
        X       = spectra.attrs.ManipulatorX;
        Y       = spectra.attrs.ManipulatorY;
        Z       = spectra.attrs.ManipulatorZ;
        Tilt    = spectra.attrs.ManipulatorTilt;
        Theta   = spectra.attrs.ManipulatorTheta;
        Phi     = spectra.attrs.ManipulatorPhi;
        % - Assinging the main experimental variables
        Epass   = str2double(spectra.attrs.PassEnergy);
        % -- Kinetic Energy
        ek_start = spectra.attrs.ScientaChannelBegin(1);
        ek_end   = spectra.attrs.ScientaChannelEnd(1);
        ek_step  = spectra.attrs.StepSize(1);
        kEnergy  = ek_start : ek_step : ek_end; kEnergy = kEnergy';
        % -- Binding Energy
        Energy = kEnergy - hv - 4.5;
        % -- Data
        Data = spectra.ScientaImage;
        % -- Index
        index = 1:size(Data,3);
        % -- Assigning the data to the MATLAB structure
        dataStr = struct();
        % - Assigning file information
        dataStr.FileName    = FileName(1:end-3);
        dataStr.H5file      = char(FileName);
        dataStr.TimeStamp   = TimeStamp;
        dataStr.Type        = Type;
        dataStr.index       = index;
        % - Assigning the meta data
        dataStr.meta.general = general;
        dataStr.meta.logs   = logs;
        dataStr.meta.Epass  = Epass;
        dataStr.meta.Pol    = Pol;
        dataStr.meta.Slit   = Slit;
        dataStr.meta.Mode   = Mode;
        dataStr.meta.X      = X;
        dataStr.meta.Y      = Y;
        dataStr.meta.Z      = Z;
        % - Assinging experimental parameters
        dataStr.hv          = hv;
        dataStr.phiM        = Phi;
        dataStr.thtM        = Theta;
        dataStr.tltM        = Tilt;
        dataStr.Temp        = Temp;
        % - Assinging the main experimental variables
        dataStr.raw_data    = Data;
        dataStr.raw_tht     = Angle;
        dataStr.raw_eb      = Energy;
    % -- For a MultiRegionScan
    elseif Type == "Eb(k,i)"
        % --- Extracting region dependent variables
        field_names     = fieldnames(spectra,'-full');
        region_index    = contains(field_names, 'region');
        region_names    = field_names(region_index);
        % Sorting regions into ascending order
        filenum = cellfun(@(x)sscanf(x,'region%d'), region_names);  % extract the numbers
        [~,Sidx] = sort(filenum);                                   % sort them, and get the sorting order
        region_names = region_names(Sidx);                          % use to this sorting order to sort the filenames
        % --- Filing through each region and extracting spectrum
        dataStr = {};
        for i = 1:length(region_names)
            dataField = getfield(spectra, region_names{i});
            % - Extracting experimental parameters & meta data
            X       = dataField.PositionX;
            Y       = dataField.PositionY;
            Z       = dataField.PositionZ;
            Tilt    = dataField.PositionTilt;
            Theta   = dataField.PositionTheta;
            Phi     = dataField.PositionPhi;
            % - Assinging the main experimental variables
            Epass   = dataField.ScientaPassEnergy;
            % -- Kinetic Energy
            ek_start = dataField.ScientaChannelBegin(1);
            ek_end   = dataField.ScientaChannelEnd(1);
            ek_step  = dataField.ScientaStepEnergy(1);
            kEnergy  = ek_start : ek_step : ek_end; kEnergy = kEnergy';
            % -- Binding Energy
            Energy = kEnergy - hv - 4.5;
            % -- Data
            Data = dataField.ScientaImage;
            Data = permute(Data, [2,3,1]);
            % - Index
            index = 1:size(Data,3);
            if index == 1; Type = "Eb(k)"; end
            % -- Assigning the data to the MATLAB structure
            % - Assigning file information
            dataStr{i}.FileName    = FileName(1:end-3);
            dataStr{i}.H5file      = char(FileName);
            dataStr{i}.TimeStamp   = TimeStamp;
            dataStr{i}.Type        = Type;
            dataStr{i}.index       = index;
            % - Assigning the meta data
            dataStr{i}.meta.general = general;
            dataStr{i}.meta.logs   = logs;
            dataStr{i}.meta.region = region_names{i};
            dataStr{i}.meta.Epass  = Epass;
            dataStr{i}.meta.Pol    = Pol;
            dataStr{i}.meta.Slit   = Slit;
            dataStr{i}.meta.Mode   = Mode;
            dataStr{i}.meta.X      = X;
            dataStr{i}.meta.Y      = Y;
            dataStr{i}.meta.Z      = Z;
            % - Assinging experimental parameters
            dataStr{i}.hv          = hv;
            dataStr{i}.phiM        = Phi;
            dataStr{i}.thtM        = Theta;
            dataStr{i}.tltM        = Tilt;
            dataStr{i}.Temp        = Temp;
            % - Assinging the main experimental variables
            dataStr{i}.raw_data    = Data;
            dataStr{i}.raw_tht     = Angle;
            dataStr{i}.raw_eb      = Energy;
        end
    % -- For a PhotonEnergy scan
    elseif Type == "Eb(k,hv)"
        % - Extracting experimental parameters & meta data
        X       = spectra.attrs.ManipulatorX;
        Y       = spectra.attrs.ManipulatorY;
        Z       = spectra.attrs.ManipulatorZ;
        Tilt    = spectra.attrs.ManipulatorTilt;
        Theta   = spectra.attrs.ManipulatorTheta;
        Phi     = spectra.attrs.ManipulatorPhi;
        % - Assinging the main experimental variables
        Epass   = str2double(spectra.attrs.PassEnergy);
        for i = 1:length(hv)
            % -- Kinetic Energy
            ek_start = spectra.attrs.ScientaChannelBegin(1);
            ek_end   = spectra.attrs.ScientaChannelEnd(1);
            ek_step  = spectra.attrs.StepSize(1);
            kEnergy  = ek_start : ek_step : ek_end; kEnergy = kEnergy';
            % -- Binding Energy
            Energy(:,i) = kEnergy - hv(i) - 4.5;
        end
        % -- Data
        Data = spectra.ScientaImage;
        Data = permute(Data, [2,3,1]);
        % -- Index
        index = 1:size(Data,3);
        % -- Assigning the data to the MATLAB structure
        dataStr = struct();
        % - Assigning file information
        dataStr.FileName    = FileName(1:end-3);
        dataStr.H5file      = char(FileName);
        dataStr.TimeStamp   = TimeStamp;
        dataStr.Type        = Type;
        dataStr.index       = index;
        % - Assigning the meta data
        dataStr.meta.general = general;
        dataStr.meta.logs   = logs;
        dataStr.meta.Epass  = Epass;
        dataStr.meta.Pol    = Pol;
        dataStr.meta.Slit   = Slit;
        dataStr.meta.Mode   = Mode;
        dataStr.meta.X      = X;
        dataStr.meta.Y      = Y;
        dataStr.meta.Z      = Z;
        % - Assinging experimental parameters
        dataStr.hv          = hv;
        dataStr.phiM        = Phi;
        dataStr.thtM        = Theta;
        dataStr.tltM        = Tilt;
        dataStr.Temp        = Temp;
        % - Assinging the main experimental variables
        dataStr.raw_data    = Data;
        dataStr.raw_tht     = Angle;
        dataStr.raw_eb      = Energy;
    end

%% 2 - Reading in the .mat data that has been processed before
elseif string(FileName(end-3:end)) == ".mat"
    arpes_data  = load(char(string(PathName) + string(FileName)));
    initStr     = arpes_data.pearlStr;
    if isstruct(initStr) && isfield(initStr, 'FileName')
        initStr.FileName = FileName(1:end-4);
    end
end
end