% This is a script that reads in behavioral data and organizes it 
% for the purposes of performing statistics and plotting techniques

% Inputs: data (in the form of a .xlsx file) & subs (the subjects that you
%         you would like to use) & test_names (the tests of interest)
% Outputs: vectorized data for each variable in the data set
clear all
clear
clc

%% Group Selection
% RAVE-O Pilot Intervention Group
% subs = {'124_AT', '138_LA', '141_GC', '143_CH'};
% Lindamood-Bell Subjects
subs = {'102_RS', '110_HH', '145_AC', '150_MG', '151_RD', '152_TC', ...
        '160_EK', '161_AK', '162_EF', '163_LF', '164_SF', '170_GM', ...
        '172_TH', '174_HS', '179_GM', '180_ZD', '202_DD',  ...
        '203_AM', '204_AM', '205_AC', '206_LM', '207_AH', '208_LH', ...
        '210_SB', '211_LB'};
% not included: , , '201_GS',

%% Test Selection; subgroups
all = {'WJ_LWID_SS', 'WJ_WA_SS', 'WJ_OR_SS', 'WJ_SRF_SS', 'WJ_MFF_SS', 'WJ_CALC_SS', 'WJ_BRS', 'WJ_RF',...
                'TWRE_SWE_SS', 'TWRE_PDE_SS', 'TWRE_INDEX', 'WASI_FS2', 'CTOPP_ELISION_SS', 'CTOPP_BW_SS', 'CTOPP_PI_SS',...
                'CTOPP_RAPID', 'CTOPP_PA'};
wj  = {'WJ_LWID_SS', 'WJ_WA_SS', 'WJ_OR_SS', 'WJ_SRF_SS', 'WJ_BRS', 'WJ_RF'};
twre= {'TWRE_SWE_SS', 'TWRE_PDE_SS', 'TWRE_INDEX'};
wasi= {'WASI_FS2'};
ctopp= {'CTOPP_ELISION_SS', 'CTOPP_BW_SS', 'CTOPP_PI_SS','CTOPP_RAPID', 'CTOPP_PA'};
math = {'WJ_MFF_SS', 'WJ_CALC_SS'};
basic = {'WJ_LWID_SS', 'WJ_WA_SS', 'WJ_BRS', 'WJ_RF', 'TWRE_SWE_SS', 'TWRE_PDE_SS', 'TWRE_INDEX'};
skills = {'WJ_LWID_SS', 'WJ_WA_SS', 'WJ_OR_SS', 'WJ_SRF_SS', 'TWRE_SWE_SS', 'TWRE_PDE_SS', 'TWRE_INDEX'};
basic_plus = {'WJ_LWID_SS', 'WJ_WA_SS', 'WJ_BRS', 'WJ_OR_SS', 'WJ_SRF_SS',  'WJ_RF', 'TWRE_SWE_SS', 'TWRE_PDE_SS', 'TWRE_INDEX', 'WJ_MFF_SS', 'WJ_CALC_SS', 'WJ_MCS'};
select = {'WJ_LWID_SS', 'WJ_WA_SS', 'TWRE_SWE_SS', 'TWRE_PDE_SS'};
composites = {'WJ_BRS', 'WJ_RF', 'TWRE_INDEX'};

%% Selections
% test group options: all, wj, twre, wasi, ctopp, math, and basic
test_names = basic_plus;
test_2_name = 'WJ_BRS';
predictor_name = 'CTOPP_ELISION_SS';
% time course options: (1) hours, (2) days, (3) sessions
time_course = 1; 
% enter sessions of interest, if applicable
usesessions = [1 2 3 4]; 
% dummy variable options: (0) off, (1) on
dummyon = 0;
% centering options: 'Time' (1), 'Score' (2), or 'Both' (3)
centering = 1;
% longitudinal plot options: (0) off, (1) on
long_plot = 0;
% growth plot options: (0) off, (1) on
growth_plot = 0;
% lme estimate plot options: (0) off, (1) on
lmestimate_plot = 0;



%% Gather data
stats = struct; % initialize the struct to store all data per test for analysis


for test = 1:length(test_names);    
    % run readData function to gather data of interest
    %[sid, long_var, score, score2, predictor, test_name, test_2_name] = readData(data, subs, test_names(ii), test_2_name, time_course, usesessions);
    test_names(test)
    readData;
    % gather lme statistics using lmeCalc function
     [lme_linear, lme_quad, lme_cube, data_table] = lmeCalc(sid, long_var, score, dummyon, centering);  
    % Collate data into stats struct
     stats(test).test_name = test_names(test); 
    stats(test).lme_linear = lme_linear;
    stats(test).data_table = data_table;  
    stats(test).lme_quad = lme_quad;
    stats(test).lme_cube = lme_cube;
%     predictor_lme;    
%     corr_analysis;
end

%% Plotting Techniques
if long_plot == 1
   [stats] = lmeLongplot(stats, test_names, subs, time_course); 
end
    
if growth_plot == 1
   [stats] = lmeGrowthplot(stats, test_names, subs, time_course);
end

if lmestimate_plot == 1
   [stats] = lmeEstimateplot(stats, test_names, subs, time_course);
end
