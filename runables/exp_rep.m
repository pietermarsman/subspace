function savefile = exp_rep( dataset, dataparams, repeats )
%EXPERIMENT Clustering with different number of representatives
%   Clusters all the datasets with different alphas and thus different
%   number of representatives. Usefull for comparing representatives 
%   clustering vs. not-representatives clustering vs SSSC clustering.
%   Analyze with analyze_rep_inout.m & analyze_rep_num.m
%   Example use: workspace; clean; savefile=exp_rep({1, 2, 'cars1'}, {}, 2);
%   dataset = cell array with dataset descriptions, e.g. {1, 2, 'cars1'}
%   dataparams = description for generation of data (dataset 1)

%% PARAMS
verbose = true
alphas = [2, 3, 4, 5, 10:10:100, 150, 200, 300];
params = {
    'sAlphas', [5], ...
    'rAlphas', alphas, ...
    'hAlphas', alphas, ...
    'pReps', [.1:.99:.9], ...
    };
dataparams = {};

%% SETUP
savefile = setup_save(['exp_hr_rep']);

%% EXPERIMENT
exp_dataset()

%% POST PROCESS
post_process();

%% SAVING
save(savefile)

end