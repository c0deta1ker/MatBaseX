function Xi = calc_equiv_homo_atmic_frac(Ii, Si)
% Xi = calc_equiv_homo_atmic_frac(Ii, Si)
%   Calculates the equivalent homogeneous composition of a material via
%   quantitative XPS measurements. The assumption is that the sample is 
%   homogeneous and single phase within the XPS sampling depth. For each
%   element, select a peak and divide the area of that peak, Ii, by the
%   sensitivity factor, Si, to obtain a normaized peak area, Ii/Si. The
%   equivalent homogenous atomic fraction, Xi, of each element is simply
%   that elements normalized peak area divided by the sum of all normalized
%   peak areas. See referenece below for more information.
%   [1] A. G. Shard, Practical guides for x-ray photoelectron spectroscopy: Quantitative XPS (2020)
%
%   IN:
%   -   Ii:     N×1 column vector of the total peak area for each element in the XPS spectrum.
%   -   Si:     N×1 column vector of the corresponding sensitivity factor for each element.
%
%   OUT:
%   -   Xi:     N×1 column vector of the atomic fraction of each element [atm. %]

%% -- Validity check on inputs
% if size(Ii, 2) >1; Ii = Ii'; end
% if size(Si, 2) >1; Si = Si'; end
%% 1 : Determination of the equivalent homogenous atomic fraction
Xi = 100 .* (Ii ./ Si) ./ sum(Ii ./ Si);
%% -- Validity check on outputs
% if size(Xi, 2) >1; Xi = Xi'; end
end