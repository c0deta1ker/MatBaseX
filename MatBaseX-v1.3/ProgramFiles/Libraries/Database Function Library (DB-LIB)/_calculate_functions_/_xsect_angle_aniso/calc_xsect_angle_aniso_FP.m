function FP = calc_xsect_angle_aniso_FP(hv, element, corelevel, theta, phi, P, extrapolate, plot_results)
% FP = calc_xsect_angle_aniso_FP(hv, element, corelevel, theta, phi, P, extrapolate, plot_results)
%  VALID FOR THE HARD X-RAY ENERGY RANGE : 1000 - 10000 eV
%   This function computes the angular anisotropy factor, FP, for 
%   partially polarized light that is incident on the sample. FP depends on the 
%   experimental geometry, which is specified by two angles: theta and phi. 
%   Theta is the angle between the emitted photoelectrons and the electric field 
%   vector, and phi is the angle between the direction of the incident photons 
%   and the direction of the emitted photoelectrons. The parameter P
%   determines the degree of polarization; a value of 0.5 indicates
%   unpolarised light, and 0 or 1 indicated linear polarised light.
%   This formalism is common to use in the Hard X-Ray regime, where the
%   David Cant Cross-Sections are also used. This is from the original 
%   work of David J. H. Cant [1], see below.
%   [1] David J. H. Cant, Ben F. Spencer, Wendy R. Flavell, Alexander G. Shard. Surf Interface Anal. 2022; 54(4): 442-454. doi:10.1002/sia.7059
%
%   IN:
%   -   hv:             scalar or vector of the incident photon energies [eV]
%   -   element:    	string of the element; e.g. "H", "He", "Si", "In"...
%   -   corelevel:      string or vector of the core-levels to be probed; e.g. ["1s1", "2p1", "2p3", "3d3", "3d5", "5f5', "5f7"]
%   -   theta:          scalar or vector of the polar angle between the photoelectron vector relative to electric field vector (i.e. at normal emission: LV (p-pol, E//MP) = 0, LH (s-pol, E⊥MP) = 90) [degree]
%   -   phi:            scalar or vector of the azimuthal angle between the photon momentum vector relative to the projection of the photoelectron vector on to the plane perpendicular to the electric field vector (i.e. normal emission = 0) [degree]
%   -   P:              scalar of degree of polarization, where 1 or 0 is equivalent to full linear polarization, and 0.5 is equivalent to unpolarized light.
%   -   extrapolate:    either 0 or 1; if true, it will extrapolate sigma beyond the conventional range, otherwise not
%   -   plot_results:   if 1, will plot figure summary, otherwise it wont.
%
%   OUT:
%   -   FP:      	    4D matrix of the angular anisotropy factor for partially polarized light. Matrix is of the form: FU[hv,corelevel,theta,phi].

%% Default parameters
if nargin < 3; corelevel = [];  end
if nargin < 4; theta = 0;  end
if nargin < 5; phi = 0;  end
if nargin < 6; P = 1;  end
if nargin < 7; extrapolate = 0;  end
if nargin < 8; plot_results = 0;  end
if isempty(corelevel); corelevel = []; end
if isempty(theta); theta = 0; end
if isempty(phi); phi = 0; end
if isempty(P); P = 1; end
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
ixsect = NaN(size(ihv, 1), length(cl_indx), length(theta), length(phi));
formalism = "C2022";
for i = 1:length(cl_indx)
    % -- If the binding energy does not exist, return NaN
    if cl_indx(i) == 0; ixsect(:,i,:,:) = NaN(length(ihv),1,length(theta),length(phi));
    % -- Otherwise, calculate asymmetry
    else
        Ebe = calc_be(element, ATOM_CL{cl_indx(i)}); 
        if isempty(Ebe) || isnan(Ebe); ixsect(:,i,:,:) = NaN(length(ihv),1,length(theta),length(phi));
        else
            % --- Calculating asymmetry parameters
            beta                = calc_xsect_beta(ihv, element, ATOM_CL{cl_indx(i)}, formalism, extrapolate);
            gamma               = calc_xsect_gamma(ihv, element, ATOM_CL{cl_indx(i)}, formalism, extrapolate);
            delta               = calc_xsect_delta(ihv, element, ATOM_CL{cl_indx(i)}, formalism, extrapolate);
            % --- Calculating angular anisotropy
            for j = 1:length(theta)
                for k = 1:length(phi)
                    ixsect(:,i,j,k)     = calc_angle_aniso_FP(beta, gamma, delta, theta(j), phi(k), P);
                end
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
    ixsect(:,NaN_idx,:,:)   = [];
    % Remove core-levels with full NaN data
    NaN_idx = 0;
    for i = 1:length(theta)
        for j = 1:length(phi)
            NaN_idx = NaN_idx + all(isnan(ixsect(:,:,i,j)), 1);
        end
    end
    NaN_idx                 = logical(NaN_idx / (length(theta)*length(phi)));
    cls(NaN_idx)            = [];
    ixsect(:,NaN_idx,:,:)   = [];
% -- Otherwise, preserve the labels that were user-defined
else
    NaN_idx         = find(cl_indx == 0);
    cls(NaN_idx)    = corelevel(NaN_idx);
end
% -- Ensure that the photonionization parameter is consistent with the input hv value
FP = ixsect;
%% Disable warning back-trace
warning('on', 'backtrace');
%% -- Plot for debugging
if plot_results == 1
    formalismList   = read_formalisms('xsect-angleaniso');
    formalism       = formalismList{1}; 
    plt_result_xsect_angle_aniso(element, formalism, hv, cls, theta, phi, P, FP);
end
end