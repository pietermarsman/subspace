function savefile = exp_cluster_noisecos( dataset, dataparams, repeats )
%EXPERIMENT 
%   Example use: workspace; clean; savefile=exp_cluster_noisecos({1, 2, 'cars1'}, {}, 2);
%   dataset = cell array with dataset descriptions, e.g. {1, 2, 'cars1'}
%   dataparams = description for generation of data (dataset 1)

%% PARAMS
verbose = true
params = {'sAlphas', [5], ...
    'rAlphas', [50], ...
    'hAlphas', [50], ...
    'pReps', [.1] ...
    };
cosses = [0:.1:1];
noises = [0:.001:0.01]

%% SETUP
[savefile] = setup_save(['clustering_param', num2str(round(rand() * 100000))]);

%% EXPERIMENT
fprintf('==%s==', savefile)
dataset = repmat(dataset, 1, repeats);
for i = 1:length(dataset)
    for cos = cosses
        for noise = noises
            dataparams = {dataparams{:}, 'cos', cos, 'noise', noise}
            [ x, labels, N, d, n, D, noise, cos ] = get_data(dataset{i}, dataparams{:});
            fprintf('\nExperiment %d/%d with N=%d, n=%d, d=%d, D=%d and noise=%s\n> ', ...
                i, length(dataset), N, n, d, D, noise)
            [err(:, i), mut(:, i), dur(:, i), pred{i}, cs{i}, rep{i}, names{i}] = experiment(x, labels, n, params{:});
        end
    end
end

%% POST PROCESS
post_process();

%% SAVING
save(savefile)
