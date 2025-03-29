function [info_depth, lyr_depth, lyr_Int0] = simul_pes_nlayer_info_depth(lyr_mat, lyr_thick, ke, theta, formalism_imfp, plot_result)
% [info_depth, lyr_depth, lyr_Int0] = simul_pes_nlayer_info_depth(lyr_mat, lyr_thick, ke, theta, formalism_imfp, plot_result)
%   Function that calculates the information depth (ID), sometimes referred
%   to as the sampling depth, for a particular material stack composed of 
%   N-layers and PES configuration. The ID is the depth at which 95% of the 
%   photoelectron signal originates. The layer stack, incident geometry, 
%   and IMFP formalism can be defined.
%   [1] C. J. Powell, Practical guide for inelastic mean free paths, effective attenuation lengths, mean escape depths, and information depths in x-ray photoelectron spectroscopy (2020)
%   [2] M. P. Seah, Quantitative electron spectroscopy of surfaces A Standard Data Base for Electron Inelastic Mean Free Paths in Solids (1979)
%
%   IN:
%   -   lyr_mat:  	        Mx1 cell-vector of the material for each layer in the stack; e.g. "Si", "SiO2", "Al2O3"...
%   -   lyr_thick:	        Mx1 cell-vector of the thickness of each layer in the stack (nm)
%   -   ke:                 scalar of the photoelectron kinetic energy [eV]
%   -   theta:              scalar of the emission angle of the photoelectrons (i.e. normal emission = 0) [degree]
%   -   formalism_imfp:     string for imfp calculator formalism. Default:"S2" ["Universal","Optical","TPP2M","TPP2M-avg","S1","S2","S3","S4"]
%   -   plot_results:       if 1, will plot figure summary, otherwise it wont.
%
%   OUT:
%   -   info_depth:         scalar of the photoelectron information depth [nm]
%   -   lyr_z0:             N×1 column vector of the depth axis [nm]
%   -   lyr_Int0:           N×1 column vector of the normalized photoelectron intensity

%% Default parameters
if nargin < 3; ke = 1000; end
if nargin < 4; theta = 0; end
if nargin < 5; formalism_imfp = "JTP"; end
if nargin < 6; plot_result = 0; end
if isempty(ke); ke = 1000; end
if isempty(theta); theta = 0; end
if isempty(formalism_imfp); formalism_imfp = "JTP"; end
if isempty(plot_result); plot_result = 0; end
%% Validity check on inputs
% -- Ensuring the user-defined material input is a cell-array
if ~iscell(lyr_mat);        lyr_mat = cellstr(lyr_mat); end
if ~iscell(lyr_thick);      lyr_thick = num2cell(lyr_thick); end
% -- Ensuring the formalisms are strings
formalism_imfp      = string(formalism_imfp);
%% Defining constants
Nlyrs       = length(lyr_mat);
% -- Verify that the input layer variables are consistent in size
lyr_thick   = lyr_thick(1:Nlyrs);
%% 1    :   Determine the IMFP for each material (in Angstrom)
lyr_imfp = cell(size(lyr_mat));
for i = 1:Nlyrs
    lyr_imfp{i}     = calc_imfp(ke, formalism_imfp, lyr_mat{i}); 
    lyr_imfp{i}     = 0.1 .* lyr_imfp{i};  % Convert the IMFP into nm
end
%% 2    :   Extract the photoelectron intensity attenuation lengths
% -- Initialising variables
Theta       = deg2rad(theta);
xpad        = 20;
lyr_depth   = 0:0.01:sum(cell2mat(lyr_thick(1:end-1)))+xpad;
lyr_z0      = cell(size(Nlyrs)); lyr_tophat = cell(size(Nlyrs));
lyr_Int     = cell(size(Nlyrs));
% -- Calculating the IMFP decay for each layer
for i = 1:Nlyrs
    % -- Extracting the layer centre position
    if i == Nlyrs;  lyr_z0{i} = sum(cell2mat(lyr_thick(1:i-1))) + xpad;
    elseif i == 1;          lyr_z0{i} = 0.5 * sum(cell2mat(lyr_thick(i)));
    else;               lyr_z0{i} = sum(cell2mat(lyr_thick(1:i-1))) + 0.5 * sum(cell2mat(lyr_thick(i)));
    end
    % -- Defining a top-hat function that spans over the designated layer
    if i == Nlyrs;      lyr_tophat{i} = curve_tophat(lyr_depth, lyr_z0{i}, 1, 2*xpad);
    else;               lyr_tophat{i} = curve_tophat(lyr_depth, lyr_z0{i}, 1, lyr_thick{i});
    end
    % -- Scaling the top-hat function to have a decay length equal to IMFP
    if i == Nlyrs;      lyr_Int{i} = lyr_tophat{i} .* exp(-(lyr_depth-(lyr_z0{i}-xpad))./ (lyr_imfp{i} .* cos(Theta)));
    else;               lyr_Int{i} = lyr_tophat{i} .* exp(-(lyr_depth-(lyr_z0{i}-0.5*lyr_thick{i}))./ (lyr_imfp{i} .* cos(Theta)));
    end
end
% -- Apply a consistency across the interfaces of each layer
lyr_Scale = cell(size(Nlyrs)); lyr_Int0 = cell(size(Nlyrs));
for i = 1:Nlyrs
    if i == 1
        lyr_Int0{i} = lyr_Int{i};
        lyr_Scale{i} = exp(-((lyr_z0{i} + 0.5*lyr_thick{i}))./ (lyr_imfp{i} .* cos(Theta)));
    else          
        lyr_Int0{i}     = lyr_Scale{i-1} .* lyr_Int{i};
        lyr_Scale{i}    = min(lyr_Int0{i}(lyr_Int0{i}>0));
    end
end
% -- Calculate the breakdown of total intensities
lyr_pc = cell(size(Nlyrs));
for i = 1:Nlyrs; lyr_pc{i} = trapz(lyr_depth, lyr_Int0{i}); end
norm_val = sum(cell2mat(lyr_pc(:)));
for i = 1:Nlyrs; lyr_pc{i} = 100 * (lyr_pc{i} ./ norm_val); end
%% 3    :   Extracting the calculated probing depth
lyr_final = zeros(size(lyr_depth));
for i = 1:Nlyrs; lyr_final = lyr_final + lyr_Int0{i}; end
[~, idx] = min(abs(lyr_final - 0.05));
info_depth = lyr_depth(idx);
%% -- Validity check on outputs
% -- Ensure column vector outputs
if isrow(lyr_depth); lyr_depth = lyr_depth'; end
for i = 1:Nlyrs; if isrow(lyr_Int0{i}); lyr_Int0{i} = lyr_Int0{i}'; end; end
%% -- Plot for debugging
if plot_result == 1
    % - Initializing variables
    colorList = read_pes_nlayer_color(Nlyrs);
    % - Creating a figure
    fig = figure(); 
    fig.Position(1) = 100; fig.Position(2) = 100;
    fig.Position(3) = 550; 
    fig.Position(4) = 500;
    % - Creating a tiled axis
    t = tiledlayout(1,1);
    t.TileSpacing = 'compact';
    t.Padding = 'compact';
    % - Plot data
    nexttile(); hold on; grid on; grid minor;
    lgnd_txt = cell(size(Nlyrs));
    for i = Nlyrs:-1:1
        area(lyr_depth, lyr_Int0{i}, 'facecolor', colorList{i}, 'edgecolor', 'none'); 
        lgnd_txt{i} = sprintf("%s(\\lambda=%.2fnm)-%.1f%%", lyr_mat{i}, lyr_imfp{i}, lyr_pc{i});
    end
    plot(lyr_depth, lyr_final, 'k-', 'linewidth', 1.5, 'HandleVisibility','off');
    % - Formatting the axis
    xlabel('Depth Below Surface (nm)', 'FontWeight','bold');
    ylabel('Normalised Intensity', 'FontWeight','bold');
    axis([0, max(lyr_depth(:)), 0, 1.10]);
    legend(fliplr(lgnd_txt), 'location', 'northeast', 'FontSize', 9);
    crosshair(info_depth, 0.05, 'k:', 'LineWidth',1, 'HandleVisibility','off');
    text(0.015, 0.98, sprintf("I.D = %.2f nm", info_depth(1)),...
        'FontSize', 10, 'FontWeight', 'Bold', 'color', 'k', 'Units','normalized', 'HorizontalAlignment','left');
    text(0.015, 0.95, sprintf("KE = %i eV, \\theta = %i deg.", ke(1), theta(1)),...
        'FontSize', 9, 'color', 'k', 'Units','normalized', 'HorizontalAlignment','left');
    text(0.015, 0.92, sprintf("%s", formalism_imfp),...
        'FontSize', 9, 'color', 'k', 'Units','normalized', 'HorizontalAlignment','left');
end
end