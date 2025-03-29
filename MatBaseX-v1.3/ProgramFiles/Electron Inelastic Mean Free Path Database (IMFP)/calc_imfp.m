function imfp = calc_imfp(ke_dat, formalism, args)
% imfp = calc_imfp(ke_dat, formalism, args)
%   This is a general function that calculates the electron inelastic mean 
%   free path (IMFP) from different sources in the literature. The 
%   Universal ([1] Seah1979), TPP-2M ([2-4] Tanuma1994), S1 & S2 
%   ([5] Seah2011), S3 & S4 ([6] Seah2012) and JTP ([7] JTP2023) formalisms 
%   are available. The user can define a scalar or vector of kinetic energies for the input.
%   If the args is a string of an element / material, it will look it up 
%   the relevant materials parameters in the Material Properties Database 
%   (MPD). Otherwise, the args can be manually inserted as
%   defined below. Note, the IMFP is the average distance that an electron 
%   with a given energy travels between successive inelastic collisions.
%
%   IN:
%   -   ke_dat:  	N×1 column vector of the input electron kinetic energy (for PES; KE = BE - HV) [eV]
%   -   formalism:  string for imfp calculator formalism. Default:"JTP" ["Universal","TPP2M","TPP2M-avg","Optical","S1","S2","S3","S3O","S4","JTP"]
%   -   args:       string or vector of scalars defining the arguments of the chosen formalism;
%                       (1) string of element / material whose parameters are found in materials database; e.g. "Si", "SiO2", "Al2O3"...
%                       (2) vector with manual entry of material parameters:
%                            -> Optical:        no args, database look-up from NIST 1999.
%                            -> Universal:      no args, material independent.
%                            -> TPP2M-avg:      no args, material independent.
%                            -> TPP2M:  4x1     [density(g/cc),atomicweight(amu),egap(eV),valency(valence electrons per atom)]
%                            -> S1:     5x1     [density(g/cc),atomicweight(amu),egap(eV),Z(atomic mass number or average for compounds),stoichiometry]
%                            -> S2:     1x1     [Z(atomic mass number or average for compounds)]
%                            -> S3:     4x1     [density(g/cc),atomicweight(amu),Z(atomic mass number or average for compounds),stoichiometry]
%                            -> S3-organic:     no args, material independent.
%                            -> S4:     1x1     [Z(atomic mass number or average for compounds)]
%                            -> JTP:    4x1     [density(g/cc),atomicweight(amu),egap(eV),valency(valence electrons per atom)]
%
%   OUT:
%   -   imfp:       N×1 column vector of the electron IMFP values [Angstrom]
%
%   SEE REFERENCES:
%       [1] M. P. Seah, Quantitative electron spectroscopy of surfaces A Standard Data Base for Electron Inelastic Mean Free Paths in Solids (1979)
%       [2] S. Tanuma, Calculations of Electron Inelastic Mean Free Paths. V. Data for 14 Organic Compounds over the 50-2000 eV Range (1994)
%       [3] S. Tanuma, Calculation of electron inelastic mean free paths (IMFPs) VII. Reliability of the TPP-2M IMFP predictive equation (2003)
%       [4] S. Tanuma, Calculations of electron inelasticmean free paths. IX. Data for 41 elemental solids over the 50 eV to 30 keV range (2011)
%       [5] M. P. Seah, An accurate and simple universal curve for the energy-dependent electron inelastic mean free path (2011)
%       [6] M. P. Seah, Simple universal curve for the energy‐dependent electron attenuation length (2012)
%       [7] Jablonski A, Tanuma S, Powell CJ. Surf Interface Anal. 2023; 55(8): 609-637. doi:10.1002/sia.7217
%
%   EXAMPLE #1: Calculatng TPP2M IMFP for Silicon at 500 eV elecron energy.
%   Using the Materials Properties Database:            imfp = calc_imfp(500, "tpp2m", "Si")
%   If the material parameters are not known, then:     imfp = calc_imfp(500, "tpp2m", [2.33,28.0850,1.107,4])

%% Default parameters
% - Default formalism
if nargin < 3; args = []; end
if nargin < 2; formalism = "JTP"; end
if isempty(formalism); formalism = "JTP"; end
if isempty(args); args = []; end
%% - Validity check on the inputs
formalism = string(formalism);
if ischar(args); args = string(args); end
%% 1 - Defining all variants of IMFP formalisms
formalism_jtp     = [...
    "JTP(2023)", "(2023)JTP", "JTP2023", "2023JTP",...
    "Jablonski(2023)", "(2023)Jablonski", "Jablonski2023", "2023Jablonski",...
    "JTP", "Jablonski"];
formalism_s4     = [...
    "S4(2012)", "(2012)S4", "S42012", "2012S4",...
    "S4"];
formalism_s3org  = [...
    "S3O(2012)", "(2012)S3O", "S3O2012", "2012S3O",...
    "S3O", "S3-organic", "S3-org", "S3-o"];
formalism_s3     = [...
    "S3(2012)", "(2012)S3", "S32012", "2012S3",...
    "S3"];
formalism_s2     = [...
    "S2(2011)", "(2011)S2", "S22011", "2011S2",...
    "S2"];
formalism_s1     = [...
    "S1(2011)", "(2011)S1", "S12011", "2011S1",...
    "S1"];
formalism_nist     = [...
    "NIST(1999)", "(1999)NIST", "NIST1999", "1999NIST",...
    "Optical(1999)", "(1999)Optical", "Optical1999", "1999Optical",...
    "Optical", "Opt", "NIST"];
formalism_tpp2mavg     = [...
    "TPP2M-avg(1994)", "(1994)TPP2M-avg", "TPP2M-avg1994", "1994TPP2M-avg",...
    "Tanuma(1994)-avg", "(1994)Tanuma-avg", "Tanuma1994-avg", "1994Tanuma-avg", "Tanuma1994-avg",...
    "TPP2M-avg", "TPP-2M-avg", "TPP2-avg"];
formalism_tpp2m     = [...
    "TPP2M(1994)", "(1994)TPP2M", "TPP2M1994", "1994TPP2M",...
    "Tanuma(1994)", "(1994)Tanuma", "Tanuma1994", "1994Tanuma", "Tanuma1994",...
    "TPP2M", "TPP-2M", "TPP2"];
formalism_universal     = [...
    "Universal(1979)", "(1979)Universal", "Universal1979", "1979Universal",...
    "Seah(1979)", "(1979)Seah", "Seah1979", "1979Seah", "Seah1979",...
    "U", "Uni", "Universal"];
%% 2 - Determination of the IMFP
% -- Optical NIST1999 Database
if ~isempty(find(strcmpi(formalism_nist, formalism),1))
    if isstring(args)
        material = args;
        [imfp, ~] = calc_imfp_optical(ke_dat, material);
    else; msg = 'Material could not be identified. Only use elements 1 - 92; H, He, Li, Be..., Pa, U'; error(msg);
    end
% -- Universal formalism (1979 Seah)
elseif ~isempty(find(strcmpi(formalism_universal, formalism),1))
    imfp = calc_imfp_universal(ke_dat);
% -- TPP2M formalism (1994 Tanuma)
elseif ~isempty(find(strcmpi(formalism_tpp2m, formalism),1))
    if isstring(args)
        material = args;
        imfp = mpd_calc_imfp_tpp2m(ke_dat, material);
    else
        rho = args(1); Nv=args(4); M = args(2); Egap = args(3);
        imfp = calc_imfp_tpp2m(ke_dat, rho, Nv, M, Egap);
    end
% -- Average TPP2M formalism (1994 Tanuma)
elseif ~isempty(find(strcmpi(formalism_tpp2mavg, formalism),1))
    imfp = calc_imfp_tpp2m_avg(ke_dat);
% -- S1 formalism (2011 Seah)
elseif ~isempty(find(strcmpi(formalism_s1, formalism),1))
    if isstring(args)
        material = args;
        imfp = mpd_calc_imfp_S1(ke_dat, material);
    else
        rho = args(1); M = args(2); Egap = args(3); Z=args(4); stoichiometry=args(5);
        imfp = calc_imfp_S1(ke_dat, rho, M, Egap, Z, stoichiometry);
    end
% -- S2 formalism (2011 Seah)
elseif ~isempty(find(strcmpi(formalism_s2, formalism),1))
    if isstring(args)
        material = args;
        imfp = mpd_calc_imfp_S2(ke_dat, material);
    else
        Z=args(1);
        imfp = calc_imfp_S2(ke_dat, Z);
    end
% -- S3 formalism (2012 Seah)
elseif ~isempty(find(strcmpi(formalism_s3, formalism),1))
    if isstring(args)
        material = args;
        imfp = mpd_calc_eal_S3(ke_dat, material);
    else
        rho = args(1); M = args(2); Z=args(3); stoichiometry=args(4);
        imfp = calc_eal_S3(ke_dat, rho, M, Z, stoichiometry);
    end
% -- S3 formalism for organics (2012 Seah)
elseif ~isempty(find(strcmpi(formalism_s3org, formalism),1))
    imfp = calc_eal_S3_organic(ke_dat);
% -- S4 formalism (2012 Seah)
elseif ~isempty(find(strcmpi(formalism_s4, formalism),1))
    if isstring(args)
        material = args;
        imfp = mpd_calc_eal_S4(ke_dat, material);
    else
        Z=args(1);
        imfp = calc_eal_S4(ke_dat, Z);
    end
% -- JTP formalism (2023 JTP)
elseif ~isempty(find(strcmpi(formalism_jtp, formalism),1))
    if isstring(args)
        material = args;
        imfp = mpd_calc_imfp_jtp(ke_dat, material);
    else
        rho = args(1); Nv=args(4); M = args(2); Egap = args(3);
        imfp = calc_imfp_jtp(ke_dat, rho, Nv, M, Egap);
    end
else; msg = 'IMFP formalism not found.'; error(msg);
end
end