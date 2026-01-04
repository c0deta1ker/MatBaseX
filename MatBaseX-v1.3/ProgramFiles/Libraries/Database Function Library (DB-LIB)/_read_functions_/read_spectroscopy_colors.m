function colorList = read_spectroscopy_colors(transitionLabels)
% colorList = read_spectroscopy_colors(transitionLabels)
%   Maps spectroscopic transition labels to RGB colors for consistent 
%   visualization across different spectroscopy plot types. Automatically 
%   detects input format (X-ray edges or core-level orbitals) and assigns 
%   colors based on orbital characteristics. This function ensures consistent 
%   color-coding of absorption edges (K, L, M, etc.) and core-level orbitals 
%   (1s, 2p, 3d, etc.) across spectroscopy figures, making it easier to 
%   identify spectral features across multiple plots.
%
%   IN:
%   -   transitionLabels    1×N cell or string array of transition labels
%           Automatically detects one of two formats:
%               * 'edges': comma-separated edges like {'N7,O6,P2', 'M5,O7,O7', 'L3,M2,P5',...}
%               * 'core': single core levels like {'1s1', '2p3', '4f7',...}
%
%   OUT:
%   -   colorList           1×N cell array, each element contains RGB color vector [R G B]
%
% ============================================================================
%                        COLOR SCHEME REFERENCE
% ============================================================================
%
% X-RAY ABSORPTION EDGES (IUPAC notation)
% ────────────────────────────────────────────────────────────────────────
%   Shell    Base Color          Subshells with Shading
%   ────────────────────────────────────────────────────────────────────
%   K        Black               K (single shell, darkest)
%   L        Red                 L1, L2, L3 (progressively lighter)
%   M        Blue                M1–M5 (progressively lighter)
%   N        Green               N1–N7 (progressively lighter)
%   O        Orange              O1–O5 (progressively lighter)
%   P        Purple              P1–P3 (progressively lighter)
%   Q        Light green         Q1–Q3 (progressively lighter)
%
% CORE-LEVEL ORBITALS (Quantum notation)
% ────────────────────────────────────────────────────────────────────────
%   Orbital   Base Color          Example
%   ────────────────────────────────────────────────────────────────────
%   s         Black               1s1, 2s1, 3s1, ... (darker to lighter)
%   p         Red                 2p1, 2p3, 3p5, ... (darker to lighter)
%   d         Blue                3d5, 3d10, 4d10, ... (darker to lighter)
%   f         Green               4f7, 4f14, 5f14, ... (darker to lighter)
%

%% Input validation and conversion
transitionLabels           = string(transitionLabels);
nCL             = length(transitionLabels);
colorList      = cell(nCL, 1);
%% 1 - Detect type from first valid entry
type = detect_type(transitionLabels);
if isempty(type)
    error('Cannot automatically detect type from input names. Use explicit type parameter.');
end
%% 2 - Define base colors by detected type
if strcmp(type, 'edges')
    baseColors = struct('K', [0, 0, 0], 'L', [1, 0, 0], 'M', [0, 0, 1], ...
                       'N', [0, 1, 0], 'O', [1, 0.5, 0.2], 'P', [0.5, 0.2, 1], ...
                       'Q', [0.5, 1, 0.2]);
    prefixPos = 2;  % Number is 2nd character (e.g. L2, M3, N7)
    typePos = 1;    % Type is 1st character (e.g. L, M, N)
else  % 'core'
    baseColors = struct('s', [0, 0, 0], 'p', [1, 0, 0], 'd', [0, 0, 1], 'f', [0, 1, 0]);
    prefixPos = 1;  % Number is 1st character (e.g. 1s1, 2p3)
    typePos = 2;    % Type is 2nd character (e.g. s, p)
end
%% 3 - Generate colors for each entry
for i = 1:nCL
    entry = char(transitionLabels(i));
    % For edges: extract FIRST edge from comma-separated list
    if strcmp(type, 'edges')
        firstEdge = split(entry, ',');
        if isempty(firstEdge) || all(cellfun(@isempty, firstEdge))
            colorList{i} = [0, 0, 0];
            continue;
        end
        entry = char(strtrim(firstEdge{1}));  % Use only first edge (e.g. "N7" from "N7,O6,P2")
    end
    if length(entry) < 2
        colorList{i} = [0, 0, 0];
        continue;
    end
    prefixStr = entry(prefixPos);
    typeChar = entry(typePos);
    prefix = str2double(prefixStr);
    if isnan(prefix) || ~isfield(baseColors, typeChar)
        baseColor = [0, 0, 0];
    else
        baseColor = baseColors.(typeChar);
    end
    shadeFactor = (prefix - 1) / 6;
    color = baseColor * (1 - shadeFactor) + 0.75*[1, 1, 1] * shadeFactor;
    color(isnan(color)) = 0;
    colorList{i} = color;
end
end

% Detect if input names are 'edges' (letter+digit, comma-separated) or 'core' (digit+letter)
function type = detect_type(names)
type = '';
for i = 1:length(names)
    entry = strtrim(char(names(i)));
    % Check for comma-separated edges
    if contains(entry, ',')
        type = 'edges';
        return;
    end
    % Remove any extra characters and check patterns
    entry = regexprep(entry, '[^0-9a-zA-Z]', '');
    if isempty(entry)
        continue;
    end
    % Core pattern: starts with digit(s), then orbital letter(s), optional spin digit
    if ~isempty(regexp(entry, '^\d+[spdf][\d]*$', 'once'))
        if strcmp(type, 'edges')
            error('Mixed edge and core level names detected');
        end
        type = 'core';
        return;
    end
    % Edge pattern: starts with letter (K-P), followed by digit
    if ~isempty(regexp(entry, '^[K-P][1-9]\d*$', 'once'))
        if strcmp(type, 'core')
            error('Mixed edge and core level names detected');
        end
        type = 'edges';
        return;
    end
end
% If no clear pattern found
if isempty(type)
    type = '';
end
end