function savefile = param_yale(dataparams, repeats )
%EXPERIMENT Find parameters that work well for yale dataset
%   Example use: workspace; clean; savefile=param_yale({'Ni', 3}, 2);
%   dataparams = description for generation of data (dataset 1)
%   repeats = number of repeats

%% PARAMS
dataset = {2}
verbose = true
alphas = [10:10:100, 100:100:1000];
params = {...
    'rAlphas', alphas, ...
    };

%% SETUP
[savefile] = setup_save('param_yale');

%% EXPERIMENT
exp_dataset()

%% POST PROCESS
post_process();

%% SAVING
save(savefile)
