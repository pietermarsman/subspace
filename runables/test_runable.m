function savefile = cluster_comp()
%EXPERIMENT 
%   Example use: workspace; clean; savefile=exp_cluster_comp({1, 2, 'cars1'}, {'Ni', 3}, 2);
%   dataset = cell array with dataset descriptions, e.g. {1, 2, 'cars1'}
%   dataparams = description for generation of data (dataset 1)

%% PARAMS
dataset = {1, 2, 'cars1'}
dataparams = {'N', 100}
verbose = true
repeats = 1
algos = [1, 1, 1, 1];
params = {};

%% SETUP
[savefile] = setup_save('test_runable');

%% EXPERIMENT
exp_dataset()

%% POST PROCESS
post_process();

%% SAVING
save(savefile)
