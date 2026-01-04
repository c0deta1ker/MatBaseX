function atomicData = read_spectroscopy_element_data(dataType, elementSymbol)
% atomicData = read_spectroscopy_element_data(dataType, elementSymbol)
%   Comprehensive function for retrieving atomic spectroscopy data from X-ray 
%   and electron spectroscopy databases. Supports four data types:
%       1. BINDING ENERGY (BE): Inner-shell ionization energies in eV
%           - Useful for XPS, XES, and X-ray absorption edge identification
%           - Covers elements H to Cf (Z = 1–98)
%       2. AUGER TRANSITIONS (AUGER): Kinetic energies of Auger electrons
%           - Essential for AES (Auger Electron Spectroscopy) analysis
%           - Transitions labeled (e.g., 'K,L3,L1', 'L1,M4,M5')
%           - Covers H to Np (Z = 1–93)
%           - Includes relative intensities for each transition
%       3. X-RAY ABSORPTION EDGES (XAE): Absorption edge characteristics
%           - Critical for XANES and near-edge absorption studies
%           - Includes edge energy, width (natural linewidth), and jump ratio
%           - Covers H to Cf (Z = 1–98)
%       4. PHOTOIONIZATION CROSS-SECTION (XSECT): Binding energies with 
%           available cross-section data
%           - Returns only shell/orbital with calculated cross-sections
%           - Useful for predicting spectral intensities in XPS/XES
%
%   IN:
%       - dataType          String specifying the type of data to load:
%                               'be'    : Binding energies
%                               'auger' : Auger electron kinetic energies
%                               'xae'   : X-ray absorption edges
%                               'xsect' : Binding energies with a valid Photoionization cross-section
%                    
%       - elementSymbol     (Optional) String symbol of the element (e.g., 'Fe').
%                               If omitted or empty, data for all elements is returned.
%
%   OUT:
%       - atomicData        MATLAB table containing the requested spectroscopy data.
%                               Columns and formatting are consistent across modes.
%
% USAGE EXAMPLES:
%   * Full binding energy table for all elements: BE_table = read_spectroscopy_element_data('be','');
%   * Auger data for Silicon only: Si_auger = read_spectroscopy_element_data('auger', 'Si');
%   * X-ray absorption edges for Copper: Cu_xae = read_spectroscopy_element_data('xae', 'Cu');
%   * Binding energies with cross-section data available: xsect_table = read_spectroscopy_element_data('xsect', '');

%% Validate Input Arguments
arguments
    dataType (1,:) char {mustBeMember(dataType, {'be','auger','xae','xsect'})}
    elementSymbol (1,:) char {mustBeElementOrEmpty(elementSymbol)}
end

%% 1 : Retrieve Full Periodic Table Data (where elementSymbol = '')
if isempty(elementSymbol)
    % - Load standard periodic table element symbols
    elementSymbols = read_mpd_elements();
    % - Apply Z-range limits based on data type availability
    switch dataType
        case 'auger'
            elementSymbols = elementSymbols(1:93);  % Auger: Z=1–93 (H–Np)
        otherwise
            elementSymbols = elementSymbols(1:98);  % BE/XAE/XSECT: Z=1–98 (H–Cf)
    end
    nElements = numel(elementSymbols);
    % - Process data based on requested type
    switch dataType
        % ================================================================
        % BINDING ENERGY DATA - FULL TABLE
        % ================================================================
        case 'be'
            bindingEnergies = cell(nElements, 1);
            shellLabels     = cell(nElements, 1);
            % -- Calculate BE for each element
            for i = 1:nElements
                [bindingEnergies{i}, shellLabels{i}] = calc_be(elementSymbols{i});
            end
            % -- Flatten cell arrays into table format
            elementCol = {}; shellCol = {}; beCol = {};
            for i = 1:length(elementSymbols)
                for j = 1:length(bindingEnergies{i})
                    elementCol{end+1}   = elementSymbols{i};
                    shellCol{end+1}     = shellLabels{i}(j);
                    beCol{end+1}        = bindingEnergies{i}(j);
                end
            end
            % -- Convert to string and numeric arrays
            elementCol = string(elementCol');
            shellCol = string(shellCol');
            beCol = cell2mat(beCol');
            % -- Create output table
            atomicData = table(elementCol, shellCol, beCol, ...
                'VariableNames', {'ATOM_SYMB', 'SHELL', 'BE_eV'});
            
        % ================================================================
        % AUGER DATA (eV) - FULL TABLE
        % ================================================================
        case 'auger'
            augerKinEnergy  = cell(nElements, 1);
            augerIntensity  = cell(nElements, 1);
            augerTransition = cell(nElements, 1);
            % -- Calculate Auger for each element
            for i = 1:nElements
                [augerKinEnergy{i}, augerIntensity{i}, augerTransition{i}] = ...
                    calc_auger(elementSymbols{i});
            end
            % -- Flatten cell arrays into table format
            elementCol = {}; transitionCol   = {}; keCol = {};intensityCol = {};
            for i = 1:length(elementSymbols)
                for j = 1:length(augerKinEnergy{i})
                    elementCol{end+1}       = elementSymbols{i};
                    transitionCol{end+1}    = augerTransition{i}(j);
                    keCol{end+1}            = augerKinEnergy{i}(j);
                    intensityCol{end+1}     = augerIntensity{i}(j);
                end
            end
            % -- Convert to appropriate types
            elementCol      = string(elementCol');
            transitionCol   = string(transitionCol');
            keCol           = cell2mat(keCol');
            intensityCol    = cell2mat(intensityCol');
            % -- Create output table
            atomicData = table(elementCol, transitionCol, keCol, intensityCol, ...
                'VariableNames', {'ATOM_SYMB', 'AUGER_TRANSITION', 'AUGER_KE_eV', 'AUGER_INT'});
    
        % ================================================================
        % X-RAY ABSORPTION EDGE DATA - FULL TABLE
        % ================================================================
        case 'xae'
            edgeEnergy      = cell(nElements, 1);
            edgeLabel       = cell(nElements, 1);
            edgeWidth       = cell(nElements, 1);
            edgeJumpRatio   = cell(nElements, 1);
            % -- Calculate XAE for each element
            for i = 1:nElements
                [edgeEnergy{i}, edgeLabel{i}, edgeWidth{i}, edgeJumpRatio{i}] = ...
                    calc_xae(elementSymbols{i});
            end
            % -- Flatten cell arrays into table format
            elementCol  = {}; edgeLabelCol = {}; energyCol = {}; widthCol = {}; jumpCol = {};
            for i = 1:length(elementSymbols)
                for j = 1:length(edgeEnergy{i})
                    elementCol{end+1} = elementSymbols{i};
                    edgeLabelCol{end+1} = edgeLabel{i}(j);
                    energyCol{end+1} = edgeEnergy{i}(j);
                    widthCol{end+1} = edgeWidth{i}(j);
                    jumpCol{end+1} = edgeJumpRatio{i}(j);
                end
            end
            % -- Convert to appropriate types
            elementCol = string(elementCol');
            edgeLabelCol = string(edgeLabelCol');
            energyCol = cell2mat(energyCol');
            widthCol = cell2mat(widthCol');
            jumpCol = cell2mat(jumpCol');
            % -- Create output table
            atomicData = table(elementCol, edgeLabelCol, energyCol, widthCol, jumpCol, ...
                'VariableNames', {'ATOM_SYMB', 'EDGE', 'EDGE_ENERGY_eV', ...
                'EDGE_WIDTH_eV', 'EDGE_JUMP'});

        % ================================================================
        % PHOTOIONIZATION CROSS-SECTION DATA - FULL TABLE
        % ================================================================
        case 'xsect'
                bindingEnergies = cell(nElements, 1);
                shellLabels = cell(nElements, 1);
                % -- Calculate BE and filter by cross-section availability
                for i = 1:nElements
                    [bindingEnergies{i}, shellLabels{i}] = calc_be(elementSymbols{i});
                    % --- Calculate cross-sections at 1 keV above each edge
                    crossSectionSigma = NaN(size(shellLabels{i}));
                    for j = 1:length(shellLabels{i})
                        photonEnergy = bindingEnergies{i}(j) + 1000;  % 1 keV above edge
                        crossSectionSigma(j) = calc_xsect_sigma(photonEnergy, ...
                            elementSymbols{i}, shellLabels{i}(j));
                    end
                    % --- Remove entries without cross-section data (NaN values)
                    bindingEnergies{i}(isnan(crossSectionSigma)) = [];
                    shellLabels{i}(isnan(crossSectionSigma)) = [];
                end
                % -- Flatten cell arrays into table format
                elementCol = {}; 
                shellCol = {}; 
                beCol = {};
                for i = 1:length(elementSymbols)
                    for j = 1:length(bindingEnergies{i})
                        elementCol{end+1} = elementSymbols{i};
                        shellCol{end+1} = shellLabels{i}(j);
                        beCol{end+1} = bindingEnergies{i}(j);
                    end
                end
                % -- Convert to appropriate types
                elementCol = string(elementCol');
                shellCol = string(shellCol');
                beCol = cell2mat(beCol');
                % -- Create output table
                atomicData = table(elementCol, shellCol, beCol, ...
                    'VariableNames', {'ATOM_SYMB', 'XSECT_SHELL', 'XSECT_BE_eV'});
    end

%% 2 : Retrieve Data for Single Element
else
    switch dataType
        % ================================================================
        % BINDING ENERGY DATA (eV) - SINGLE ELEMENT
        % ================================================================
        case 'be'
            [bindingEnergies, shellLabels] = calc_be(elementSymbol);
            % -- Build table arrays
            elementCol = {}; shellCol = {}; beCol = {};
            for i = 1:length(shellLabels)
                elementCol{end+1} = elementSymbol;
                shellCol{end+1} = shellLabels(i);
                beCol{end+1} = bindingEnergies(i);
            end
            % -- Convert to appropriate types
            elementCol = string(elementCol');
            shellCol = string(shellCol');
            beCol = cell2mat(beCol');
            % -- Create output table
            atomicData = table(elementCol, shellCol, beCol, ...
                'VariableNames', {'ATOM_SYMB', 'SHELL', 'BE_eV'});
    
        % ================================================================
        % AUGER DATA (eV) - SINGLE ELEMENT
        % ================================================================
        case 'auger'
            [augerKinEnergy, augerIntensity, augerTransition] = calc_auger(elementSymbol);
            % -- Build table arrays
            elementCol = {}; transitionCol = {}; keCol = {}; intensityCol = {};
            for i = 1:length(augerTransition)
                elementCol{end+1} = elementSymbol;
                transitionCol{end+1} = augerTransition(i);
                keCol{end+1} = augerKinEnergy(i);
                intensityCol{end+1} = augerIntensity(i);
            end
            % -- Convert to appropriate types
            elementCol = string(elementCol');
            transitionCol = string(transitionCol');
            keCol = cell2mat(keCol');
            intensityCol = cell2mat(intensityCol');
            % -- Create output table
            atomicData = table(elementCol, transitionCol, keCol, intensityCol, ...
                'VariableNames', {'ATOM_SYMB', 'AUGER_TRANSITION', 'AUGER_KE_eV', 'AUGER_INT'});

        % ================================================================
        % X-RAY ABSORPTION EDGE DATA - SINGLE ELEMENT
        % ================================================================
        case 'xae'
            [edgeEnergy, edgeLabel, edgeWidth, edgeJumpRatio] = calc_xae(elementSymbol);
            % -- Build table arrays
            elementCol = {}; edgeLabelCol = {}; energyCol = {}; widthCol = {}; jumpCol = {};
            for i = 1:length(edgeLabel)
                elementCol{end+1} = elementSymbol;
                edgeLabelCol{end+1} = edgeLabel(i);
                energyCol{end+1} = edgeEnergy(i);
                widthCol{end+1} = edgeWidth(i);
                jumpCol{end+1} = edgeJumpRatio(i);
            end
            % -- Convert to appropriate types
            elementCol = string(elementCol');
            edgeLabelCol = string(edgeLabelCol');
            energyCol = cell2mat(energyCol');
            widthCol = cell2mat(widthCol');
            jumpCol = cell2mat(jumpCol');
            % -- Create output table
            atomicData = table(elementCol, edgeLabelCol, energyCol, widthCol, jumpCol, ...
                'VariableNames', {'ATOM_SYMB', 'EDGE', 'EDGE_ENERGY_eV', ...
                'EDGE_WIDTH_eV', 'EDGE_JUMP'});

        % ================================================================
        % PHOTOIONIZATION CROSS-SECTION DATA - SINGLE ELEMENT
        % ================================================================
        case 'xsect'
            [bindingEnergies, shellLabels] = calc_be(elementSymbol);
            % -- Calculate cross-sections and filter
            crossSectionSigma = NaN(size(shellLabels));
            for j = 1:length(shellLabels)
                photonEnergy = bindingEnergies(j) + 1000;  % 1 keV above edge
                crossSectionSigma(j) = calc_xsect_sigma(photonEnergy, ...
                    elementSymbol, shellLabels(j));
            end
            % -- Remove entries without cross-section data
            bindingEnergies(isnan(crossSectionSigma)) = [];
            shellLabels(isnan(crossSectionSigma)) = [];
            % -- Build table arrays
            elementCol = {}; 
            shellCol = {}; 
            beCol = {};
            for j = 1:length(bindingEnergies)
                elementCol{end+1} = elementSymbol;
                shellCol{end+1} = shellLabels(j);
                beCol{end+1} = bindingEnergies(j);
            end
            % -- Convert to appropriate types
            elementCol = string(elementCol');
            shellCol = string(shellCol');
            beCol = cell2mat(beCol');
            % -- Create output table
            atomicData = table(elementCol, shellCol, beCol, ...
                'VariableNames', {'ATOM_SYMB', 'XSECT_SHELL', 'XSECT_BE_eV'});
    end
end
end

% ============================================================================
% INPUT VALIDATION FUNCTION
% ============================================================================
function mustBeElementOrEmpty(elementSymbol)
if ~isempty(elementSymbol)
    allowedElements = { ...
        'H','He', ...
        'Li','Be','B','C','N','O','F','Ne', ...
        'Na','Mg','Al','Si','P','S','Cl','Ar', ...
        'K','Ca','Sc','Ti','V','Cr','Mn','Fe','Co','Ni','Cu','Zn','Ga','Ge','As','Se','Br','Kr', ...
        'Rb','Sr','Y','Zr','Nb','Mo','Tc','Ru','Rh','Pd','Ag','Cd','In','Sn','Sb','Te','I','Xe', ...
        'Cs','Ba','La','Ce','Pr','Nd','Pm','Sm','Eu','Gd','Tb','Dy','Ho','Er','Tm','Yb','Lu','Hf','Ta','W','Re','Os','Ir','Pt','Au','Hg','Tl','Pb','Bi','Po','At','Rn', ...
        'Fr','Ra','Ac','Th','Pa','U','Np','Pu','Am','Cm','Bk','Cf','Es','Fm','Md','No','Lr','Rf', ...
        'Db','Sg','Bh','Hs','Mt','Ds','Rg','Cn','Nh','Fl','Mc','Lv','Ts','Og'};
    mustBeMember(elementSymbol, allowedElements)
end
end
