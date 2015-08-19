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
numreps = [.05:.05:.95];
params = {
    'sAlphas', [20], ...
    'rAlphas', [1.05, 1.8] ...
    'rLambda', 1e-4, ...
    'rTol', 1e-3, ...
    'hAlphas', [1.05, 1.8], ...
    'pLambdas', 1e-4, ...
    'pTols', 1e-3, ...
    'numreps', numreps, ...
    };
algos = true(1, 4)

%% SETUP
savefile = setup_save(['exp_rep']);

%% EXPERIMENT
exp_dataset()

%% POST PROCESS
post_process();

%% SAVING
save(savefile)

end