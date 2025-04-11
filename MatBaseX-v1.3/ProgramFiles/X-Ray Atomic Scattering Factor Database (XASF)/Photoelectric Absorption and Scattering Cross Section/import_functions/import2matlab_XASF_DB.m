close all; clear all;
%% 1 :  Importing all X-Ray Atomic Scattering Factors
run import2matlab_XASF_DB_1993Henke.m; close all; clear all;
run import2matlab_XASF_DB_2005NIST.m; close all; clear all;
%% 2 :  Plotting all XASF of the elements and compounds
% -- Initializing save path
path_matbase    = what('Photoelectric Absorption and Scattering Cross Section'); path_matbase = string(path_matbase.path);
path_fig_save   = path_matbase + "\0_figs\";
% -- Defining all of the variables
ATOM_ELE   = read_mpd_elements();           % -- List of all elements  
ATOM_ELE    = ATOM_ELE(1:92);
ATOM_CMP   = read_mpd_compounds();          % -- List of all compounds
MAT_SYMB   = horzcat(ATOM_ELE, ATOM_CMP);   % -- List of all elements & compounds
% -- Plotting IMFP of all elements
for i = 1:length(MAT_SYMB)
    mat_props = get_mpd_props(MAT_SYMB{i});
    save_fullname = path_fig_save + sprintf("id%i_%s_XASF", mat_props.id, MAT_SYMB{i});
    [fig, ~] = view_xasf(MAT_SYMB{i});
    print(save_fullname,'-dpng', '-r500');
    saveas(fig, save_fullname, 'fig');
    close all;
end
%% 3 :  Consistency check with formulas & NIST results
path_fig_save   = path_matbase + "\0_figs\ref001_Henke_Vs_NIST\";
% -- Loading in database
XASF_DB_NIST2005	= load('XASF_DB_NIST2005.mat'); XASF_DB_NIST2005 = XASF_DB_NIST2005.XASF_DB_NIST2005;
% -- Filing through all elements
ATOM_SYMB       = read_mpd_elements();
ATOM_SYMB       = ATOM_SYMB(1:92);
ATOM_ZNUM       = 1:length(ATOM_SYMB);
hv              = logspace(1,6,1e3);
ATOM_SYMB       = XASF_DB_NIST2005.ATOM_SYMB;
for i = 1:length(ATOM_SYMB)
    mu_m = mpd_calc_mass_absorb_coeff(hv, ATOM_SYMB{i});
    % - Creating a figure
    fig = figure(); 
    fig.Position(1) = 100; fig.Position(2) = 100;
    fig.Position(3) = 650; 
    fig.Position(4) = 450;
    % - Creating a tiled axis
    t = tiledlayout(1,1);
    t.TileSpacing = 'compact';
    t.Padding = 'compact';
    nexttile(); hold on; grid on; grid minor;
    % - Plot figures
    plot(hv, mu_m, 'k-', 'linewidth', 3);
    plot(XASF_DB_NIST2005.HV{i}, XASF_DB_NIST2005.Mu_Photo{i}, 'r:', 'linewidth', 1.5);
    plot(XASF_DB_NIST2005.HV{i}, XASF_DB_NIST2005.Mu_Coh_Inc{i}, 'b:', 'linewidth', 1.5);
    plot(XASF_DB_NIST2005.HV{i}, XASF_DB_NIST2005.Mu_Total{i}, 'g:', 'linewidth', 1.5);
    % - Formatting the axis
    lgnd_txt = {'Here', 'NIST-Mu(Photo)', 'NIST-Mu(Coh-Inc)', 'NIST-Mu(Total)'};
    legend(lgnd_txt, 'location', 'southwest', 'FontSize', 8); 
    text(0.02, 0.96, sprintf("%s (Z=%i)", ATOM_SYMB{i}, i),...
        'FontSize', 14, 'color', 'k', 'Units','normalized', 'FontWeight', 'bold', 'HorizontalAlignment','left');
    xlabel(' Photon Energy [eV] ', 'FontWeight','bold');
    ylabel(' \mu / \rho [cm^{-2}] ', 'FontWeight','bold');
    ax = gca; ax.YScale = 'log'; ax.XScale = 'log';
    axis([5, 1e6, 1e-8, 1e8]);
    save_fullname = path_fig_save + sprintf("Ref001_Z%i_%s_NIST_check", ATOM_ZNUM(i), ATOM_SYMB{i});
    print(save_fullname,'-dpng', '-r400');
    close all;
end
%% 4 :  Consistency check with compounds
% -- Extracting the reference data
path_data   = path_matbase + "\1993Henke_AtomicScatteringFactors\data_ref\";
path_fig_save   = path_matbase + "\0_figs\ref002_Henke_Compounds\";
dat_files   = {...
    "Au_Ref_IndexOfRefraction.txt",...
    "Si_Ref_IndexOfRefraction.txt",...
    "SiO2_Ref_IndexOfRefraction.txt",...
    "Si3N4_Ref_IndexOfRefraction.txt",...
    };
MAT_SYMB    = {...
    "Au",...
    "Si",...
    "SiO2",...
    "Si3N4",...
    };
% -- Comparing the reference data and MATLAB calculations
hv = logspace(1,5,1e3);
for i = 1:length(MAT_SYMB)
    % - Henke Data (online source)
    raw_table           = readtable(string(path_data) + dat_files{i}, 'VariableNamingRule','preserve');
    henke_hv            = table2array(raw_table(:,1));
    henke_delta         = table2array(raw_table(:,2));
    henke_beta          = table2array(raw_table(:,3));
    % - MatBaseX Calculations
    material = MAT_SYMB{i};
    % 1 - Defining variables
    pc          = physics_constants();
    lambda      = convert_eV_to_nm(hv);
    na          = mpd_calc_number_density(material);
    % 2 - Calculate all parameters
    [f1, f2]     = calc_xasf(hv, material, 'Henke');
    beta        = ((na/1e-6)*(pc.re)*(lambda*1e-9).^2 .* f2) ./ (2*pi);
    delta       = ((na/1e-6)*(pc.re)*(lambda*1e-9).^2 .* f1) ./ (2*pi);
    % - Creating a figure
    fig = figure(); 
    fig.Position(1) = 100; fig.Position(2) = 100;
    fig.Position(3) = 650; 
    fig.Position(4) = 450;
    % - Creating a tiled axis
    t = tiledlayout(1,1);
    t.TileSpacing = 'compact';
    t.Padding = 'compact';
    nexttile(); hold on; grid on; grid minor;
    % - Plot figures
    plot(hv, beta, 'r-', 'linewidth', 1.5);
    plot(hv, delta, 'b-', 'linewidth', 1.5);
    % - Plot figures
    plot(henke_hv, henke_beta, 'rx');
    plot(henke_hv, henke_delta, 'bx');
    % - Formatting the axis
    lgnd_txt = {'Here', 'Henke(WebSourced)'};
    legend(lgnd_txt, 'location', 'southwest', 'FontSize', 8); 
    text(0.02, 0.96, sprintf("%s", MAT_SYMB{i}),...
        'FontSize', 14, 'color', 'k', 'Units','normalized', 'FontWeight', 'bold', 'HorizontalAlignment','left');
    xlabel(' Photon Energy [eV] ', 'FontWeight','bold');
    ylabel(' \beta / \delta ', 'FontWeight','bold');
    ax = gca; ax.YScale = 'log'; ax.XScale = 'log';
    axis([5, 1e5, 1e-8, 1e1]);
    save_fullname = path_fig_save + sprintf("Ref002_%s_Henke_check", MAT_SYMB{i});
    print(save_fullname,'-dpng', '-r400');
    close all;
end
