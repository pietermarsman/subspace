function savefile = exp_hr_noise( dataset, dataparams, repeats )
%EXPERIMENT 
%   Example use: workspace; clean; savefile=exp_hr_noise({1, 2, 'cars1'}, {}, 2);
%   dataset = cell array with dataset descriptions, e.g. {1, 2, 'cars1'}
%   dataparams = description for generation of data (dataset 1)

%% PARAMS
verbose = true
alphas = [2, 3, 4, 5, 10:10:100, 150, 200, 300];
params = {
    'rAlphas', alphas, ...
    'hAlphas', alphas, ...
    };
dataparams = {};
noises = [0:.001:.01];

%% SETUP
savefile = setup_save(['exp_hr_rep']);

%% EXPERIMENT
fprintf('==%s==', savefile)
dataset = repmat(dataset, 1, repeats);
for i = 1:length(dataset)
    for noise = noises
        dataparams = {dataparams{:}, 'noise', noise}
        [ x, labels, N, d, n, D, noise, cos ] = get_data(dataset{i}, dataparams{:});
        fprintf('\nExperiment %d/%d with N=%d, n=%d, d=%d, D=%d and noise=%s\n> ', ...
            i, length(dataset), N, n, d, D, noise)
        [err(:, i), mut(:, i), dur(:, i), pred{i}, cs{i}, rep{i}, names{i}] = experiment(x, labels, n, params{:});
    end
end

%% POST PROCESS
post_process();

%% SAVING
save(savefile)

end