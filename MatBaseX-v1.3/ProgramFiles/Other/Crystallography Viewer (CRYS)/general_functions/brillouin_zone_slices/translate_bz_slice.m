function bzSlice_trans = translate_bz_slice(bzSlice, trans_args, plot_result)
% bzSlice_trans = translate_bz_slice(bzSlice, trans_args, plot_result)
%   Function to perform a Translation transformation on the BZ slice.
%
%   IN:
%   -   bzSlice:        MATLAB data structure containing BZ slice data from 'get_bz_slice()'
%   -   trans_args:     {1×2} cell of {Tx, Ty}
%   -   plot_result:    if 1, will plot figure summary, otherwise it wont.
%
%   OUT: 
%   -   bzSlice_trans:    MATLAB data structure containing the final, rotated BZ slice

%% Default parameters
if nargin < 3; plot_result=0; end
if nargin < 2; trans_args = {0, 0}; end
if isempty(trans_args); trans_args = {0, 0}; end
if isempty(plot_result); plot_result = 0; end
%% Validity checks on the input parameters
if length(trans_args) ~= 2; trans_args = {0, 0}; end

%% - 1 - Initialising the transformation parameters
% - Extracting the transformation values
Tx    = trans_args{1};
Ty    = trans_args{2};
% - Defining the transformation matrix
Tmatrix = [...
    1, 0, 0;...
    0, 1, 0;...
    Tx, Ty, 1];
Ttform  = affine2d(Tmatrix);
%% 2 - Performing transformation operation
bzSlice_trans = bzSlice;
% -- Applying translation on single BZ cell
xdat0 = bzSlice.X0; ydat0 = bzSlice.Y0;
bzSlice_trans.X0  = xdat0 + Tx;
bzSlice_trans.Y0  = ydat0 + Ty;
% -- Applying translation to all other BZ cells
for i = 1:length(bzSlice_trans.X)
    xdat = bzSlice.X{i}; ydat = bzSlice.Y{i};
    bzSlice_trans.X{i}  = xdat + Tx;
    bzSlice_trans.Y{i}  = ydat + Ty;
end
% -- Appending the translation to an argument
bzSlice_trans.TxTy = [Tx, Ty];

%% -- For Debugging
if plot_result == 1
    fig = figure(); 
    fig.Position(3) = 400*2; 
    fig.Position(4) = 400*0.9; 
    % - Plotting original BZ
    subplot(121); hold on;
    for i = 1:length(bzSlice.X)
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
    for i = 1:length(bzSlice_trans.X)
        plot(bzSlice_trans.X{i}, bzSlice_trans.Y{i}, 'b-','linewidth', 2);
    end
    xlabel('$$ \bf  X $$', 'Interpreter', 'latex');
    ylabel('$$ \bf  Y $$', 'Interpreter', 'latex');
    axis(1.5*[-norm(bzSlice.gX), norm(bzSlice.gX), -norm(bzSlice.gY),norm(bzSlice.gY)]);
    axis equal;
    line([0 0], [-1e5, 1e5], 'Color', [0 0 0], 'LineWidth', 0.75, 'Linestyle', '--');
    line([-1e5, 1e5], [0 0], 'Color', [0 0 0], 'LineWidth', 0.75, 'Linestyle', '--');
    title_txt2 = sprintf("Trans. BZ slice; [%.2f, %.2f]", [Tx, Ty]);
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