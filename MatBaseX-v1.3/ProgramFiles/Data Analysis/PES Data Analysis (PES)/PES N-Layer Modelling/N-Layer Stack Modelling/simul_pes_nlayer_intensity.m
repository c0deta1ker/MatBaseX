function [lyr_I, lyr_Inorm] = simul_pes_nlayer_intensity(lyr_mat, lyr_ele, lyr_cls, lyr_thick, lyr_density, lyr_exclude, hv, theta, phi, P, formalism_xsect, formalism_imfp, plot_result)
% [lyr_I, lyr_Inorm] = simul_pes_nlayer_intensity(lyr_mat, lyr_ele, lyr_cls, lyr_thick, lyr_density, lyr_exclude, hv, theta, phi, P, formalism_xsect, formalism_imfp, plot_result)
%   This function calculates the total photoelectron intensity originating
%   from N independent layers in a sample. The sample is composed of various
%   materials, each with a user-defined thickness. The stack is made up of N layers,
%   each with a specified material and thickness. The layers are defined using a 
%   top-down approach, starting from the surface and ending with the bulk. 
%   'lyr_mat' is used to define the materials for each layer, and 'lyr_thick' 
%   is used to specify the thickness of each layer. To define the bulk layer, 
%   the final 'lyr_thick' value should be set to 'Inf'. The function also 
%   requires the definition of the core-level being probed and the experimental 
%   geometry. The formalism of the cross-sections and inelastic mean free
%   path (IMFP) can also be defined.
%   --------------------------------------------------------------------
%   The model does the following:
%
%       (1)  Using the input photon energies, the electron kinetic energies
%       are determined so that the attenuation length / inelastic-mean free
%       path (IMFP) of electrons in each layer can be determined. 
%       Using:
%           Ek = Ehv - Ebe ,
%       Ek is the electron kinetic energy; Ehv is the input photon energy;
%       Ebe is the binding energy of the electron, which is determined by
%       in the Photoionisation Energy and Fluorescence Database (PIEFD)
%       whose value depends on the input core-level defined; note, the sample
%       work function is omitted as it leads to only a very small change to 
%       the electron energy and is not well defined for all materials.
%
%       (2) The total intensity of photoelectrons from each layer can be 
%       determined via:
%           I = (n)*(SF) = (n)*(σλ[1+F])
%       where n is the atomic concentration of the element concerned; σ is the 
%       cross section for a specific subshell; λ is the inelastic mean free
%       path (IMFP) for electrons with a given kinetic energy; F is a parameter 
%       describing the angular anisotropy of electrons emitted from a given
%       subshell.
%       (2.1) The atomic concentration (n) can be determined by:
%               n = N_AVOGADRO * DENSITY / MOLECULAR WEIGHT.
%       The density and molecular weight are both contained within the MPD
%       for each material defined.
%       (2.2) The Sensitivity Factor (SF) is determined using the
%       'calc_sf()' function, which takes into account the photoionisation
%       cross-sections & asymmetry parameters, for a given photon energy
%       and experimental geometry. The transmission and surface containation 
%       correction factors are neglected in this model.
%       Thus, the product of n and SF yields the TOTAL intensity I0 of each 
%       layer.
%
%       (3) The Beer-Lambert law is used to model the attenuation of the
%       photoelectron intensity as a function of depth. This model states
%       that the photoelectron intensity decreases exponentially due to 
%       inelastic scattering, with a decay constant equal to the IMFP.
%       Thus, for a bulk, single-layer system, the Beer-Lambert law states:
%           I(z) = I0 * exp(-z / IMFP),
%       which gives the photoelectron intensity, I, that emerges from a
%       depth, z, within the sample. This is applied to each layer in the
%       n-layered stack defined by the user, where I0 is determined from
%       part (2), above. The total integral intensity for each
%       layer in the sample stack then gives the total emitted
%       photoelectron intensity.
%           
%       (4) Once the integral intensites from each layer are determined,
%       the final intensities are expressed in terms of a 'relative
%       contribution'. Here, each layer intensity is normalised by the sum
%       of all the intensities at each photon energy.
%   --------------------------------------------------------------------
%
%   IN:
%   -   lyr_mat:  	        Mx1 cell-vector of the material for each layer in the stack; e.g. "Si", "SiO2", "Al2O3"...
%   -   lyr_ele:            Mx1 cell-vector of strings of the element to be probed; e.g. "H", "He", "Si", "In"...
%   -   lyr_cls:  	        Mx1 cell-vector of strings of the core-level to be probed; e.g. "5s1", "5p1", "5p3", "5d3", "5d5", "5f5', "5f7"...
%   -   lyr_thick:	        Mx1 cell-vector of the thickness of each layer in the stack (nm)
%   -   lyr_density:	    Mx1 cell-vector of the number density of each layer in the stack (atoms/cc)
%   -   lyr_exclude:	    Mx1 cell-vector of whether the layer should be normalised in the normalisation process or not (1 or 0)
%   -   hv:                 scalar or N×1 vector of the incident photon energies [eV]
%   -   theta:              scalar or 1×L vector of the polar angle between the photoelectron vector relative to electric field vector (i.e. at normal emission: LV (p-pol, E//MP) = 0, LH (s-pol, E⊥MP) = 90) [degree]
%   -   phi:                scalar of the azimuthal angle between the photon momentum vector relative to the projection of the photoelectron vector on to the plane perpendicular to the electric field vector (i.e. normal emission = 0) [degree]
%   -   P:                  scalar of degree of polarization, where 1 or 0 is equivalent to full linear polarization, and 0.5 is equivalent to unpolarized light.
%   -   formalism_xsect:    string of the photoionization cross-section formalism to use. Default:"Cant2022" ["Scofield1973","YehLindau1985","Trzhaskovskaya2018","Cant2022"]
%   -   formalism_imfp:     string for imfp calculator formalism. Default:"S2" ["Universal","Optical","TPP2M","TPP2M-avg","S1","S2","S3","S4"]
%   -   plot_results:       if 1, will plot figure summary, otherwise it wont.
%
%   OUT:
%   -   lyr_I:              Mx1 cell-vector of the total photoelectron intensity originating from the M'th layer
%   -   lyr_Inorm:          Mx1 cell-vector of the normalized photoelectron intensity originating from the M'th layer

%% Default parameters
% -- Default Inputs
if nargin < 6;  lyr_exclude = zeros(size(lyr_mat)); end
if nargin < 7;  hv = 5000; end
if nargin < 8;  theta = 0;  end
if nargin < 9;  phi = 0;  end
if nargin < 10;  P = 1;  end
if nargin < 11; formalism_xsect = "Cant2022"; end
if nargin < 12; formalism_imfp = "JTP"; end
if nargin < 13; plot_result = 0; end
if isempty(lyr_exclude); lyr_exclude = zeros(size(lyr_mat)); end
if isempty(hv); hv = 5000; end
if isempty(theta); theta = 0; end
if isempty(phi); phi = 0; end
if isempty(P); P = 0.5; end
if isempty(formalism_xsect); formalism_xsect = "Cant2022"; end
if isempty(formalism_imfp); formalism_imfp = "JTP"; end
if isempty(plot_result); plot_result = 0; end
%% Validity check on inputs
% -- Ensuring the user-defined material input is a cell-array
if ~iscell(lyr_mat);        lyr_mat = cellstr(lyr_mat); end
if ~iscell(lyr_ele);        lyr_ele = cellstr(lyr_ele); end
if ~iscell(lyr_cls);        lyr_cls = cellstr(lyr_cls); end
if ~iscell(lyr_thick);      lyr_thick = num2cell(lyr_thick); end
if ~iscell(lyr_density);    lyr_density = cellstr(lyr_density); end
if ~iscell(lyr_exclude);    lyr_exclude = num2cell(lyr_exclude); end
% -- Setting defining reasonable inputs if empty
if isempty(lyr_density); lyr_density = cell(size(lyr_mat)); end
if isempty(lyr_exclude); lyr_exclude = cell(zeros(size(lyr_mat))); end
% -- Ensuring the formalisms are strings
formalism_xsect     = string(formalism_xsect);
formalism_imfp      = string(formalism_imfp);
%% Defining constants
Nlyrs       = length(lyr_mat);
% -- Verify that the input layer variables are consistent in size
lyr_ele     = lyr_ele(1:Nlyrs);
lyr_cls   	= lyr_cls(1:Nlyrs);
lyr_thick   = lyr_thick(1:Nlyrs);
lyr_density = lyr_density(1:Nlyrs);
lyr_exclude = lyr_exclude(1:Nlyrs);
%% 1    :   Determine the IMFP & maximum intensity I0 for each layer material
% -- Initializing variables
lyr_sf = cell(size(Nlyrs)); lyr_sf_params = cell(size(Nlyrs));
lyr_ele_ratio = cell(size(Nlyrs)); lyr_n = cell(size(Nlyrs));
lyr_I0 = cell(size(Nlyrs)); lyr_imfp = cell(size(Nlyrs));
lyr_be = cell(size(Nlyrs)); lyr_ke = cell(size(Nlyrs));
% -- Extracting parameters for each layer
for i = 1:Nlyrs
    % - Determination of the Sensitivity Factor (SF)
    [lyr_sf{i}, lyr_sf_params{i}] = calc_sf(...
        lyr_mat{i}, lyr_ele{i}, lyr_cls{i},...
        hv, theta, phi, P, formalism_xsect, formalism_imfp, 1);
    % - Determination of the layer number density based on the quantity of the element in the material
    if isempty(lyr_density{i}) || isnan(lyr_density{i}); lyr_density{i} = mpd_calc_number_density(lyr_mat{i}); end
    lyr_ele_ratio{i} = calc_elemental_ratio(lyr_mat{i}, lyr_ele{i});
    lyr_n{i}         = lyr_ele_ratio{i} .* lyr_density{i};
    % - Determine the value of I0
    lyr_I0{i}   = lyr_n{i} .* lyr_sf{i};
    % - Determine of the IMFP at all kinetic energy for each layer material
    lyr_be{i}           = calc_be(lyr_ele{i}, lyr_cls{i}); 
    if isempty(lyr_be) || isnan(isempty(lyr_be)); fprintf('Eb not found in any database, defaulting to 0 eV.\n'); lyr_be{i} = 0; end
    lyr_ke{i}       = hv - lyr_be{i};
    lyr_imfp{i}     = calc_imfp(lyr_ke{i}, formalism_imfp, lyr_mat{i});
    lyr_imfp{i}     = 0.1 .* lyr_imfp{i};  % Convert the IMFP into nm
end
%% 2    :   Use Beer-Lambert law to determine the total photoelectron intensity for each layer
% Defining the Beer-Lambert Law of Attenuation for each layer
Theta = deg2rad(theta);
lyr_I = cell(size(Nlyrs)); lyr_Inorm = cell(size(Nlyrs));
% -- For one layer (Bulk)
if Nlyrs == 1;  lyr_I{1} = lyr_I0{1} .* exp(-lyr_thick{1} ./ (lyr_imfp{1} .* cos(Theta)));
% -- For multi-layer samples
else
    for i = 1:Nlyrs
        % -- For the uppermost layer, there is only attenuation through 1 layer
        if i == 1; lyr_I{i} = lyr_I0{i} .* (1 - exp(-lyr_thick{i} ./ (lyr_imfp{i} .* cos(Theta))));
        % -- For the lowermost bulk layer, there is attenuation through all layers above it
        elseif i == Nlyrs
            lyr_I{i} = lyr_I0{i};
            for j = 1:Nlyrs - 1; lyr_I{i} = lyr_I{i} .* (exp(-lyr_thick{j} ./ (lyr_imfp{j} .* cos(Theta)))); end
        % -- For intermediate layers
        else
            lyr_I{i} = lyr_I0{i} .* (1 - exp(-lyr_thick{i} ./ (lyr_imfp{i} .* cos(Theta))));
            for j = 1:i-1; lyr_I{i} = lyr_I{i} .* (exp(-lyr_thick{j} ./ (lyr_imfp{j} .* cos(Theta)))); end
        end
    end
end
%% 3    :   Layer intensity normalization
lyr_norm = zeros(size(lyr_I{1}));
for i = 1:Nlyrs; if lyr_exclude{i} == 0; lyr_norm =  lyr_norm + lyr_I{i}; end; end
for i = 1:Nlyrs; lyr_Inorm{i} = lyr_I{i} ./ lyr_norm; end
for i = 1:Nlyrs; if lyr_exclude{i} == 1; lyr_Inorm{i} = 0.*lyr_Inorm{i}; end; end
%% -- Validity check on outputs
% -- Ensure consistent sizes
for i = 1:Nlyrs; if isrow(lyr_I{i}); lyr_I{i} = lyr_I{i}'; end; end
for i = 1:Nlyrs; if isrow(lyr_Inorm{i}); lyr_Inorm{i} = lyr_Inorm{i}'; end; end
% -- Ensure real numbers
for i = 1:Nlyrs; lyr_I{i} = real(lyr_I{i}); end
for i = 1:Nlyrs; lyr_Inorm{i} = real(lyr_Inorm{i}); end
%% -- Plot for debugging
if plot_result == 1
    % - Initializing variables
    lwidth = 2;
    colorList = read_pes_nlayer_color(Nlyrs);
    % - Creating a figure
    fig = figure(); 
    fig.Position(1) = 100; fig.Position(2) = 100;
    fig.Position(3) = 750; 
    fig.Position(4) = 500;
    % - Creating a tiled axis
    t = tiledlayout(1,1);
    t.TileSpacing = 'compact';
    t.Padding = 'compact';
    % - Plot of data
    nexttile(); hold on; grid on; grid minor;
    % - If a single photon energy is defined
    if isscalar(hv)
        % - Plot versus theta
        if isscalar(phi)
            for i = 1:Nlyrs; plot(theta, lyr_Inorm{i}, '.-', 'linewidth', lwidth, 'color', colorList{i}, 'markerfacecolor', colorList{i}); end
            xlabel(' Theta [degree] ', 'FontWeight','bold');
            ylabel(' Normalized Intensity ', 'FontWeight','bold');
            axis([0, 90, 0, 1.10]);
            text(0.02, 0.98, sprintf("hv = %.0f eV, phi = %.0f deg.", hv(1), phi(1)),...
                'FontSize', 10, 'color', 'k', 'Units','normalized', 'HorizontalAlignment','left');
        % - Plot versus phi
        else
            for i = 1:Nlyrs; plot(phi, lyr_Inorm{i}, '.-', 'linewidth', lwidth, 'color', colorList{i}, 'markerfacecolor', colorList{i}); end
            xlabel(' Phi [degree] ', 'FontWeight','bold');
            ylabel(' Normalized Intensity ', 'FontWeight','bold');
            axis([0, 180, 0, 1.10]);
            text(0.02, 0.98, sprintf("hv = %.0f eV, theta = %.0f deg.", hv(1), theta(1)),...
                'FontSize', 10, 'color', 'k', 'Units','normalized', 'HorizontalAlignment','left');
        end
    else
    % - Otherwise, plot versus photon energy
        for i = 1:Nlyrs; plot(hv, lyr_Inorm{i}, '.-', 'linewidth', lwidth, 'color', colorList{i}, 'markerfacecolor', colorList{i}); end
        xlabel(' Photon Energy [eV] ', 'FontWeight','bold');
        ylabel(' Normalized Intensity ', 'FontWeight','bold');
        axis([0, 11000, 0, 1.10]);
        text(0.02, 0.98, sprintf("theta = %.0f deg., phi = %.0f deg.", theta(1), phi(1)),...
            'FontSize', 10, 'color', 'k', 'Units','normalized', 'HorizontalAlignment','left');
    end
    % - Formatting the axis
    for i = 1:Nlyrs
        if i == Nlyrs; lgnd_txt{i} = sprintf("%s-%s(%s)-%.0f", lyr_mat{i}, lyr_ele{i}, lyr_cls{i}, lyr_thick{i});
        else; lgnd_txt{i} = sprintf("%s-%s(%s)-%.1fnm", lyr_mat{i}, lyr_ele{i}, lyr_cls{i}, lyr_thick{i});
        end
    end
    legend(lgnd_txt, 'location', 'eastoutside', 'FontSize', 9);
    yline(0, 'k-', 'LineWidth',1, 'HandleVisibility','off');
end
end