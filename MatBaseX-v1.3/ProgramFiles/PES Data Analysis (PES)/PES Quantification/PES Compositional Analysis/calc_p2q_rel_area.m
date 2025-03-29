function Apq = calc_p2q_rel_area(Ip, Ip_inf, Iq, Iq_inf)
% Apq = calc_p2q_rel_area(Ip, Ip_inf, Iq, Iq_inf)
%   Calculates the relative area of P to Q. The assumption is that the sample 
%   is homogeneous and single phase within the XPS sampling depth. The
%   element P & Q has a peak area of Ip & Iq respectively. The sensitivity
%   factor for each element is Ip_inf & Iq_inf, which is used to normalise
%   the peak areas for quantification. The sensitivity factors correspond to the 
%   intensities that one would measure from pure specimens of the element, 
%   given exactly the same instrumental conditions and primary beam. The result 
%   is Apq, the relative composition of the elements in the material. 
%   See referenece below for more information.
%   [1] A. G. Shard, Practical guides for x-ray photoelectron spectroscopy: Quantitative XPS (2020)
%
%   IN:
%   -   Ip:         N×1 column vector of the total peak area for element P in the XPS spectrum.
%   -   Ip_inf:     scalar or N×1 column vector of the corresponding sensitivity factor for element P.
%   -   Iq:         N×1 column vector of the total peak area for element Q in the XPS spectrum.
%   -   Iq_inf:     scalar or N×1 column vector of the corresponding sensitivity factor for element Q.
%
%   OUT:
%   -   Apq:        N×1 column vector of the ratio of the relative area of P to Q.

%% -- Validity check on inputs
if size(Ip, 2) >1;     Ip = Ip'; end
if size(Ip_inf, 2) >1; Ip_inf = Ip_inf'; end
if size(Iq, 2) >1;     Iq = Iq'; end
if size(Iq_inf, 2) >1; Iq_inf = Iq_inf'; end
%% 1 : Determination of the relative area of P to Q
Apq = (Ip ./ Ip_inf) ./ (Iq ./ Iq_inf);
%% -- Validity check on outputs
if size(Apq, 2) >1; Apq = Apq'; end
end