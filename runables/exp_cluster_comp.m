function savefile = cluster_comp( dataset, dataparams, repeats )
%EXPERIMENT 
%   Example use: workspace; clean; savefile=exp_cluster_comp({1, 2, 'cars1'}, {'Ni', 3}, 2);
%   dataset = cell array with dataset descriptions, e.g. {1, 2, 'cars1'}
%   dataparams = description for generation of data (dataset 1)

%% PARAMS
verbose = true
params = {'sAlphas', [5], ...
    'rAlphas', [50], ...
    'hAlphas', [50], ...
    'pReps', [.1] ...
    };

%% SETUP
[savefile] = setup_save('clustering_comp');

%% EXPERIMENT
exp_dataset()

%% POST PROCESS
post_process();

%% SAVING
save(savefile)
