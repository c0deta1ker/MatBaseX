function bzSlice_rot = rotate_bz_slice(bzSlice, rot_args, plot_result)
% bzSlice_rot = rotate_bz_slice(bzSlice, rot_args, plot_result)
%   Function to perform a Rotate transformation on the BZ slice.
%
%   IN:
%   -   bzSlice:        MATLAB data structure containing BZ slice data from 'get_bz_slice()'
%   -   rot_args:       {1×1} cell of {Rtheta}, the rotation angle in degrees.
%   -   plot_result:    if 1, will plot figure summary, otherwise it wont.
%
%   OUT: 
%   -   bzSlice_rot:    MATLAB data structure containing the final, rotated BZ slice

%% Default parameters
if nargin < 3; plot_result=0; end
if nargin < 2; rot_args = {0}; end
if isempty(rot_args); rot_args = {0}; end
if isempty(plot_result); plot_result = 0; end
%% Validity checks on the input parameters
if length(rot_args) ~= 1; rot_args = {0}; end

%% - 1 - Initialising the transformation parameters
% - Extracting the transformation values
Rtheta    = rot_args{1};
% - Defining the 2D rotation matrix
R3Dmatrix = [...
    cos(deg2rad(Rtheta)),  sin(deg2rad(Rtheta));...
    -sin(deg2rad(Rtheta)), cos(deg2rad(Rtheta))];
%% 2 - Performing transformation operation
bzSlice_rot = bzSlice;
% -- Applying rotation on single BZ cell
xdat0 = bzSlice.X0; ydat0 = bzSlice.Y0;
XY      = [xdat0, ydat0];  	    % Create Matrix Of Vectors
rotXY   = XY*R3Dmatrix';        % Multiply the vectors by the rotation matrix
bzSlice_rot.X0 = rotXY(:,1);
bzSlice_rot.Y0 = rotXY(:,2);
% -- Applying rotation to all other BZ cells
for i = 1:length(bzSlice_rot.X)
    xdat = bzSlice.X{i}; ydat = bzSlice.Y{i};
    XY      = [xdat, ydat];  	    % Create Matrix Of Vectors
    rotXY   = XY*R3Dmatrix';        % Multiply the vectors by the rotation matrix
    bzSlice_rot.X{i} = rotXY(:,1);
    bzSlice_rot.Y{i} = rotXY(:,2);
end
% -- Appending the rotation to an argument
bzSlice_rot.Rtheta = Rtheta;

%% -- For Debugging
if plot_result == 1
    fig = figure(); 
    fig.Position(3) = 400*2; 
    fig.Position(4) = 400*0.9; 
    % - Plotting original BZ
    subplot(121); hold on;
    for i = 1:length(bzSlice_rot.X)
        plot(bzSlice.X{i}, bzSlice.Y{i}, 'k-','linewidth', 2);
    end
    xlabel('$$ \bf  X $$', 'Interpreter', 'latex');
    ylabel('$$ \bf  Y $$', 'Interpreter', 'latex');
    axis(1.5*[-norm(bzSlice.gX), norm(bzSlice.gX), -norm(bzSlice.gY),norm(bzSlice.gY)]);
    axis equal;
    line([0 0], [-1e5, 1e5], 'Color', [0 0 0], 'LineWidth', 0.75, 'Linestyle', '--');
    line([-1e5, 1e5], [0 0], 'Color', [0 0 0], 'LineWidth', 0.75, 'Linestyle', '--');
    title_txt1 = sprintf("Initial BZ slice");
    title(title_txt1);
    % -- Defining the axes properties
    % - Figure formatting
    ax = gca;
    % Font properties
    ax.FontName = 'Helvetica'; ax.FontSize = 12;
    % Tick properties
    ax.TickLabelInterpreter = 'latex';
    ax.TickDir = 'both';
    % Box Styling properties
    ax.LineWidth = 1.2;

    % - Plotting rotated BZ
    subplot(122); hold on;
    for i = 1:length(bzSlice_rot.X)
        plot(bzSlice_rot.X{i}, bzSlice_rot.Y{i}, 'b-','linewidth', 2);
    end
    xlabel('$$ \bf  X $$', 'Interpreter', 'latex');
    ylabel('$$ \bf  Y $$', 'Interpreter', 'latex');
    axis(1.5*[-norm(bzSlice.gX), norm(bzSlice.gX), -norm(bzSlice.gY),norm(bzSlice.gY)]);
    axis equal;
    line([0 0], [-1e5, 1e5], 'Color', [0 0 0], 'LineWidth', 0.75, 'Linestyle', '--');
    line([-1e5, 1e5], [0 0], 'Color', [0 0 0], 'LineWidth', 0.75, 'Linestyle', '--');
    title_txt2 = sprintf("Rot. BZ slice; %.2f deg", Rtheta);
    title(title_txt2);
    % -- Defining the axes properties
    % - Figure formatting
    ax = gca;
    % Font properties
    ax.FontName = 'Helvetica'; ax.FontSize = 12;
    % Tick properties
    ax.TickLabelInterpreter = 'latex';
    ax.TickDir = 'both';
    % Box Styling properties
    ax.LineWidth = 1.2;
end
end