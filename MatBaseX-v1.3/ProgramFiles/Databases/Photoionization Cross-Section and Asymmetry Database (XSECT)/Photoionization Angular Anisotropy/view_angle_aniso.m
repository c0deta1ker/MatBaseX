function [fig, anisoData] = view_angle_aniso(element, corelevel, hv, P, formalism)
% [fig, anisoData] = view_angle_aniso(element, corelevel, hv, P, formalism)
%   This function plots the photoionization angular asymmetry as a polar
%   plot for a given element and core-level. The photon energy can also be
%   chosen, as well as the degree of polarisation and the photoionization
%   cross-section formalism.
%
%   IN:
%   -   element:    	    string of the element; e.g. "H", "He", "Si", "In"...
%   -   corelevel:          string of the core-level to be probed; e.g. "5s1", "5p1", "5p3", "5d3", "5d5", "5f5', "5f7"...
%   -   hv:                 scalar or N×1 vector of the incident photon energies [eV]
%   -   P:                  scalar of degree of polarization, where 1 or 0 is equivalent to full linear polarization, and 0.5 is equivalent to unpolarized light.
%   -   formalism:          string of the photoionization cross-section formalism_xsect to use. Default:"Cant2022" ["Scofield1973","YehLindau1985","Trzhaskovskaya2018","Cant2022"]
%
%   OUT: 
%   -   fig:            figure output
%   -   anisoData:      data structure containing all of the data within the figure plot

%% -- Validity check on inputs
if nargin < 2; corelevel = []; end
if nargin < 3; hv = []; end
if nargin < 4; P = 1;  end
if nargin < 5; formalism = "C2022"; end
if isempty(corelevel); corelevel = []; end
if isempty(hv); hv = []; end
if isempty(P); P = 0.5; end
if isempty(formalism); formalism = "C2022"; end
%% Validity checks on the input parameters
element             = string(element);
corelevel           = string(corelevel);
formalism           = string(formalism);
%% 1 : Defining Variables
theta     = linspace(0, 90, 1e2);
phi       = linspace(-180, 180, 3e2)';
if isempty(corelevel)
    [be, corelevel] = calc_be(element); 
    if isempty(hv); hv = 1500 + be; end
elseif isempty(hv)
    be = [];
    for i = 1:length(corelevel)
        [be(i), ~] = calc_be(element, corelevel(i), formalism);
    end
    hv = 1500 + be;
end
if isempty(hv); hv = 5000 * ones(size(corelevel)); end
if isscalar(hv); hv = hv * ones(size(corelevel)); end
%% 2 : Determination of the Angular Anisotropy
for i = 1:length(corelevel)
    [~, beta{i}, gamma{i}, delta{i}] = calc_xsect(hv(i), element, corelevel(i), formalism);
    beta{i}(isnan(beta{i}))   = 0;
    gamma{i}(isnan(gamma{i})) = 0;
    delta{i}(isnan(delta{i})) = 0;
    F{i} = calc_angle_aniso(formalism, beta{i}, gamma{i}, delta{i}, theta, phi, P, element);
end
X = theta .* sin(deg2rad(phi));
Y = theta .* cos(deg2rad(phi));
%% 3 : Saving data to MATLAB data-structure
anisoData                 = struct();
anisoData.element         = element;
anisoData.corelevel       = corelevel;
anisoData.hv              = hv;
anisoData.P               = P;
anisoData.formalism       = formalism;
anisoData.beta            = beta;
anisoData.gamma           = gamma;
anisoData.delta           = delta;
anisoData.X               = X;
anisoData.Y               = Y;
anisoData.F               = F;
%% 4 : Plotting the data
for i = 1:length(corelevel)
    % Creating figure
    fig = figure(); 
    fig.Position(1) = 100; fig.Position(2) = 100;
    fig.Position(3) = 400; 
    fig.Position(4) = 400;
    % - Creating tiled axis
    t = tiledlayout(1,1);
    t.TileSpacing = 'compact';
    t.Padding = 'compact';
    % - Plot the figure
    nexttile(); hold on; grid on; grid minor;
    h = pcolor(X, Y, F{i}); set(h,'EdgeColor','None');
    colormap("turbo");
    axis equal;
    text(0.02, 0.98, sprintf("%s%s", element, corelevel(i)),...
        'FontSize', 12, 'color', 'k', 'Units','normalized', 'FontWeight', 'bold', 'HorizontalAlignment','left');
    text(0.02, 0.94, sprintf("hv = %.0f eV", hv(i)),...
        'FontSize', 8, 'color', 'k', 'Units','normalized', 'FontWeight', 'normal', 'HorizontalAlignment','left');
    text(0.02, 0.91, sprintf("%s", formalism),...
        'FontSize', 8, 'color', 'k', 'Units','normalized', 'HorizontalAlignment','left');
    xline(0, 'k-', 'LineWidth',1, 'HandleVisibility','off');
    yline(0, 'k-', 'LineWidth',1, 'HandleVisibility','off');
    xticks(-180:20:180);
    yticks(-180:20:180);
end
end