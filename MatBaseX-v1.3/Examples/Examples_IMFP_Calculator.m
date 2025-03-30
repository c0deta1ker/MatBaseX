close all; clear all;
%% 1    :   Use the MatBase Application for IMFP Determination
run MatBaseX_05_IMFP;
%% 2    :   Calculating the IMFP of Silicon at 1000 eV kinetic energy
close all;
ke_dat = 1000;
element = 'Si';
imfp_Si_uni     = calc_imfp(ke_dat, 'universal', element);
imfp_Si_tpp2m   = calc_imfp(ke_dat, 'tpp2m', element);
imfp_Si_nist    = calc_imfp(ke_dat, 'nist', element);
imfp_Si_s1      = calc_imfp(ke_dat, 'S1', element);
imfp_Si_s2      = calc_imfp(ke_dat, 'S2', element);
imfp_Si_s3      = calc_imfp(ke_dat, 'S3', element);
imfp_Si_s4      = calc_imfp(ke_dat, 'S4', element);
imfp_Si_jtp     = calc_imfp(ke_dat, 'JTP', element);
view_imfp(element);
%% 3    :   Calculating the IMFP of InAs at 100 -> 5000 eV kinetic energy
close all;
ke_dat = 100:1:5000;
material = 'InAs';
imfp_InAs_jtp     = calc_imfp(ke_dat, 'JTP', material);
figure(); hold on;
plot(ke_dat, imfp_InAs_jtp, 'k.-');
xlabel('Kinetic Energy (eV)');
ylabel('IMFP (Angstrom)');
grid on;
