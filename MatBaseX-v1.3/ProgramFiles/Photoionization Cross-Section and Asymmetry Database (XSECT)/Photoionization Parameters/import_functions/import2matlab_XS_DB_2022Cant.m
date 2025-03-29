close all; clear all;
path_matbase    = what('2022Cant_AMRSF'); path_matbase = string(path_matbase.path);
path_coeffs                 = path_matbase + "\coeff_tables\";
path_data_save              = path_matbase + "\";
path_data_save_sigma        = path_matbase + "\data_sigma\";
path_data_save_beta         = path_matbase + "\data_beta\";
path_data_save_gamma        = path_matbase + "\data_gamma\";
path_data_save_delta        = path_matbase + "\data_delta\";
path_fig_save_sigma         = path_matbase + "\figs_sigma\";
path_fig_save_beta          = path_matbase + "\figs_beta\";
path_fig_save_gamma         = path_matbase + "\figs_gamma\";
path_fig_save_delta         = path_matbase + "\figs_delta\";
%% 1 :  Defining all of the variables
% -- Defining the elements whose photoionization cross-sections we have
ATOM_SYMB = read_mpd_elements();
ATOM_SYMB = ATOM_SYMB(1:98);
% -- Defining the Z number for each one of these elements
ATOM_ZNUM = 1:length(ATOM_SYMB);
% -- Defining all of the core-levels that are probed
% --- Defining in terms of orbital notation (for sigma)
ATOM_CL_01 = {...
    '1s1', '2s1', '3s1', '4s1', '5s1',...
    '2p1', '2p3','3p1', '3p3','4p1', '4p3','5p1', '5p3'...
    '3d3', '3d5','4d3', '4d5',...
    '4f5', '4f7',...
    };
% --- Defining in terms of orbital notation (for beta, gamma, delta)
ATOM_CL_02 = {...
    '1s1', '2s1', '3s1', '4s1', '5s1',...
    '2p1', '2p3','3p1', '3p3','4p1', '4p3','5p1', '5p3'...
    '3d3', '3d5','4d3', '4d5','5d3', '5d5',...
    '4f5', '4f7',...
    };
% --- Defining the photon energy domain
hv_dom = 1500:250:10000; hv_dom = hv_dom';
HV = table(); HV.('PhotonEnergy_eV') = hv_dom;
%% 2 :  Calculating the photoionization cross-sections
XSECT_SIGMA = cell(size(ATOM_ZNUM)); 
XSECT_BETA  = cell(size(ATOM_ZNUM)); 
XSECT_GAMMA = cell(size(ATOM_ZNUM)); 
XSECT_DELTA = cell(size(ATOM_ZNUM));
for Z = ATOM_ZNUM
    fprintf("Run %i/%i\n", Z, ATOM_ZNUM(end));
    % - Initializing tables (first column is photon energy)
    XSECT_SIGMA{Z}  = table();  XSECT_SIGMA{Z}.('PhotonEnergy_eV')  = hv_dom;
    XSECT_BETA{Z}   = table();  XSECT_BETA{Z}.('PhotonEnergy_eV')   = hv_dom;
    XSECT_GAMMA{Z}  = table();  XSECT_GAMMA{Z}.('PhotonEnergy_eV')  = hv_dom;
    XSECT_DELTA{Z}  = table();  XSECT_DELTA{Z}.('PhotonEnergy_eV')  = hv_dom;
    % A - Calculating sigma
    corelevels      = string(ATOM_CL_01);   
    xsect_sigma     = calc_xsect_sigma_cant2022(hv_dom, ATOM_SYMB{Z}, corelevels);
    % % Removing all NaN columns
    % NaN_idx                 = all(isnan(xsect_sigma), 1);
    % corelevels(NaN_idx)     = []; 
    % xsect_sigma(:,NaN_idx)  = [];
    % Appending final data to table
    for j = 1:length(corelevels)
        XSECT_SIGMA{Z}.(corelevels(j)) = xsect_sigma(:,j);
    end
    writetable(XSECT_SIGMA{Z}, path_data_save_sigma + sprintf("Z_%i_%s.csv", Z, ATOM_SYMB{Z}));
    XSECT_SIGMA{Z}(:,1) = [];   % delete the photon energy from the data structure
    % B - Calculating beta
    corelevels      = string(ATOM_CL_02);  
    xsect_beta      = calc_xsect_beta_cant2022(hv_dom, ATOM_SYMB{Z}, corelevels); 
    % % Removing all NaN columns
    % NaN_idx                 = all(isnan(xsect_beta), 1);
    % corelevels(NaN_idx)     = []; 
    % xsect_beta(:,NaN_idx)  = [];
    % Appending final data to table
    for j = 1:length(corelevels)
        XSECT_BETA{Z}.(corelevels(j)) = xsect_beta(:,j);
    end
    writetable(XSECT_BETA{Z}, path_data_save_beta + sprintf("Z_%i_%s.csv", Z, ATOM_SYMB{Z}));
    XSECT_BETA{Z}(:,1) = [];   % delete the photon energy from the data structure
    % C - Calculating gamma
    corelevels      = string(ATOM_CL_02);  
    xsect_gamma      = calc_xsect_gamma_cant2022(hv_dom, ATOM_SYMB{Z}, corelevels); 
    % % Removing all NaN columns
    % NaN_idx                 = all(isnan(xsect_gamma), 1);
    % corelevels(NaN_idx)     = []; 
    % xsect_gamma(:,NaN_idx)  = [];
    % Appending final data to table
    for j = 1:length(corelevels)
        XSECT_GAMMA{Z}.(corelevels(j)) = xsect_gamma(:,j);
    end
    writetable(XSECT_GAMMA{Z}, path_data_save_gamma + sprintf("Z_%i_%s.csv", Z, ATOM_SYMB{Z}));
    XSECT_GAMMA{Z}(:,1) = [];   % delete the photon energy from the data structure
    % D - Calculating delta
    corelevels      = string(ATOM_CL_02);  
    xsect_delta      = calc_xsect_delta_cant2022(hv_dom, ATOM_SYMB{Z}, corelevels); 
    % % Removing all NaN columns
    % NaN_idx                 = all(isnan(xsect_delta), 1);
    % corelevels(NaN_idx)     = []; 
    % xsect_delta(:,NaN_idx)  = [];
    % Appending final data to table
    for j = 1:length(corelevels)
        XSECT_DELTA{Z}.(corelevels(j)) = xsect_delta(:,j);
    end
    writetable(XSECT_DELTA{Z}, path_data_save_delta + sprintf("Z_%i_%s.csv", Z, ATOM_SYMB{Z}));
    XSECT_DELTA{Z}(:,1) = [];   % delete the photon energy from the data structure
end
%% 3 :  Appending the data into a MATLAB structure file
XS_DB_Cant2022                  = struct();
XS_DB_Cant2022.ATOM_SYMB        = ATOM_SYMB;
XS_DB_Cant2022.ATOM_ZNUM        = ATOM_ZNUM;
XS_DB_Cant2022.HV               = HV;
XS_DB_Cant2022.XSECT_SIGMA      = XSECT_SIGMA;
XS_DB_Cant2022.XSECT_BETA       = XSECT_BETA;
XS_DB_Cant2022.XSECT_GAMMA      = XSECT_GAMMA;
XS_DB_Cant2022.XSECT_DELTA      = XSECT_DELTA;
save(char(path_data_save + "XS_DB_Cant2022"), 'XS_DB_Cant2022', '-v7.3');
XS_DB_Cant2022
%% 4 :  Running through all elements and plotting the cross-sections
close all;
hv_domain       = 0;
plot_results    = 1;
for i = ATOM_ZNUM
    % -- Plot Sigma
    save_fullname = path_fig_save_sigma + sprintf("Z%i_%s_XS_sigma_Cant2022", ATOM_ZNUM(i), ATOM_SYMB{i});
    calc_xsect_sigma_cant2022(hv_domain, ATOM_SYMB{i}, [], plot_results);      
    print(save_fullname,'-dpng', '-r500');
    figX = gca;
    saveas(figX, save_fullname, 'fig');
    close all;
    % -- Plot Beta
    save_fullname = path_fig_save_beta + sprintf("Z%i_%s_XS_beta_Cant2022", ATOM_ZNUM(i), ATOM_SYMB{i});
    calc_xsect_beta_cant2022(hv_domain, ATOM_SYMB{i}, [], plot_results);         
    print(save_fullname,'-dpng', '-r500');
    figX = gca;
    saveas(figX, save_fullname, 'fig');
    close all;
    % -- Plot Gamma
    save_fullname = path_fig_save_gamma + sprintf("Z%i_%s_XS_gamma_Cant2022", ATOM_ZNUM(i), ATOM_SYMB{i});
    calc_xsect_gamma_cant2022(hv_domain, ATOM_SYMB{i}, [], plot_results);          
    print(save_fullname,'-dpng', '-r500');
    figX = gca;
    saveas(figX, save_fullname, 'fig');
    close all;
    % -- Plot Delta
    save_fullname = path_fig_save_delta + sprintf("Z%i_%s_XS_delta_Cant2022", ATOM_ZNUM(i), ATOM_SYMB{i});
    calc_xsect_delta_cant2022(hv_domain, ATOM_SYMB{i}, [], plot_results);           
    print(save_fullname,'-dpng', '-r500');
    figX = gca;
    saveas(figX, save_fullname, 'fig');
    close all;
end