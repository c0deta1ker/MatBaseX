function [fig, beData] = view_be(formula, hv, parity)
% [fig, beData] = view_be(formula, hv, parity)
%   This function plots the binding energies of core levels for a given formula. 
%   The peak heights of the core levels are determined using data from the photoionization 
%   cross-sections database, based on the provided photon energy (default hv = 5000 eV). 
%   For compounds, the intensity of each element is scaled proportionally to its quantity 
%   in the compound, providing a good estimate of peak heights.
%
%   IN:
%   -   formula:        char or string of the compound formula; e.g. "Si", "SiO2", "GaAs", "Al2O3"
%   -   hv:             scalar of the incident photon energy used to estimate the peak height [eV]
%   -   parity:	        either +1 or -1; 
%                               +1 plots the binding energies as positive. 
%                               -1 plots the binding energies as negative.
%
%   OUT:
%   -   fig:            figure output
%   -   beData:         data structure containing all the BE data

%% Default parameters
if nargin < 2; hv = 5000;  end
if nargin < 3; parity = 1;  end
if isempty(hv); hv = 5000; end
if isempty(parity); parity = 1; end
%% Validity checks on the input parameters
formula    = string(formula);
%% 1 - Filing through all the selected elements and extracting binding energies
% Extracting Parameters
% -- Formula Parameters
vformula            = parse_chemical_formula(formula);
elements            = {vformula(:).element};
num_of_elements     = length(elements);
% -- Binding Energy & Photoionization Cross-Sections
for i = 1:num_of_elements
    [be{i}, cls{i}] = calc_be(elements{i}); 
    sigma{i}        = calc_xsect_sigma(hv, elements{i}, cls{i},[],0);
    sigma{i}(isnan(sigma{i})) = 0;
    sigma{i} = vformula(i).ratio .* sigma{i};
    % -- Removing all binding energies that are larger than the photon energy
    sigma{i}(be{i}>hv)  = 0;
end
% -- Relative Intensity
norm_val = cat(1, sigma{:});
norm_val = max(norm_val(:));
for i = 1:num_of_elements; rsigma{i} = sigma{i} ./ norm_val; end
%% 2 - Extracting the parity of the binding energies
if parity == -1
    for i = 1:length(be); be{i} = -1 .* be{i}; end
elseif parity == +1
    for i = 1:length(be); be{i} = +1 .* be{i}; end
end
%% 3 - Saving data to MATLAB data-structure
beData = struct();
beData.formula              = formula;
beData.vformula             = vformula;
beData.elements             = elements;
beData.num_of_elements      = num_of_elements;
beData.cls                  = cls;
beData.be                   = be;
beData.sigma                = sigma;
beData.rsigma               = rsigma;
%% 4 - Plotting the data
% Creating figure
fig = figure(); 
fig.Position(1) = 100; fig.Position(2) = 100;
fig.Position(3) = 1000; 
fig.Position(4) = 425;
% - Creating tiled axis
t = tiledlayout(1,1);
t.TileSpacing = 'compact';
t.Padding = 'compact';
% - Plot the figure
nexttile(); hold on; grid on; grid minor;
for i = 1:num_of_elements
    for j = 1:length(be{i})
        nCL         = length(cls{i});
        colorList   = read_be_core_levels_color(cls{i});
        for k = 1:nCL; stem(be{i}(k), rsigma{i}(k), '-', 'linewidth', 2.0, 'marker', 'none', 'color', colorList{k});end 
        for k = 1:nCL; text(be{i}(k), rsigma{i}(k), sprintf('%s%s(%.2f)', elements{i}, cls{i}(k), be{i}(k)), 'Rotation',90, 'FontWeight','normal', 'FontSize',8, 'color', colorList{k}); end
    end
end
% - Labeling the x- and y-axes
text(0.02, 0.96, sprintf("%s", formula),...
    'FontSize', 12, 'color', 'k', 'Units','normalized', 'FontWeight', 'bold', 'HorizontalAlignment','left');
text(0.02, 0.925, sprintf("hv = %.i eV", hv),...
    'FontSize', 8, 'color', 'k', 'Units','normalized', 'HorizontalAlignment','left');
xlabel('Binding Energy [eV]', 'FontWeight','bold');
ylabel('Relative Sigma [arb.]', 'FontWeight','bold');
ax = gca; ax.YScale = 'linear'; ax.XScale = 'log';
if parity == -1;        axis([-130000, -1, 0, 1.25]);
elseif parity == +1;    axis([1, 130000, 0, 1.25]);
end
end