function fig = simul_pes_nlayer_sample(lyr_mat, lyr_thick)
% fig = simul_pes_nlayer_sample(lyr_mat, lyr_thick)
%   This function generates a plot of a user-defined sample stack. The stack
%   consists of N layers, each with specified materials and thicknesses.
%   The layers are defined using a top-down approach, starting from the 
%   surface and ending with the bulk. The 'lyr_mat' parameter defines the 
%   materials for each layer, and 'lyr_thick' specifies the thickness of 
%   each layer. To specify the bulk layer, set the final 'lyr_thick' value to 'Inf'.
%
%   IN:
%   -   lyr_mat:        Mx1 cell-vector of the material for each layer in the stack; e.g. "Si", "SiO2", "Al2O3"...
%   -   lyr_thick:      Mx1 cell-vector of the thickness of each layer in the stack (nm)
%
%   OUT:
%   -   fig:            output MATLAB figure.

%% Validity check on inputs
% -- Ensuring the user-defined material input is a cell-array
if ~iscell(lyr_mat);        lyr_mat = cellstr(lyr_mat); end
if ~iscell(lyr_thick);      lyr_thick = num2cell(lyr_thick); end
%% Defining constants
Nlyrs       = length(lyr_mat);
% -- Verify that the input layer variables are consistent in size
lyr_thick   = lyr_thick(1:Nlyrs);
%% 1    :   Extracting the centre of each layer
xpad        = 10;
lyr_z0      = cell(size(Nlyrs));
if Nlyrs == 1
    lyr_z0{1}       = xpad;
    lyr_thick{1}    = xpad;
else
    for i = 1:Nlyrs
        if i == 1;          lyr_z0{i} = 0.5 * sum(cell2mat(lyr_thick(i)));
        elseif i == Nlyrs;  lyr_z0{i} = sum(cell2mat(lyr_thick(1:i-1))) + xpad;
        else;               lyr_z0{i} = sum(cell2mat(lyr_thick(1:i-1))) + 0.5 * sum(cell2mat(lyr_thick(i)));
        end
    end
end
%% 2    :   Plotting the the material stack 
if Nlyrs == 1
    y_cum   = cell2mat(lyr_thick);
else
    y_cum   = cumsum(cell2mat(lyr_thick));
    y_cum(isinf(y_cum)) = y_cum(end-1) + xpad;
end
%% 2    :   Calculating the relative atomic concentration of each element in the material
for i = 1:Nlyrs
    formula{i} = parse_chemical_formula(lyr_mat{i});
    for j = 1:length(formula{i})
        elements{i}{j}  = formula{i}(j).element;
        ratio{i}{j}     = formula{i}(j).ratio;
    end
end
%% 3    :   Plot the sample stack
% - Initializing variables
lwidth = 1.;
colorList = read_pes_nlayer_color(Nlyrs);
% - Creating a figure
fig = figure(); 
fig.Position(1) = 100; fig.Position(2) = 100;
fig.Position(3) = 500; 
fig.Position(4) = 650;
% - Creating a tiled axis
t = tiledlayout(1,1);
t.TileSpacing = 'compact';
t.Padding = 'compact';
% - Plot data
nexttile(); hold on; grid on; grid minor;
labels = {};
% -- Adding text for each material type
for i = 1:Nlyrs
    for j = 1:length(ratio{i})
        if j == 1
            if i == 1
                patch([0, 0, 1, 1, 0].*ratio{i}{j}, [0, y_cum(i), y_cum(i), 0, 0].*-1,...
                    colorList{i}, 'edgecolor', [0 0 0], 'linewidth', lwidth);
            else
                patch([0, 0, 1, 1, 0].*ratio{i}{j}, [y_cum(i-1), y_cum(i), y_cum(i), y_cum(i-1), y_cum(i-1)].*-1,...
                    colorList{i}, 'edgecolor', [0 0 0], 'linewidth', lwidth);
            end
        else
            if i == 1
                patch(ratio{i}{j-1}+[0, 0, ratio{i}{j}, ratio{i}{j}, 0], [0, y_cum(i), y_cum(i), 0, 0].*-1,...
                    colorList{i}./j, 'edgecolor', [0 0 0], 'linewidth', lwidth);
            else
                patch(ratio{i}{j-1}+[0, 0, ratio{i}{j}, ratio{i}{j}, 0], [y_cum(i-1), y_cum(i), y_cum(i), y_cum(i-1), y_cum(i-1)].*-1,...
                    colorList{i}./j, 'edgecolor', [0 0 0], 'linewidth', lwidth);
            end
        end
        labels{end+1} = lyr_mat{i};
    end
end
% -- Adding text for each material type
for i = 1:Nlyrs
    if i == 1;  y_loc = 0 - 0.5*(y_cum(i) - 0);
    else;       y_loc = -y_cum(i-1) - 0.5*(y_cum(i) - y_cum(i-1));
    end
    for j = 1:length(ratio{i})
        if j == 1
            text(0.5*ratio{i}{j}, y_loc, sprintf("(%.2f) %s",ratio{i}{j}, elements{i}{j}),...
                'color', 'k', 'horizontalalignment', 'center',...
                'verticalalignment', 'middle', 'FontWeight','bold', 'FontSize',12); 
        else
            text(ratio{i}{j-1}+0.5*ratio{i}{j}, y_loc, sprintf("(%.2f) %s",ratio{i}{j}, elements{i}{j}),...
                'color', 'k', 'horizontalalignment', 'center',...
                'verticalalignment', 'middle', 'FontWeight','bold', 'FontSize',12); 
        end
    end
end
% - Formatting the axis
box on;
ylabel('Depth Below Surface (nm)', 'FontWeight','bold');
xlabel('Elemental Composition', 'FontWeight','bold');
axis([0, 1, -1*max(y_cum(:)), 0]);
end