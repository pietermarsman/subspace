function savefile = exp_cluster_comp_yale( dataparams, repeats )
%EXPERIMENT 
%   Example use: workspace; clean; savefile=exp_cluster_comp({1, 2, 'cars1'}, {'Ni', 3}, 2);
%   dataset = cell array with dataset descriptions, e.g. {1, 2, 'cars1'}
%   dataparams = description for generation of data (dataset 1)

%% PARAMS
dataset = {2}
verbose = true
params = {'sAlphas', [20], ...
    'sOutlier', true, ...
    'rAlphas', [5, 120], ...
    'rLambda', 1e-7, ...
    'rTol', 1e-3, ...
    'hAlphas', [5, 120], ...
    'pLambdas', 1e-7, ...
    'pTols', 1e-3 ...
    };
algos = [false, true, false, true];

%% SETUP
[savefile] = setup_save('clustering_comp_yale');

%% EXPERIMENT
exp_dataset()

%% POST PROCESS
post_process();

%% SAVING
clearvars cs
save(savefile)
