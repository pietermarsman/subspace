function savefile = exp_cluster_comp_gen( dataparams, repeats )
%EXPERIMENT 
%   Example use: workspace; clean; savefile=exp_cluster_comp({1, 2, 'cars1'}, {'Ni', 3}, 2);
%   dataset = cell array with dataset descriptions, e.g. {1, 2, 'cars1'}
%   dataparams = description for generation of data (dataset 1)

%% PARAMS
dataset = {1}
verbose = true
params = {'sAlphas', [20], ...
    'rAlphas', [1.05, 1.8], ...
    'rLambda', 1e-4, ...
    'rTol', 1e-3, ...
    'hAlphas', [1.05, 1.8], ...
    'pLambdas', 1e-4, ...
    'pTols', 1e-3 ...
    };
algos = true(1, 4);

%% SETUP
[savefile] = setup_save('clustering_comp_gen');

%% EXPERIMENT
exp_dataset()

%% POST PROCESS
post_process();

%% SAVING
clearvars cs
save(savefile)
