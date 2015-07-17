function savefile = param_gen(dataparams, repeats )
%EXPERIMENT Find parameters that work well for generated dataset
%   Example use: workspace; clean; savefile=param_gen({'Ni', 3}, 2);
%   dataparams = description for generation of data (dataset 1)
%   repeats = number of repeats

%% PARAMS
dataset = {1}
verbose = true
alphas = [2:9, 10:10:100, 100:100:1000];
params = {'sAlphas', alphas, ...
    'rAlphas', alphas, ...
    'pReps', [.1] ...
    'pLambdas', [1e-4, 1e-5, 1e-6, 1e-7, 1e-8], ...
    'pTols', [1, 1e-1, 1e-2, 1e-3, 1e-4], ...
    };

%% SETUP
[savefile] = setup_save('clustering_param');

%% EXPERIMENT
exp_dataset()

%% POST PROCESS
post_process();

%% SAVING
save(savefile)
