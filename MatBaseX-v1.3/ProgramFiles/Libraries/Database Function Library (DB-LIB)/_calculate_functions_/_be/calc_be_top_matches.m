function top_matches = calc_be_top_matches(unknown_be, plot_results)
% top_matches = calc_be_top_matches(binding_energy, plot_results)
%   This function calculates the top 5 closest matches to a given binding energy input
%   by minimizing the difference between the input and a list of 100 binding
%   energies. It outputs the top 5 matches along with their percentage likelihoods.
%
%   IN:
%   -   unknown_be:	        scalar, positive value of the unknown binding energy (eV).
%   -   plot_results:       if 1, will plot figure summary, otherwise it wont.
%
%   OUT:
%   -   top_matches:	    MATLAB data-structure of the top-5 closest matches, including (Element, CoreLevel, BindingEnergy, Difference, PercentageLikelyhood)

%% Default parameters
if nargin < 2; plot_results = 0;  end
if isempty(plot_results); plot_results = 0; end
%% Validity check on inputs
unknown_be          = abs(unknown_be);   % Ensure binding energy is positive
%% 1 - Extracting a comprehensive list of all binding energies
atom_be_table           = read_be_all_elements();
% -- Extracting all binding energies
all_binding_energies    = cell2mat(table2cell(atom_be_table(:,3)));
%% 2 - Finding the top 5 best matches
differences             = abs(unknown_be - all_binding_energies);
total_differences       = sum(differences);
% - Find indices of the top 5 smallest differences
[~, sortedIndices]      = sort(differences);
top_indices             = sortedIndices(1:5);
norm_val                = sum(differences(top_indices));
% - Create a structure array of top 5 matches with percentage likelihood
top_matches = struct();
for i = 1:5
    idx                                 = top_indices(i);
    top_matches(i).Element               = atom_be_table{idx,1}{1};
    top_matches(i).CoreLevel             = atom_be_table{idx,2}{1};
    top_matches(i).BindingEnergy         = atom_be_table{idx,3}{1};
    top_matches(i).Difference            = differences(idx);
    top_matches(i).PercentageLikelihood  = round((1 - (differences(idx) / norm_val)) * 100, 4);
end

%% -- Plot for debugging
if plot_results == 1
    % - Printing text output
    info = "";
    info = info + sprintf(" Unknown Binding Energy: %.4e eV\n", unknown_be);
    info = info +  sprintf(" Top-Matches: \n");
    for j = 1:length(top_matches)
        info = info + sprintf("  %i. %s(%s):\t BE=%.4eeV - Diff=%.4eeV - Likelyhood=%.1fpc\n",...
            j, top_matches(j).Element, top_matches(j).CoreLevel, top_matches(j).BindingEnergy, top_matches(j).Difference, top_matches(j).PercentageLikelihood);
    end
    fprintf(info);
    % - Creating figure
    fig = figure(); 
    fig.Position(1) = 100; fig.Position(2) = 100;
    fig.Position(3) = 700; 
    fig.Position(4) = 450;
    % - Creating tiled axis
    t = tiledlayout(1,1);
    t.TileSpacing = 'compact';
    t.Padding = 'compact';
    nexttile(); hold on; grid on; grid minor;
    stem(unknown_be, 100, 'k-', 'linewidth', 3, 'Marker', 'none'); 
    cols = lines(5);
    for i = 1:length(top_matches)
        stem(top_matches(i).BindingEnergy, top_matches(i).PercentageLikelihood,...
            'k-', 'linewidth', 1.5, 'color', cols(i,:), 'Marker', 'none'); 
        text(top_matches(i).BindingEnergy, top_matches(i).PercentageLikelihood, sprintf('%s%s(%.2f)', top_matches(i).Element, top_matches(i).CoreLevel, top_matches(i).BindingEnergy),...
            'Rotation',90, 'FontWeight','normal', 'FontSize',8);
    end
    % - Adding text
    % - Labeling the x- and y-axes
    text(0.02, 0.96, sprintf("Unknown BE = %.4f eV", unknown_be),...
        'FontSize', 10, 'color', 'k', 'Units','normalized', 'FontWeight', 'bold', 'HorizontalAlignment','left');
    % - Labeling the x- and y-axes
    xlabel(' Binding Energy [eV] ', 'FontWeight','bold');
    ylabel(' Percentage Likelyhood (%)  ', 'FontWeight','bold');
    ax = gca; ax.YScale = 'linear'; ax.XScale = 'linear';
    ylim([0, 150]);
end
end