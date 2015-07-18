function savefile = param_hopkins( repeats )
%EXPERIMENT Find parameters that work well for yale dataset
%   Example use: workspace; clean; savefile=param_hopkins({}, 2);
%   repeats = number of repeats

%% PARAMS
dataset = {'1R2RCR_g12','1R2RCR_g13','1R2RCR_g23',...
    '1R2RCT_A','1R2RCT_A_g12','1R2RCT_A_g13','1R2RCT_A_g23','1R2RCT_B',...
    '1R2RCT_B_g12','1R2RCT_B_g13','1R2RCT_B_g23','1R2RC_g12',...
    '1R2RC_g13','1R2RC_g23','1R2TCR','1R2TCRT','1R2TCRT_g12',...
    '1R2TCRT_g13','1R2TCRT_g23','1R2TCR_g12','1R2TCR_g13','1R2TCR_g23',...
    '1RT2RCR','1RT2RCRT','1RT2RCRT_g12','1RT2RCRT_g13',...
    '1RT2RCRT_g23','1RT2RCR_g12','1RT2RCR_g13','1RT2RCR_g23',...
    '1RT2RTCRT_A','1RT2RTCRT_A_g12','1RT2RTCRT_A_g13',...
    '1RT2RTCRT_A_g23','1RT2RTCRT_B','1RT2RTCRT_B_g12',...
    '1RT2RTCRT_B_g13','1RT2RTCRT_B_g23','1RT2TC','1RT2TCRT_A',...
    '1RT2TCRT_A_g12','1RT2TCRT_A_g13','1RT2TCRT_A_g23','1RT2TCRT_B',...
    '1RT2TCRT_B_g12','1RT2TCRT_B_g13','1RT2TCRT_B_g23','1RT2TC_g12',...
    '1RT2TC_g13','1RT2TC_g23','2R3RTC','2R3RTCRT','2R3RTCRT_g12',...
    '2R3RTCRT_g13','2R3RTCRT_g23','2R3RTC_g12','2R3RTC_g13',...
    '2R3RTC_g23','2RT3RC','2RT3RCR','2RT3RCR_g12','2RT3RCR_g13',...
    '2RT3RCR_g23','2RT3RCT_A','2RT3RCT_A_g12','2RT3RCT_A_g13',...
    '2RT3RCT_A_g23','2RT3RCT_B','2RT3RCT_B_g12','2RT3RCT_B_g13',...
    '2RT3RCT_B_g23','2RT3RC_g12','2RT3RC_g13','2RT3RC_g23',...
    '2RT3RTCRT','2RT3RTCRT_g12','2RT3RTCRT_g13','2RT3RTCRT_g23',...
    '2T3RCR','2T3RCRT','2T3RCRTP','2T3RCRTP_g12','2T3RCRTP_g13',...
    '2T3RCRTP_g23','2T3RCRT_g12','2T3RCRT_g13','2T3RCRT_g23',...
    '2T3RCR_g12','2T3RCR_g13','2T3RCR_g23','2T3RCTP','2T3RCTP_g12',...
    '2T3RCTP_g13','2T3RCTP_g23','2T3RTCR','2T3RTCR_g12',...
    '2T3RTCR_g13','2T3RTCR_g23','arm','articulated','articulated',...
    'articulated_g12','articulated_g13','articulated_g23','cars1',...
    'cars10','cars10_g12','cars10_g13','cars10_g23','cars2','cars2B',...
    'cars2B_g12','cars2B_g13','cars2B_g23','cars2_06','cars2_06_g12',...
    'cars2_06_g13','cars2_06_g23','cars2_07','cars2_07_g12',...
    'cars2_07_g13','cars2_07_g23','cars3','cars3_g12','cars3_g13',...
    'cars3_g23','cars4','cars5','cars5_g12','cars5_g13','cars5_g23',...
    'cars6','cars7','cars8','cars9','cars9_g12','cars9_g13',...
    'cars9_g23','dancing','head','kanatani1','kanatani2','kanatani3',...
    'people1','people2','three-cars','three-cars_g12',...
    'three-cars_g13','three-cars_g23','truck1','truck2','two_cranes',...
    'two_cranes_g12','two_cranes_g13','two_cranes_g23'...
    };
verbose = true
alphas = [20:10:100, 100:100:1000];
params = {...
    'numreps', .2, ...
    'affine', true, ...
    'rAlphas', alphas, ...
    'pLambdas', [1e-4, 1e-5, 1e-6, 1e-7, 1e-8], ...
    'pTols', [1, 1e-1, 1e-2, 1e-3, 1e-4], ...
    };
dataparams = {};
algos = [false, true, true, false];

%% SETUP
[savefile] = setup_save('param_hopkins');

%% EXPERIMENT
exp_dataset()

%% POST PROCESS
post_process();

%% SAVING
save(savefile)
