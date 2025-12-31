function [fig, xsectData] = view_xsect(element, corelevel)
% [fig, xsectData] = view_xsect(element, corelevel)
%   This is a function that plots the photoionization cross section
%   parameters for the different formalisms that are available.
%   Additionally, a plot of the percentage difference (%) between the
%   different formalisms is also shown.
%
%   IN:
%   -   element:    	string of the element; e.g. "H", "He", "Si", "In"...
%   -   corelevel:      string of the core-level to be probed; e.g. "1s1", "2p1", "2p3", "3d5", "5f5', "5f7"...
%
%   OUT: 
%   -   fig:            figure output
%   -   xsectData:      data structure containing all of the data within the figure plot

%% Default parameters (Parameters for Silicon)
if nargin < 2; corelevel = '2p3';  end
if nargin < 1; element = 'Si';  end
if isempty(corelevel); corelevel = '2p3'; end
if isempty(element); element = 'Si'; end
%% Validity checks on the input parameters
element     = string(element);
corelevel   = string(corelevel);
%% 1 - Calculating the photoionisation parameters using each formalism
xsectData = struct();
xsectData.formalisms = {"S1973","YL1985","T2018","C2022"};
xsectData.hv = linspace(200,1e5,1e3);
for i = 1:length(xsectData.formalisms)
    [xsectData.sigma{i}, xsectData.beta{i}, xsectData.gamma{i}, xsectData.delta{i}] =...
        calc_xsect(xsectData.hv, element, corelevel, xsectData.formalisms{i});
end
%% 2 - Calculating the deviation from the Cant2022 formalism
for i = 1:length(xsectData.formalisms)-1; xsectData.sigma_err{i}  = 100 .* abs((xsectData.sigma{4} - xsectData.sigma{i}) ./ xsectData.sigma{4});end
for i = 2:length(xsectData.formalisms)-1; xsectData.beta_err{i}   = 100 .* abs((xsectData.beta{4} - xsectData.beta{i}) ./ xsectData.beta{4});end
for i = 3:length(xsectData.formalisms)-1
    xsectData.gamma_err{i}  = 100 .* abs((xsectData.gamma{4} - xsectData.gamma{i}) ./ xsectData.gamma{4});
    xsectData.delta_err{i}  = 100 .* abs((xsectData.delta{4} - xsectData.delta{i}) ./ xsectData.delta{4});
end
%% 3 - Finding the Binding Energy of the core-level
xsectData.Ebe = calc_be(element, corelevel); 
%% - 4 - Plotting a summary of the final photoionization cross-sections figure
% -- Defining the constants
cols = lines(length(xsectData.formalisms));
% -- Creating a figure
fig = figure(); 
fig.Position(1) = 100; fig.Position(2) = 100;
fig.Position(3) = 4*400; 
fig.Position(4) = 1.5*400;
% -- Creating a tiled axis
t = tiledlayout(3,4);
t.TileSpacing = 'compact';
t.Padding = 'compact';
title(t,sprintf("%s(%s) - %.2f eV", element, corelevel, xsectData.Ebe),'FontWeight','bold','interpreter', 'none', 'fontsize', 16);
% -- Plot of SIGMA
nexttile([2 1]);hold on; grid on; grid minor;
loglog(xsectData.hv, xsectData.sigma{4}, 'd-', 'color', cols(4,:), 'markerfacecolor', cols(4,:), 'LineWidth', 1, 'markersize', 5);
loglog(xsectData.hv, xsectData.sigma{1}, 'x-', 'color', cols(1,:), 'markerfacecolor', cols(1,:), 'LineWidth', 1, 'markersize', 5);
loglog(xsectData.hv, xsectData.sigma{2}, 'o-', 'color', cols(2,:), 'markerfacecolor', cols(2,:), 'LineWidth', 1, 'markersize', 5);
loglog(xsectData.hv, xsectData.sigma{3}, '+-', 'color', cols(3,:), 'markerfacecolor', cols(3,:), 'LineWidth', 1, 'markersize', 5);
% -- Add a legend
h       = zeros(4, 1);
h(1)    = plot(NaN,NaN, 'x-', 'color', cols(1,:), 'markerfacecolor', cols(1,:), 'LineWidth', 1, 'markersize', 5);
h(2)    = plot(NaN,NaN, 'o-', 'color', cols(2,:), 'markerfacecolor', cols(2,:), 'LineWidth', 1, 'markersize', 5);
h(3)    = plot(NaN,NaN, '+-', 'color', cols(3,:), 'markerfacecolor', cols(3,:), 'LineWidth', 1, 'markersize', 5);
h(4)    = plot(NaN,NaN, 'd-', 'color', cols(4,:), 'markerfacecolor', cols(4,:), 'LineWidth', 1, 'markersize', 5);
legend(h, xsectData.formalisms, 'fontsize', 7, 'location', 'best');
% -- Labelling the x- and y-axes
title('\sigma', 'FontSize', 15);
ylabel(' \sigma [barn/atom] ', 'FontWeight','bold');
ax = gca; ax.YScale = 'log'; ax.XScale = 'log';
axis([1e2, 1e5, 1e-4, 1e8]);
% -- Plot of BETA
nexttile([2 1]);hold on; grid on; grid minor;
loglog(xsectData.hv, xsectData.beta{4}, 'd-', 'color', cols(4,:), 'markerfacecolor', cols(4,:), 'LineWidth', 1, 'markersize', 5);
loglog(xsectData.hv, xsectData.beta{2}, 'o-', 'color', cols(2,:), 'markerfacecolor', cols(2,:), 'LineWidth', 1, 'markersize', 5);
loglog(xsectData.hv, xsectData.beta{3}, '+-', 'color', cols(3,:), 'markerfacecolor', cols(3,:), 'LineWidth', 1, 'markersize', 5);
% -- Add a legend
h       = zeros(3, 1);
h(1)    = plot(NaN,NaN, 'o-', 'color', cols(2,:), 'markerfacecolor', cols(2,:), 'LineWidth', 1, 'markersize', 5);
h(2)    = plot(NaN,NaN, '+-', 'color', cols(3,:), 'markerfacecolor', cols(3,:), 'LineWidth', 1, 'markersize', 5);
h(3)    = plot(NaN,NaN, 'd-', 'color', cols(4,:), 'markerfacecolor', cols(4,:), 'LineWidth', 1, 'markersize', 5);
legend(h, xsectData.formalisms{2:4}, 'fontsize', 7, 'location', 'best');
% -- Labelling the x- and y-axes
title('\beta', 'FontSize', 15);
ylabel(' \beta ', 'FontWeight','bold');
axis([0, 1e4, -1, 2.5]);
ax = gca; ax.YScale = 'linear'; ax.XScale = 'linear';
yline(0, 'k-', 'LineWidth',1, 'HandleVisibility','off');
% -- Plot of GAMMA
nexttile([2 1]);hold on; grid on; grid minor;
loglog(xsectData.hv, xsectData.gamma{4}, 'd-', 'color', cols(4,:), 'markerfacecolor', cols(4,:), 'LineWidth', 1, 'markersize', 5);
loglog(xsectData.hv, xsectData.gamma{3}, '+-', 'color', cols(3,:), 'markerfacecolor', cols(3,:), 'LineWidth', 1, 'markersize', 5);
% -- Add a legend
h       = zeros(2, 1);
h(1)    = plot(NaN,NaN, '+-', 'color', cols(3,:), 'markerfacecolor', cols(3,:), 'LineWidth', 1, 'markersize', 5);
h(2)    = plot(NaN,NaN, 'd-', 'color', cols(4,:), 'markerfacecolor', cols(4,:), 'LineWidth', 1, 'markersize', 5);
legend(h, xsectData.formalisms{3:4}, 'fontsize', 7, 'location', 'best');
% -- Labelling the x- and y-axes
title('\gamma', 'FontSize', 15);
ylabel(' \gamma ', 'FontWeight','bold');
axis([0, 1e4, -1, 2.5]);
ax = gca; ax.YScale = 'linear'; ax.XScale = 'linear';
yline(0, 'k-', 'LineWidth',1, 'HandleVisibility','off');
% -- Plot of DELTA
nexttile([2 1]);hold on; grid on; grid minor;
loglog(xsectData.hv, xsectData.delta{4}, 'd-', 'color', cols(4,:), 'markerfacecolor', cols(4,:), 'LineWidth', 1, 'markersize', 5);
loglog(xsectData.hv, xsectData.delta{3}, '+-', 'color', cols(3,:), 'markerfacecolor', cols(3,:), 'LineWidth', 1, 'markersize', 5);
% -- Add a legend
h       = zeros(2, 1);
h(1)    = plot(NaN,NaN, '+-', 'color', cols(3,:), 'markerfacecolor', cols(3,:), 'LineWidth', 1, 'markersize', 5);
h(2)    = plot(NaN,NaN, 'd-', 'color', cols(4,:), 'markerfacecolor', cols(4,:), 'LineWidth', 1, 'markersize', 5);
legend(h, xsectData.formalisms{3:4}, 'fontsize', 7, 'location', 'best');
% -- Labelling the x- and y-axes
title('\delta', 'FontSize', 15);
ylabel(' \delta ', 'FontWeight','bold');
axis([0, 1e4, -0.10, 0.55]);
ax = gca; ax.YScale = 'linear'; ax.XScale = 'linear';
yline(0, 'k-', 'LineWidth',1, 'HandleVisibility','off');

% -- Plot of SIGMA DEVIATION
nexttile;hold on; grid on; grid minor;
plot(xsectData.hv, xsectData.sigma_err{1}, 'x', 'color', cols(1,:), 'markerfacecolor', cols(1,:), 'LineWidth', 1);
plot(xsectData.hv, xsectData.sigma_err{2}, 'o', 'color', cols(2,:), 'markerfacecolor', cols(2,:), 'LineWidth', 1);
plot(xsectData.hv, xsectData.sigma_err{3}, '+', 'color', cols(3,:), 'markerfacecolor', cols(3,:), 'LineWidth', 1);
% -- Add a legend
h       = zeros(3, 1);
h(1)    = plot(NaN,NaN, 'x', 'color', cols(1,:), 'markerfacecolor', cols(1,:), 'LineWidth', 1);
h(2)    = plot(NaN,NaN, 'o', 'color', cols(2,:), 'markerfacecolor', cols(2,:), 'LineWidth', 1);
h(3)    = plot(NaN,NaN, '+', 'color', cols(3,:), 'markerfacecolor', cols(3,:), 'LineWidth', 1);
legend(h, xsectData.formalisms{1:3}, 'fontsize', 7, 'location', 'best');
% -- Labelling the x- and y-axes
xlabel(' Photon Energy [eV] ', 'FontWeight','bold');
ylabel(' Deviation From C2022 (%) ', 'FontWeight','bold');
ax = gca; ax.XScale = 'log'; ax.YScale = 'log';
axis([1e2, 1e5, 1e-2, 1e4]);
yline(10, 'k-', 'LineWidth',1, 'HandleVisibility','off');
% -- Plot of BETA DEVIATION
nexttile;hold on; grid on; grid minor;
plot(xsectData.hv, xsectData.beta_err{2}, 'o', 'color', cols(2,:), 'markerfacecolor', cols(2,:), 'LineWidth', 1);
plot(xsectData.hv, xsectData.beta_err{3}, '+', 'color', cols(3,:), 'markerfacecolor', cols(3,:), 'LineWidth', 1);
% -- Add a legend
h       = zeros(2, 1);
h(1)    = plot(NaN,NaN, 'o', 'color', cols(2,:), 'markerfacecolor', cols(2,:), 'LineWidth', 1);
h(2)    = plot(NaN,NaN, '+', 'color', cols(3,:), 'markerfacecolor', cols(3,:), 'LineWidth', 1);
legend(h, xsectData.formalisms{2:3}, 'fontsize', 7, 'location', 'best');
% -- Labelling the x- and y-axes
xlabel(' Photon Energy [eV] ', 'FontWeight','bold');
ax = gca; ax.YScale = 'log';
axis([0, 1e4, 1e-2, 1e4]);
yline(10, 'k-', 'LineWidth',1, 'HandleVisibility','off');
% -- Plot of GAMMA DEVIATION
nexttile;hold on; grid on; grid minor;
plot(xsectData.hv, xsectData.gamma_err{3}, '+', 'color', cols(3,:), 'markerfacecolor', cols(3,:), 'LineWidth', 1);
% -- Add a legend
h       = zeros(1, 1);
h(1)    = plot(NaN,NaN, '+', 'color', cols(3,:), 'markerfacecolor', cols(3,:), 'LineWidth', 1);
legend(h, xsectData.formalisms{3}, 'fontsize', 7, 'location', 'best');
% -- Labelling the x- and y-axes
xlabel(' Photon Energy [eV] ', 'FontWeight','bold');
ax = gca; ax.YScale = 'log';
axis([0, 1e4, 1e-2, 1e4]);
yline(10, 'k-', 'LineWidth',1, 'HandleVisibility','off');
% -- Plot of DELTA DEVIATION
nexttile;hold on; grid on; grid minor;
plot(xsectData.hv, xsectData.delta_err{3}, '+', 'color', cols(3,:), 'markerfacecolor', cols(3,:), 'LineWidth', 1);
% -- Add a legend
h       = zeros(1, 1);
h(1)    = plot(NaN,NaN, '+', 'color', cols(3,:), 'markerfacecolor', cols(3,:), 'LineWidth', 1);
legend(h, xsectData.formalisms{3}, 'fontsize', 7, 'location', 'best');
% -- Labelling the x- and y-axes
xlabel(' Photon Energy [eV] ', 'FontWeight','bold');
ax = gca; ax.YScale = 'log';
axis([0, 1e4, 1e-2, 1e4]);
yline(10, 'k-', 'LineWidth',1, 'HandleVisibility','off');

end