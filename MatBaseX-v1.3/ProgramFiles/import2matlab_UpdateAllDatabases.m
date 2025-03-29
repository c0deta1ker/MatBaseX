close all; clear all; clc;
path_matbase    = what('MatBase'); path_matbase = string(path_matbase.path);
addpath(genpath(path_matbase));

%% 1    :   MATLAB Digitization of All Databases, Figures & Data-Structures
close all; clear all;
% 1.1    :   Materials Properties Database
run import2matlab_MPD_DB.m; close all; clear all;
% 1.2    :   Photoionization Binding Energies
run import2matlab_BE_DB.m; close all; clear all;
% 1.3    :   Inelastic Mean Free Path (IMFP) calculators
run import2matlab_IMFP_DB.m; close all; clear all;
% 1.4    :   Photoionization Cross-Sections & Asymmetry Parameters
% 1.4A    :    Photoionization parameters
run import2matlab_XS_DB.m; close all; clear all;
% 1.4B    :    Photoionization angular anisotropy
run import2matlab_AA.m; close all; clear all;
% 1.5    :   XPS Sensitivity Factors
run import2matlab_SF.m; close all; clear all;
% 1.6    :   X-Ray Atomic Scattering Factor Database
run import2matlab_XASF_DB.m; close all; clear all;
% 1.7    :   X-Ray Absorption Edge Database
run import2matlab_XAE_DB.m; close all; clear all;

%% 2    :   MATLAB Data Analysis Software
close all; clear all;
% 2.1    :   Generic & PES Curve Shapes
run import2matlab_CSLIB.m; close all; clear all;





%% 3    :   Executing software to stress-test all functions
% This should run smoothly through all the testing scripts with no errors
% and is a verification that everything works properly. It may take quite a
% long time to run.
run stressNtest_01_MPD.m; close all; clear all;
run stressNtest_02_IMFP.m; close all; clear all;
run stressNtest_03_BE.m; close all; clear all;
run stressNtest_04_XSECT.m; close all; clear all;
run stressNtest_05_XSECT_ANISO.m; close all; clear all;
run stressNtest_06_SF.m; close all; clear all;
run stressNtest_07_XAE.m; close all; clear all;
run stressNtest_08_XASF.m; close all; clear all;
