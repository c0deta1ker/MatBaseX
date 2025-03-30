close all; clear all;
%% 1    :   Use the MatBase Application for Crystallography Browser
run MatBaseX_02_CrystallographyViewer;
%% 2    :   CUB-cP-Oh    :    Simple Cubic (sc) 
close all; clear all;
[realStr, reciStr] = get_crystal_props("CUB-cP-Oh", 1);
get_bz_slice(reciStr, [1,0,0], 1);
get_bz_slice(reciStr, [0,1,0], 1);
get_bz_slice(reciStr, [0,0,1], 1);
bzSlice = get_bz_slice(reciStr, [1,1,0], 1)
%% 3    :   CUB-cF-Oh  :    Face-Centered Cubic (fcc)
close all; clear all;
[realStr, reciStr] = get_crystal_props("CUB-cF-Oh", 1);
get_bz_slice(reciStr, [1,0,0], 1);
get_bz_slice(reciStr, [0,1,0], 1);
get_bz_slice(reciStr, [0,0,1], 1);
bzSlice = get_bz_slice(reciStr, [1,1,0], 1)
%% 4    :   CUB-cI-Oh   :    Body-Centered Cubic (bcc)
close all; clear all;
[realStr, reciStr] = get_crystal_props("CUB-cI-Oh", 1);
bzSlice = get_bz_slice(reciStr, [1,0,0], 1);
bzSlice = get_bz_slice(reciStr, [0,1,0], 1);
bzSlice = get_bz_slice(reciStr, [0,0,1], 1);
bzSlice = get_bz_slice(reciStr, [1,1,0], 1);
%% 5    :   HEX-hP-D6h    :    Hexagonal (hex)
close all; clear all;
[realStr, reciStr] = get_crystal_props("HEX-hP-D6h", 1);
bzSlice = get_bz_slice(reciStr, [1,0,0], 1);
bzSlice = get_bz_slice(reciStr, [0,1,0], 1);
bzSlice = get_bz_slice(reciStr, [0,0,1], 1);

%% Brilluoin Zone slices : Linear Transformations
%% 6    :   CUB-cP-Oh    :    Simple Cubic (sc)
close all; clear all;
[realStr, reciStr] = get_crystal_props("CUB-cP-Oh", 1);
get_bz_slice(reciStr, [0,0,1], 1);
bzSlice         = get_bz_slice(reciStr, [1,1,0], 1);
bzSlice_rot     = rotate_bz_slice(bzSlice, {35}, 1);
bzSlice_trans   = translate_bz_slice(bzSlice_rot, {3.15, -1.25}, 1);

%% Miscellaneous functions
%% Extracting the crystal type based on geometry
close all;
get_crystal_type([1,1,1], [90,90,90])
get_crystal_type([1,1,1], [90,90,120])
get_crystal_type([2,2,2], [45,45,45])
%% (A) Plotting truncated octahedron
close all;
fig = figure(); fig.Position = [10 10 800, 600];  hold on; 
plot_TruncOctahedron(); 
camlight(-90, 20);
%% (B) Plotting 3D silicon valleys embedded in Brillouin Zone
close all;
fig = figure(); fig.Position = [10 10 800, 600]; hold on;
% -- Plotting the axes lines
L = 0.75; X = 0.95;
M111_col = [0.8, 0.4, 0];
X100_col = [0.1,0.6,0.1];
G001_col = [0.6,0.1,0.6];
line([0, 0]*X, [0, 0]*X, [-1, 1]*X, 'Color', G001_col, 'LineWidth', 1, 'Linestyle', '-');
line([0, 0]*X, [-1, 1]*X, [0, 0]*X, 'Color', X100_col, 'LineWidth', 1, 'Linestyle', '-');
line([-1, 1]*X, [0, 0]*X, [0, 0]*X, 'Color', X100_col, 'LineWidth', 1, 'Linestyle', '-');
% - (1st ZONE) PLOTTING THE SILICON VALLEYS and BZ
plot_SiCBValleys_3D(0.2,[],[0.03, 0.03, -0.25]);
plot_fccBZ_3D();
% Formatting the figure
axis([-1, 1, -1, 1, -1, 1]*1.2); view([-65, 16]); camlight(-0, 20);
axis off;
%% (C) Plotting 2D silicon valleys embedded in Brillouin Zone
close all;
fig = figure(); fig.Position = [10 10 800, 600]; hold on;
% -- Plotting the axes lines
line([0 0], [-1, 1]*5, [0 0], 'Color', [0 0 0], 'LineWidth', 1, 'Linestyle', '--');
line([-1 1]*5, [0 0], [0 0], 'Color', [0 0 0], 'LineWidth', 1, 'Linestyle', '--');
line([0, 0], [0 0], [-1 1]*5, 'Color', [0 0 0], 'LineWidth', 1, 'Linestyle', '--');
% - (1st ZONE) PLOTTING THE SILICON VALLEYS and BZ
plot_SiCBValleys_q2D(0.3,[],[0.03, 0.03, -0.25]);
plot_fccBZ_3D();
% Formatting the figure
axis([-1, 1, -1, 1, -1, 1]*1.2); view([-65, 16]); camlight(-0, 20);
axis off;
%% (D) Plotting 3D germanium valleys embedded in Brillouin Zone
close all;
fig = figure(); fig.Position = [10 10 800, 600]; hold on;
% -- Plotting the axes lines
L = 0.75; X = 0.95;
M111_col = [0.8, 0.4, 0];
X100_col = [0.1,0.6,0.1];
G001_col = [0.6,0.1,0.6];
line(-1*[-1, 1]*L, [-1, 1]*L, [-1, 1]*L, 'Color', M111_col, 'LineWidth', 1, 'Linestyle', '-');
line([-1, 1]*L, -1*[-1, 1]*L, [-1, 1]*L, 'Color', M111_col, 'LineWidth', 1, 'Linestyle', '-');
line([-1, 1]*L, [-1, 1]*L, -1*[-1, 1]*L, 'Color', M111_col, 'LineWidth', 1, 'Linestyle', '-');
line([-1, 1]*L, [-1, 1]*L, [-1, 1]*L, 'Color', M111_col, 'LineWidth', 1, 'Linestyle', '-');
line([0, 0]*X, [0, 0]*X, [-1, 1]*X, 'Color', G001_col, 'LineWidth', 1, 'Linestyle', '-');
line([0, 0]*X, [-1, 1]*X, [0, 0]*X, 'Color', X100_col, 'LineWidth', 1, 'Linestyle', '-');
line([-1, 1]*X, [0, 0]*X, [0, 0]*X, 'Color', X100_col, 'LineWidth', 1, 'Linestyle', '-');
% - (1st ZONE) PLOTTING THE SILICON VALLEYS and BZ
plot_SiCBValleys_3D(0.20,[],[0.05, 0.05, -0.05]);
plot_fccBZ_3D(5.657);
plot_GeCBValleys_3D(0.3);
% Formatting the figure
axis([-1, 1, -1, 1, -1, 1]*1.2); view([-65, 16]); camlight(-0, 20); axis off;