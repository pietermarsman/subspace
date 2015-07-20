function savefile = exp_cluster_comp_hopkins( repeats )
%EXPERIMENT 
%   Example use: workspace; clean; savefile=exp_cluster_comp({1, 2, 'cars1'}, {'Ni', 3}, 2);
%   dataset = cell array with dataset descriptions, e.g. {1, 2, 'cars1'}
%   dataparams = description for generation of data (dataset 1)

%% PARAMS
dataset = load('datasets/hopkins_names')
dataset = dataset.dataset;
dataparams = {};
verbose = true
params = {'sAlphas', [800], ...
    'affine', true, ...
    'sRho', 0.7, ...
    'rAlphas', [50, 900], ...
    'rLambda', 1e-4, ...
    'rTol', 1e-4, ...
    'hAlphas', [50, 900], ...
    'pLambdas', 1e-4, ...
    'pTols', 1e-4 ...
    };
algos = true(1, 4);

%% SETUP
[savefile] = setup_save('clustering_comp_hopkins');

%% EXPERIMENT
exp_dataset()

%% POST PROCESS
post_process();

%% SAVING
clearvars cs
save(savefile)
