close all; clear all;
path_matbase    = what('1985YehLindau_Photoionization_Cross_Sections'); path_matbase = string(path_matbase.path);
path_data_sigma     = path_matbase + "\data_sigma\";
path_data_beta      = path_matbase + "\data_beta\";
path_data_save      = path_matbase + "\";
path_fig_save_sigma = path_matbase + "\figs_sigma\";
path_fig_save_beta  = path_matbase + "\figs_beta\";
%% 1 :  Defining all of the variables
% -- Defining the elements whose photoionization cross-sections are available
ATOM_SYMB = read_mpd_elements();
ATOM_SYMB = ATOM_SYMB(1:103);
% -- Defining the Z number for each one of these elements
ATOM_ZNUM = 1:length(ATOM_SYMB);
% -- Defining all of the core-levels that are probed
ATOM_CL = {...
    '1s1',...
    '2s1', '2p3',...
    '3s1', '3p3', '3d5',...
    '4s1', '4p3', '4d5', '4f7',...
    '5s1', '5p3', '5d5', '5f7',...
    '6s1', '6p3', '6d5',...
    '7s1',...
    };
%% 2 :  Iterating through all the data-files and extacting the photoionization parameters
% -- Extracting all the filenames for the photoionization data
file_names      = dir(path_data_beta);
file_names      = {file_names(~[file_names.isdir]).name};
% -- Filing through all the elements to isolate each element
for i = ATOM_ZNUM
    % --- Finding the index number for the element
    findx               = find(contains(file_names, "_"+string(ATOM_SYMB{i})+"_"));
    selected_names{i}   = file_names(findx);
    for j = 1:length(selected_names{i})
        % -- Loading in all of the data
        DATA_TABLE      = importdata(string(path_data_beta) + string(selected_names{i}{j}));
        hv              = DATA_TABLE(:,1);
        xsect           = mean(DATA_TABLE(:,2:4), 2);
        asymmetry       = mean(DATA_TABLE(:,5:7), 2);
        % -- Validity checks on the data
        % ---- Make sure it is in ascending order of photon energy
        [hv, indx]      = sort(hv);
        xsect           = xsect(indx);
        asymmetry       = asymmetry(indx);
        % ---- Make sure that there are no duplicates of the photon energy (only unique points)
        [hv, indx]      = unique(hv);
        xsect           = 10^6 .* xsect(indx);
        asymmetry       = asymmetry(indx);
        % -- Storing the data into a cell array
        beta_data{i}{j} = [hv, xsect, asymmetry];
    end
end
hv_interp = 10:10:1500; hv_interp = hv_interp';
% -- Loading in all the data for each text file
XSECT_SIGMA = {}; XSECT_BETA = {};
for i = 1:length(beta_data)
    XSECT_SIGMA{i}      = table();
    XSECT_BETA{i}       = table();
    for j = 1:length(beta_data{i})
        % -- Loading in the original data
        hv          = beta_data{i}{j}(:,1);     % -- Photon Energy
        xsect       = beta_data{i}{j}(:,2);     % -- Cross-Section
        asymmetry   = beta_data{i}{j}(:,3);     % -- Asymmetry
        % -- Interpolating the data onto a consistent domain
        cl_name     = string(selected_names{i}{j}(end-6:end-5));
        if contains(cl_name, "s"); cl_name = cl_name + "1";
        elseif contains(cl_name, "p"); cl_name = cl_name + "3";
        elseif contains(cl_name, "d"); cl_name = cl_name + "5";
        elseif contains(cl_name, "f"); cl_name = cl_name + "7";
        end
        XSECT_SIGMA{i}.(cl_name) = interp1(hv, xsect, hv_interp, 'linear');
        XSECT_BETA{i}.(cl_name) = interp1(hv, asymmetry, hv_interp, 'linear');
        % -- Validity checks on the data for future processing
        % ---- Any data-points outside of the domain, reduce to a NaN
        [~, hv_indx(1)]	= min(abs(hv_interp - min(hv(:))));
        [~, hv_indx(2)]	= min(abs(hv_interp - max(hv(:))));
        % XSECT_SIGMA{i}.(cl_name)(1:hv_indx(1)) = NaN; 
        % XSECT_SIGMA{i}.(cl_name)(hv_indx(2):end) = NaN;
        % XSECT_BETA{i}.(cl_name)(1:hv_indx(1)) = NaN; 
        % XSECT_BETA{i}.(cl_name)(hv_indx(2):end) = NaN;
    end
end
HV = table(); HV.("Photon Energy / eV") = hv_interp;
%% 3 :  Correcting the sigma values
for i = 1:length(XSECT_SIGMA)
    cl_names = XSECT_SIGMA{i}.Properties.VariableNames;
    for j = 1:length(cl_names)
        cl_name = cl_names{j};
        % -- Adding p core-levels
        if cl_name(2) == 'p'
            cl_name_new = cl_name;
            cl_name_new(3) = '1';
            XSECT_SIGMA{i}.(cl_name_new)    = XSECT_SIGMA{i}.(cl_name) * (1/3);
            XSECT_BETA{i}.(cl_name_new)     = XSECT_BETA{i}.(cl_name);
            XSECT_SIGMA{i}.(cl_name)        = XSECT_SIGMA{i}.(cl_name) * (2/3);
            XSECT_BETA{i}.(cl_name)         = XSECT_BETA{i}.(cl_name);
        elseif cl_name(2) == 'd'
            cl_name_new = cl_name;
            cl_name_new(3) = '3';
            XSECT_SIGMA{i}.(cl_name_new)    = XSECT_SIGMA{i}.(cl_name) * (2/5);
            XSECT_BETA{i}.(cl_name_new)     = XSECT_BETA{i}.(cl_name);
            XSECT_SIGMA{i}.(cl_name)        = XSECT_SIGMA{i}.(cl_name) * (3/5);
            XSECT_BETA{i}.(cl_name)         = XSECT_BETA{i}.(cl_name);
        elseif cl_name(2) == 'f'
            cl_name_new = cl_name;
            cl_name_new(3) = '5';
            XSECT_SIGMA{i}.(cl_name_new)    = XSECT_SIGMA{i}.(cl_name) * (3/7);
            XSECT_BETA{i}.(cl_name_new)     = XSECT_BETA{i}.(cl_name);
            XSECT_SIGMA{i}.(cl_name)        = XSECT_SIGMA{i}.(cl_name) * (4/7);
            XSECT_BETA{i}.(cl_name)         = XSECT_BETA{i}.(cl_name);
        end
    end
end
ATOM_CL_ALL = {...
    '1s1',...
    '2s1', '2p1', '2p3',...
    '3s1', '3p1', '3p3', '3d3','3d5',...
    '4s1', '4p1', '4p3', '4d3','4d5', '4f5', '4f7',...
    '5s1', '5p1', '5p3', '5d3','5d5', '5f5', '5f7',...
    '6s1', '6p1', '6p3', '6d3','6d5',...
    '7s1',...
    };
%% (4)     :    Appending the data into a MATLAB structure file
XS_DB_YehLind1985                   = struct();
XS_DB_YehLind1985.file_names        = file_names;
XS_DB_YehLind1985.ATOM_SYMB         = ATOM_SYMB;
XS_DB_YehLind1985.ATOM_ZNUM         = ATOM_ZNUM;
XS_DB_YehLind1985.ATOM_CL           = ATOM_CL_ALL;
XS_DB_YehLind1985.DATA_TABLE        = DATA_TABLE;
XS_DB_YehLind1985.HV                = HV;
XS_DB_YehLind1985.XSECT_SIGMA       = XSECT_SIGMA;
XS_DB_YehLind1985.XSECT_BETA        = XSECT_BETA;
save(char(path_data_save + "XS_DB_YehLind1985"), 'XS_DB_YehLind1985', '-v7.3');
XS_DB_YehLind1985
%% (5)     :    Running through all elements and plotting the photoionization parameters
close all;
hv_domain       = 0;
extrapolate     = 0;
plot_results    = 1;
for i = ATOM_ZNUM
    % -- Plotting Sigma
    save_sig = path_fig_save_sigma + sprintf("Z%i_%s_XS_sigma_Yeh1985", ATOM_ZNUM(i), ATOM_SYMB{i});
    calc_xsect_sigma_yehlind1985(hv_domain, ATOM_SYMB{i}, [], extrapolate, plot_results);   
    figX = gca;
    print(save_sig,'-dpng', '-r500');
    saveas(figX, save_sig, 'fig');
    close all;
    % -- Plotting Beta
    save_beta = path_fig_save_beta + sprintf("Z%i_%s_XS_beta_Yeh1985", ATOM_ZNUM(i), ATOM_SYMB{i});
    calc_xsect_beta_yehlind1985(hv_domain, ATOM_SYMB{i}, [], extrapolate, plot_results);  
    figX = gca;  
    print(save_beta,'-dpng', '-r500');
    saveas(figX, save_beta, 'fig');
    close all;
end