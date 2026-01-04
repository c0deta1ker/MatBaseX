function Fadj = calc_xsect_angle_aniso_Fadj(hv, element, corelevel, theta, phi, extrapolate, plot_results)
% Fadj = calc_xsect_angle_aniso_Fadj(hv, element, corelevel, omega, extrapolate, plot_results)
%  VALID FOR THE SOFT X-RAY ENERGY RANGE : 10 - 1500 eV
%   This function computes the angular anisotropy factor, Fadj, for 
%   unpolarized light that is incident on the sample. Fadj depends on the 
%   experimental geometry, which is defined by spherical coordinates. 
%   The only angle needed for this function is the angle between the 
%   direction of the incoming photons and the direction of the emitted 
%   photoelectrons. First, the adjusted asymmetry factor for solid
%   materials is determined via the equation:
%       β* = β (a - bZ + cZ^2), where a = 0.781; b = 0.00514; c = 0.000031;
%   This is then used to determine the angular anisotropy via the equation:
%       L = 1 + 1/2 β* (3/2 cos^2(ω) - 1)
%   This formalism is common to use in the Soft X-Ray regime, where the
%   Yeh-Lindau Cross-Sections are also used. See reference below for more
%   information.
%   [1] Angle Resoled XPS, Thermo Scientific, Application Note: 31014
%
%   IN:
%   -   hv:             scalar or vector of the incident photon energies [eV]
%   -   element:    	string of the element; e.g. "H", "He", "Si", "In"...
%   -   corelevel:      string or vector of the core-levels to be probed; e.g. ["1s1", "2p1", "2p3", "3d3", "3d5", "5f5', "5f7"]
%   -   theta:          scalar or vector of the polar emission angle of the photoelectrons relative to the surface normal (i.e. at normal emission = 0) [degree]
%   -   phi:            scalar or vector of the azimuthal angle between the photon momentum vector relative to the projection of the photoelectron vector on to the plane perpendicular to the electric field vector (i.e. normal emission = 0) [degree]
%   -   extrapolate:    either 0 or 1; if true, it will extrapolate sigma beyond the conventional range, otherwise not
%   -   plot_results:   if 1, will plot figure summary, otherwise it wont.
%
%   OUT:
%   -   Fadj:      	    4D matrix of the angular anisotropy factor for unpolarized light. Matrix is of the form: Fadj[hv,corelevel,theta,phi].

%% Default parameters
if nargin < 3; corelevel = [];  end
if nargin < 4; theta = 0;  end
if nargin < 5; phi = 0;  end
if nargin < 6; extrapolate = 0;  end
if nargin < 7; plot_results = 0;  end
if isempty(corelevel);      corelevel = []; end
if isempty(theta);          theta = 0; end
if isempty(extrapolate);    extrapolate = 0; end
if isempty(plot_results);   plot_results = 0; end
%% Disable warning back-trace
warning('off', 'backtrace');
%% Validity checks on the input parameters
hv          = sort(unique(hv)); 
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
formalism = "YL1985";
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
            % --- Calculating angular anisotropy
            for j = 1:length(theta)
                for k = 1:length(phi)
                    ixsect(:,i,j,k)     = calc_angle_aniso_Fadj(beta, theta(j), phi, ATOM_Z);
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
    ixsect(:,NaN_idx,:)       = [];
    % Remove core-levels with Fadjll NaN data
    NaN_idx = 0;
    for i = 1:length(theta)
        NaN_idx = NaN_idx + all(isnan(ixsect(:,:,i)), 1);
    end
    NaN_idx                 = logical(NaN_idx / length(theta));
    cls(NaN_idx)            = [];
    ixsect(:,NaN_idx,:)     = [];
% -- Otherwise, preserve the labels that were user-defined
else
    NaN_idx         = find(cl_indx == 0);
    cls(NaN_idx)    = corelevel(NaN_idx);
end
% -- Ensure that the photonionization parameter is consistent with the input hv value
Fadj = ixsect;
%% Disable warning back-trace
warning('on', 'backtrace');
%% -- Plot for debugging
if plot_results == 1
    formalismList   = read_formalisms('xsect-angleaniso');
    formalism     = formalismList{4}; 
    plt_result_xsect_angle_aniso(element, formalism, hv, cls, theta, phi, [], Fadj);
end
end