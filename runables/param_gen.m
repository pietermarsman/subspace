function savefile = param_gen(dataparams, repeats )
%EXPERIMENT Find parameters that work well for generated dataset
%   Example use: workspace; clean; savefile=param_gen({'Ni', 3}, 2);
%   dataparams = description for generation of data (dataset 1)
%   repeats = number of repeats

%% PARAMS
dataset = {1}
verbose = true
alphas = [2:9, 10:10:90, 100:100:1000];
params = {...
    'numreps', .1, ...
    'sAlphas', alphas, ...
    'rAlphas', [1.01, 1.05:0.05:1.5, 1.6:0.1:2.0], ...
    'rLambda', 1e-4, ...
    'rTol', 1e-3, ...
    'pLambdas', 1e-4, ...
    'pTols', 1e-3, ...
    };
algos = [false, true, true, false];

%% SETUP
[savefile] = setup_save('param_gen');

%% EXPERIMENT
exp_dataset()

%% POST PROCESS
post_process();

%% SAVING
save(savefile)
