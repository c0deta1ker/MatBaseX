function colorList = read_line_colors(num_colors)
% colorList = read_line_colors(num_colors)
%   This function returns a cell array of RGB colors that consistently color 
%   the plots for PES Curve Fitting.
%
%   IN: 
%   -   num_colors:     scalar of the total number of colors to produce
%
%   OUT:
%   -   colorList:      1xN cell array with the corresponding plot colors.

%% 1 : Defining Consistent Colors
bulk_color      = [169/255, 169/255, 169/255];
overlayer_color = {...
    [1.0, 0.7137, 0.7569];          % Light Pink
    [0.6784, 0.8471, 0.9020];       % Light Blue
    [0.5647, 0.9333, 0.5647];       % Light Green
    [0.6941, 0.6118, 0.8510];       % Light Purple
    [1.0, 0.8549, 0.7255];          % Peach Puff
    [0.8784, 1.0, 1.0];             % Light Cyan
    [0.8471, 0.7490, 0.8471];       % Thistle
    [1.0, 0.8941, 0.8824];          % Misty Rose
    [0.9333, 0.9098, 0.6667];       % Pale Goldenrod
    [1.0, 0.6275, 0.4784];          % Light Salmon
    [0.6902, 0.8784, 0.9020];       % Powder Blue
    [0.9020, 0.9020, 0.9804];       % Lavender
    [0.5961, 0.9843, 0.5961];       % Pale Green
    [0.8667, 0.6275, 0.8667];       % Plum
    [0.9804, 0.9412, 0.9020];       % Linen
    [1.0, 0.9725, 0.8627];          % Cornsilk
    [1.0, 1.0, 0.8784];             % Light Yellow
    [0.5294, 0.8078, 0.9216];       % Light Sky Blue
    [1.0, 0.9608, 0.9333];          % Seashell
    [0.9804, 0.9804, 0.8235];       % Light Goldenrod Yellow
};
%% 2 : Extracting consistent color list
colorList = cell(1,num_colors);
for i = 1:num_colors
    if i == 1;      colorList{i} = bulk_color;
    else;           colorList{i} = overlayer_color{i};
    end
end
end