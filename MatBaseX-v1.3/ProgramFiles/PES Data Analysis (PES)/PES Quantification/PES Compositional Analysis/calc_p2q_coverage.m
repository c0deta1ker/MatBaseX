function Cpq = calc_p2q_coverage(Apq, lambda_p, a_p, alpha)
% Cpq = calc_p2q_coverage(Apq, lambda_p, a_p, alpha)
%   Calculates the coverage of P on Q. The assumption is that the sample 
%   is homogeneous, with a small covereage of P on Q within the XPS sampling 
%   depth. The relative area of elements P to Q is given by Apq. The
%   IMFP (lambda_p) and lattice constant (a_p) of element P should be known.
%   The photoelectron take-off angle relative to the surface normal is
%   given by alpha. The result is Cpq, the relative coverage of the elements in the material. 
%   See referenece below for more information.
%   [1] A. G. Shard, Practical guides for x-ray photoelectron spectroscopy: Quantitative XPS (2020)
%
%   IN:
%   -   Apq:        N×1 column vector of the relative area of P to Q from the XPS spectrum.
%   -   lambda_p:   scalar or 1×M row vector of the attenuation length of electrons in the overlayer [nm or Angstrom].
%   -   a_p:        scalar of the lattice constant of the overlayer [nm or Angstrom].
%   -   alpha:      scalar or 1×M row vector of the photoelectron take-off angle relative to the surface normal (i.e. normal emission = 0) [degrees]
%
%   OUT:
%   -   Cpq:        N×M column vector of the coverage of P on Q.

%% -- Validity check on inputs
if size(Apq, 2) >1;         Apq = Apq'; end
if size(lambda_p, 1) >1;    lambda_p = lambda_p'; end
if size(alpha, 1) >1;       alpha = alpha'; end
%% 1 : Determination of the coverage of P on Q
Cpq     = Apq .* (lambda_p./a_p) .* cos(deg2rad(alpha));

end