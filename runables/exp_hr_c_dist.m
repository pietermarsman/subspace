function savefile = exp_hr_c_dist( dataset, dataparams )
%EXPERIMENT Coefficient matrix computation for RSSC and HSSC
%   Computes the coefficients once for each dataset
%   Analyze with analyze_hr_c_dist.m & analyze_hr_missrate.m
%   Example use: workspace; clean; savefile=exp_hr_c_dist({1, 2, 'cars1'}, {});
%   dataset = cell array with dataset descriptions, e.g. {1, 2, 'cars1'}
%   dataparams = description for generation of data (dataset 1)

%% PARAMS
repeats = 1
verbose = true
params = {...
    'rAlphas', [5], ...
    'hAlphas', [5] ...
    };

%% SETUP
[savefile] = setup_save('exp_hr_c_dist');

%% EXPERIMENT
exp_dataset()

%% POST PROCESS
post_process();

%% SAVING
save(savefile)

end