function crystal_type = get_crystal_type(lattice_params, lattice_angles)
% crystal_type = get_crystal_type(lattice_params, lattice_angles)
%   This is a function that outputs the crystallographic structure based on
%   the input lattice parameters and angles.
%
%   IN:
%   - lattice_params:     1x3 row-vector of the side lengths (a, b, c) of the crystal systems unit cell (Angstroms).
%   - lattice_params:     1x3 row vector the opposite angles (alpha, beta, gamma) of the crystal systems unit cell (degrees).
%
%   OUT:
%   - crystal_type:     string of the crystal type, one of the below,
%                           - CUB-cP-Oh    : Simple Cubic
%                           - HEX-hP-D6h   : Simple Hexagonal
%                           - RHL-hR-D3d   : Simple Rhombahedral
%                           - TET-tP-D4h   : Simple Tetragonal
%                           - ORC-oP-D2h   : Simple Orthorhombic
%                           - MCL-mP-C2h   : Simple Monoclinic
%                           - TRI-aP-Ci    : Simple Triclinic

%% Initializing the input variables
% -- Checking that all inputs are entered
if length(lattice_params) ~= 3 || length(lattice_angles) ~= 3
    error('Enter the correct number of arguments; lattice_params and lattice_angles should be a [1x3] row-vector. ');
end
% -- Extracting thte lattice parameters
a           = round(lattice_params(1), 4);
b           = round(lattice_params(2), 4);
c           = round(lattice_params(3), 4);
alpha       = round(lattice_angles(1), 4);
beta        = round(lattice_angles(2), 4);
gamma       = round(lattice_angles(3), 4);
%% 1 - Finding the symmetry rules of the user-defined system
if a == b && b == c && alpha == 90 && beta == 90 && gamma == 90
    crystal_type = "CUB-cP-Oh";
elseif alpha == 90 && beta == 90 && gamma == 120 && a == b || alpha == 90 && beta == 120 && gamma == 90 && a == c || alpha == 120 && beta == 90 && gamma == 90 && b == c
    crystal_type = "HEX-hP-D6h";
elseif alpha == beta && beta == gamma && a == b && b == c
    crystal_type = "RHL-hR-D3d";
elseif alpha == 90 && beta == 90 && gamma == 90 && a == b || alpha == 90 && beta == 90 && gamma == 90 && b == c || alpha == 90 && beta == 90 && gamma == 90 && a == c
    crystal_type = "TET-tP-D4h";
elseif alpha == 90 && beta == 90 && gamma == 90 && a ~= b && b~= c
    crystal_type = "ORC-oP-D2h";
elseif alpha ~= 90 && beta == 90 && gamma == 90 && a ~= b && b~= c || alpha == 90 && beta ~= 90 && gamma == 90 && a ~= b && b~= c || alpha == 90 && beta == 90 && gamma ~= 90 && a ~= b && b~= c
    crystal_type = "MCL-mP-C2h";
else
    crystal_type = "TRI-aP-Ci";
end
end