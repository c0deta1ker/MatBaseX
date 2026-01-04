function [f1, f2] = calc_xasf(hv, formula, formalism, extrapolate, plot_results)
% [f1, f2] = calc_xasf(hv, formula, formalism, extrapolate, plot_results)
%   This function calculates the X-ray atomic scattering factors f1 and f2 
%   for a specified photon energy (hv) and compound formula. The calculation is based on 
%   interpolation from a given formalism database. If the input material 
%   is an element, it interpolates directly, however, if it is a compound,
%   the function computes the linear combination of the ratios scaled by 
%   the element scattering factors.
%
%   IN:
%   -   hv:             scalar or vector of the incident photon energies [eV]
%   -   formula:        char/string of the material; e.g. "H", "Si", "SiO2", "Al2O3"...
%   -   formalism:      string of the formalism to use. Default:"NIST2005" ["Henke1993", "NIST2005"]
%   -   extrapolate:    either 0 or 1; if true, it will extrapolate sigma beyond the conventional range, otherwise not
%   -   plot_results:   if 1, will plot figure summary, otherwise it wont.
%
%   OUT:
%   -   f1:             scalar or vector of the real part of atomic scattering factor (coherent scattering) [e/atom]
%   -   f2:             scalar or vector of the imaginary part of atomic scattering factor (absorption) [e/atom]
%
%       [1] Henke B.L., Gullikson E.M., Davis J.C. X-Ray Interactions: Photoabsorption, Scattering, Transmission, and Reflection at E = 50-30,000 eV, Z = 1-92, Atomic Data and Nuclear Data Tables, 54 (2), 181-342 (1993)
%       [2] https://henke.lbl.gov/optical_constants/
%       [3] https://gisaxs.com/index.php/Refractive_index
%       [4] https://physics.nist.gov/PhysRefData/FFast/html/form.html

%% Default parameters
if nargin < 3; formalism = "NIST2005";  end
if nargin < 4; extrapolate = 0;  end
if nargin < 5; plot_results = 0;  end
if isempty(formalism); formalism = "NIST2005"; end
if isempty(extrapolate); extrapolate = 0; end
if isempty(plot_results); plot_results = 0; end
%% Validity checks on the input parameters
formula     = string(formula);
formalism   = string(formalism);
ele_indx    = calc_average_z_number(formula);
%% 1 - Defining all variants of EDGE formalisms
formalism_Henke1993     = [...
    "Henke(1993)", "(1993)Henke", "Henke1993", "1993Henke",...
    "H(1993)", "(1993)H", "H1993", "H1993",...
    "Henke", "1993"];
formalism_NIST2005     = [...
    "NIST(2005)", "(2005)NIST", "NIST2005", "2005NIST",...
    "NIST", "2005"];
%% 1 - Calculating the X-ray atomic scattering factors f1 and f2
vformula     = parse_chemical_formula(formula);
f1 = 0; f2 = 0;
for i = 1:length(vformula)
    % -- Henke1993 formalism
    if ~isempty(find(strcmpi(formalism_Henke1993, formalism),1))
        [f1q{i}, f2q{i}]  = calc_xasf_henke1993(hv, vformula(i).element, extrapolate);
    % -- NIST2005 formalism
    elseif ~isempty(find(strcmpi(formalism_NIST2005, formalism),1))
        [f1q{i}, f2q{i}]  = calc_xasf_nist2005(hv, vformula(i).element, extrapolate);
    else; msg = 'Formalism not found. One of the following must be used: "Henke1993" or "NIST2005".'; error(msg);
    end
    % xq{i} = vformula(i).ratio;
    xq{i} = vformula(i).quantity;
    f1 = f1 + xq{i}*f1q{i};
    f2 = f2 + xq{i}*f2q{i};
end
%% Validity check on the outputs
% -- Ensure that the output values are consistent with the input hv value
if isrow(hv); if size(f1, 2) ~= length(hv); f1 = f1'; end
elseif iscolumn(hv); if size(f1, 1) ~= length(hv); f1 = f1'; end
end
if isrow(hv); if size(f2, 2) ~= length(hv); f2 = f2'; end
elseif iscolumn(hv); if size(f2, 1) ~= length(hv); f2 = f2'; end
end
%% -- Plotting the results
if plot_results == 1
    formalismList   = read_formalisms('xasf');
    hv_data = logspace(1,6,1e3);
    f1_data = 0; f2_data = 0;
    for i = 1:length(vformula)
        if ~isempty(find(strcmpi(formalism_Henke1993, formalism),1))
            formalism = formalismList{2};
            [f1q{i}, f2q{i}]  = calc_xasf_henke1993(hv_data, vformula(i).element, 0);
        elseif ~isempty(find(strcmpi(formalism_NIST2005, formalism),1))
            formalism = formalismList{1};
            [f1q{i}, f2q{i}]  = calc_xasf_nist2005(hv_data, vformula(i).element, 0);
        end
        xq{i} = vformula(i).quantity;
        f1_data = f1_data + xq{i}*f1q{i};
        f2_data = f2_data + xq{i}*f2q{i};
    end
    plt_result_xasf(formula, formalism, hv, f1, f2, hv_data, f1_data, f2_data);
end
end