function savefile = param_hopkins( repeats )
%EXPERIMENT Find parameters that work well for yale dataset
%   Example use: workspace; clean; savefile=param_hopkins({}, 2);
%   repeats = number of repeats

%% PARAMS
dataset = load('datasets/hopkins_names')
dataset = dataset.dataset;
verbose = true
alphas = [20:10:90, 100:100:1000];
params = {...
    'numreps', .2, ...
    'affine', true, ...
    'rAlphas', alphas, ...
    'rLambda', 1e-4, ...
    'rTol', 1e-4, ...
    };
dataparams = {};
algos = [false, true, false, false];

%% SETUP
[savefile] = setup_save('param_hopkins');

%% EXPERIMENT
exp_dataset()

%% POST PROCESS
post_process();

%% SAVING
save(savefile)
