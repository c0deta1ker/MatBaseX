function FU = calc_xsect_angle_aniso_FU(hv, element, corelevel, omega, extrapolate, plot_results)
% FU = calc_xsect_angle_aniso_FU(hv, element, corelevel, omega, extrapolate, plot_results)
%  VALID FOR THE HARD X-RAY ENERGY RANGE : 1000 - 10000 eV
%   This function calculates the angular anisotropy factor, FU, for 
%   unpolarized light that is incident on the sample. FU depends on the 
%   experimental geometry, which is defined by spherical coordinates. 
%   The only angle needed for this function is the angle between the 
%   direction of the incoming photons and the direction of the emitted 
%   photoelectrons.
%   This formalism is common to use in the Hard X-Ray regime, where the
%   David Cant Cross-Sections are also used. This is from the original 
%   work of David J. H. Cant [1], see below.
%   [1] David J. H. Cant, Ben F. Spencer, Wendy R. Flavell, Alexander G. Shard. Surf Interface Anal. 2022; 54(4): 442-454. doi:10.1002/sia.7059
%
%   IN:
%   -   hv:             scalar or vector of the incident photon energies [eV]
%   -   element:    	string of the element; e.g. "H", "He", "Si", "In"...
%   -   corelevel:      string or vector of the core-levels to be probed; e.g. ["1s1", "2p1", "2p3", "3d3", "3d5", "5f5', "5f7"]
%   -   omega:          scalar or vector of the angle between the photon momentum vector relative to the photoelectron vector [degree]
%   -   extrapolate:    either 0 or 1; if true, it will extrapolate sigma beyond the conventional range, otherwise not
%   -   plot_results:   if 1, will plot figure summary, otherwise it wont.
%
%   OUT:
%   -   FU:      	    3D matrix of the angular anisotropy factor for unpolarized light. Matrix is of the form: FU[hv,corelevel,omega].

%% Default parameters
if nargin < 3; corelevel = [];  end
if nargin < 4; omega = 90;  end
if nargin < 5; extrapolate = 0;  end
if nargin < 6; plot_results = 0;  end
if isempty(corelevel);      corelevel = []; end
if isempty(omega);          omega = 90; end
if isempty(extrapolate);    extrapolate = 0; end
if isempty(plot_results);   plot_results = 0; end
%% Disable warning back-trace
warning('off', 'backtrace');
%% Validity checks on the input parameters
element     = string(element);
corelevel   = string(corelevel);
%% 1 - Extracting element properties
element_props   = get_mpd_props(element);
ATOM_Z          = element_props.atom_z;
[~, ATOM_CL]    = calc_be(element);
%% 2 - Find the database index of the defined core-levels
% If no core-level is defined, use all available ones
if isempty(corelevel); cl_indx = 1:length(ATOM_CL); 
% Otherwise, parse the input
else
    % - If 1 core-level is entered
    if isscalar(corelevel)
        cl_indx 	= find(strcmpi(ATOM_CL, corelevel), 1);
        if isempty(cl_indx)
            cl_indx = 0; msg = sprintf("Core-level %s not found; NaN values returned.", corelevel); warning(msg); 
        end
    % - If a string array of core-levels is entered
    else
        cl_indx = zeros(size(corelevel));
        for i = 1:length(corelevel)
            ith_corelevel   = corelevel(i);
            idx             = find(ATOM_CL == ith_corelevel);
            % --- If the core-level is not found
            if ~isempty(idx);   cl_indx(i) = idx;
            else;               cl_indx(i) = 0;
                msg = sprintf("Core-level %s not found; NaN values returned.", corelevel(i)); warning(msg); 
            end
        end
    end
end
%% 3 - Extracting core-level labels
cls = "";
for i = 1:length(cl_indx)
    if cl_indx(i) == 0; cls(i) = NaN(1);
    else;               cls(i) = ATOM_CL(cl_indx(i));
    end
end
%% 4 - Calculating Angular Anisotropy Factor
% - Calculating asymmetry parameters
ihv = hv; if size(ihv, 2) > 1; ihv = ihv'; end
ixsect = NaN(size(ihv, 1), length(cl_indx), length(omega));
formalism = "C2022";
for i = 1:length(cl_indx)
    % -- If the binding energy does not exist, return NaN
    if cl_indx(i) == 0; ixsect(:,i,:) = NaN(length(ihv),1,length(omega));
    % -- Otherwise, calculate asymmetry
    else
        Ebe = calc_be(element, ATOM_CL{cl_indx(i)}); 
        if isempty(Ebe) || isnan(Ebe); ixsect(:,i,:) = NaN(length(ihv),1,length(omega));
        else
            % --- Calculating asymmetry parameters
            beta                = calc_xsect_beta(ihv, element, ATOM_CL{cl_indx(i)}, formalism, extrapolate);
            gamma               = calc_xsect_gamma(ihv, element, ATOM_CL{cl_indx(i)}, formalism, extrapolate);
            delta               = calc_xsect_delta(ihv, element, ATOM_CL{cl_indx(i)}, formalism, extrapolate);
            % --- Calculating angular anisotropy
            for j = 1:length(omega)
                ixsect(:,i,j)       = calc_angle_aniso_FU(beta, gamma, delta, omega(j));
            end
        end
    end
end
%% Validity check on the outputs
% -- If no initial corelevel input was made, then remove all NaN entries
if isempty(corelevel)
    % Remove core-levels that are not identified
    NaN_idx                 = ismissing(cls);
    cls(NaN_idx)            = [];
    ixsect(:,NaN_idx,:)       = [];
    % Remove core-levels with full NaN data
    NaN_idx = 0;
    for i = 1:length(omega)
        NaN_idx = NaN_idx + all(isnan(ixsect(:,:,i)), 1);
    end
    NaN_idx                 = logical(NaN_idx / length(omega));
    cls(NaN_idx)            = [];
    ixsect(:,NaN_idx,:)     = [];
% -- Otherwise, preserve the labels that were user-defined
else
    NaN_idx         = find(cl_indx == 0);
    cls(NaN_idx)    = corelevel(NaN_idx);
end
% -- Ensure that the photonionization parameter is consistent with the input hv value
FU = ixsect;
%% Disable warning back-trace
warning('on', 'backtrace');
%% -- Plot for debugging
if plot_results == 1
    nCL         = length(cls);
    colorList   = read_be_core_levels_color(cls);
    % - Creating a figure
    fig = figure(); 
    fig.Position(1) = 100; fig.Position(2) = 100;
    fig.Position(3) = 700; 
    fig.Position(4) = 500;
    % - Creating a tiled axis
    t = tiledlayout(1,1);
    t.TileSpacing = 'compact';
    t.Padding = 'compact';
    nexttile(); hold on; grid on; grid minor;
    % - If a single photon energy is defined, plot versus omega
    if isscalar(hv)
        for i = 1:nCL
            plot(omega, squeeze(FU(1,i,:)),...
                'x-', 'markersize', 5, 'markeredgecolor', colorList{i},...
                'markerfacecolor', colorList{i}, 'color', colorList{i}); 
        end
        xlabel(' Omega [degree] ', 'FontWeight','bold');
        ylabel(' Angular Anisotropy (FU) ', 'FontWeight','bold');
        axis([0, 90, 0, 3.75]);
        text(0.98, 0.91, sprintf("hv = %.0f eV", hv(1)),...
            'FontSize', 8, 'color', 'k', 'Units','normalized', 'HorizontalAlignment','right');
    else
    % - Otherwise, plot versus photon energy
        for i = 1:nCL
            plot(hv, squeeze(FU(:,i,1)),...
                'x-', 'markersize', 5, 'markeredgecolor', colorList{i},...
                'markerfacecolor', colorList{i}, 'color', colorList{i}); 
        end
        xlabel(' Photon Energy [eV] ', 'FontWeight','bold');
        ylabel(' Angular Anisotropy (FU) ', 'FontWeight','bold');
        axis([850, 10150, 0, 3.75]);
        text(0.98, 0.91, sprintf("omega = %.2f deg.", omega(1)),...
            'FontSize', 8, 'color', 'k', 'Units','normalized', 'HorizontalAlignment','right');
    end
    % - Formatting the axis
    legend(cls, 'location', 'eastoutside', 'FontSize', 9);
    text(0.98, 0.98, sprintf("%s (Z=%i)", element, ATOM_Z),...
        'FontSize', 14, 'color', 'k', 'Units','normalized', 'FontWeight', 'bold', 'HorizontalAlignment','right');
    text(0.98, 0.94, sprintf("Cant(2022) - Unpolarized Light (FU)"),...
        'FontSize', 8, 'color', 'k', 'Units','normalized', 'HorizontalAlignment','right');
    ax = gca; ax.YScale = 'linear'; ax.XScale = 'linear';
    yline(0, 'k-', 'LineWidth',1, 'HandleVisibility','off');
end
end