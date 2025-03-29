function [imfp, dimfp] = calc_imfp_optical(ke_dat, element, extrapolate)
% [imfp, dimfp] = calc_imfp_optical(ke_dat, element, extrapolate)
%   Function that determines the mean and uncertainty of the experimental values
%   of the electron IMFP taken from optical / experimental data. The data
%   used is from the NIST Electron Inelastic-Mean-Free-Path Database [1].
%   Any NaN output values means no experimental data exists for the input
%   kinetic energy, otherwise, the output is the mean and range of the
%   experimental values.
%   [1] NIST Electron Inelastic-Mean-Free-Path Database: http://dx.doi.org/10.18434/T48C78
%
%   IN:
%   -   ke_dat:  	scalar or vector of the input electron kinetic energy (for PES; KE = BE - PHI) [eV]
%   -   element:	char/string of the element; e.g. "H", "He", "Si", "In"...
%   -   extrapolate:    either 0 or 1; if true, it will extrapolate imfp beyond the measured range, otherwise not
%
%   OUT:
%   -   imfp:       scalar or vector of the electron IMFP values [Angstrom]
%   -   dimfp:      scalar or vector of the IMFP uncertainties [Angstrom]

%% Default parameters
if nargin < 2; element = []; end
if nargin < 3; extrapolate = 0;  end
if isempty(element); element = []; end
if isempty(extrapolate); extrapolate = []; end
%% Validity checks on the input parameters
element     = string(element);
%% 1 - Loading the MATLAB data structure
IMFPD_NIST1999 = load('IMFPD_NIST1999.mat'); IMFPD_NIST1999 = IMFPD_NIST1999.IMFPD_NIST1999;
ATOM_SYMB   = IMFPD_NIST1999.ATOM_SYMB;
%% 2 - Find the database index of the defined element
% - Extracting element database index
ele_indx 	= find(strcmpi(ATOM_SYMB, element), 1);
if isempty(ele_indx)
    warning('off', 'backtrace');
    msg = 'Element could not be identified. Only use atomic-symbols for elements 1 - 92; H, He, Li, Be..., Pa, U'; warning(msg); 
    imfp = NaN(size(ke_dat));
    dimfp = NaN(size(ke_dat));
    warning('on', 'backtrace');
    return
end
% - Extracting relevant tables
data  	= IMFPD_NIST1999.Data{ele_indx};
ek0 	= [];
imfp0   = [];
for i = 1:IMFPD_NIST1999.Length(ele_indx)
    ek0(:,i)	= table2array(data(:,2*i-1));
    imfp0(:,i)	= table2array(data(:,2*i));
end
%% 3 - Calculate the average and variance of the IMFP values for all datasets
imfp = []; dimfp = [];
% - Filing through all the kinetic energies to be determined
for i = 1:length(ke_dat)
    % -- Extrapolate the data to the kinetic energy values
    ke_i    = ke_dat(i);
    imfp_i  = [];
    for j = 1:size(ek0, 2)
        if extrapolate == 1;        imfp_i(j)  = interp1(ek0(:,j), imfp0(:,j), ke_i, 'linear', 'extrap');
        elseif extrapolate == 0;    imfp_i(j)  = interp1(ek0(:,j), imfp0(:,j), ke_i, 'linear', NaN);
        end
    end
    % -- Extract the value of the closest kinetic energy from the optical data
    imfp_i(isnan(imfp_i)) = [];
    if isempty(imfp_i)
        imfp(i)     = NaN;
        dimfp(i)    = NaN;
    else
        imfp(i)     = mean(imfp_i);
        dimfp(i)    = 0.5*range(imfp_i);
    end
end
%% -- Validity check on outputs
% -- Ensure that the IMFP is consistent with input size
if isrow(ke_dat); if size(imfp, 2) ~= length(ke_dat); imfp = imfp'; end
elseif iscolumn(ke_dat); if size(imfp, 1) ~= length(ke_dat); imfp = imfp'; end
end
% -- Ensure that the dIMFP is consistent with input size
if isrow(ke_dat); if size(dimfp, 2) ~= length(ke_dat); dimfp = dimfp'; end
elseif iscolumn(ke_dat); if size(dimfp, 1) ~= length(ke_dat); dimfp = dimfp'; end
end

end