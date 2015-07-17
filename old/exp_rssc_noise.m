clean;

%% PARAMS
repeats = 50
dataset = 1
verbose = true
subsets = 3
params = {'hAlphas', []}
noises = [0.0:0.01:0.1]

%% SETUP
[savefile] = setup_save(['rssc_noise_vs_err', num2str(round(rand() * 100000))]);

%% GET PARAMS
[ sAlphas, rAlphas, hAlphas, hReps, pReps, pLambdas, pTols ] = ...
    algo_param(params{:});
[~, ~, N, d, n, D, noise, cos ] = get_data(dataset, subsets);

%% EXPERIMENT
fprintf('== %s ==\n%d Experiments with N=%d, n=%d, d=%d, D=%d and multiple noises\n', ...
    savefile, repeats, N, n, d, D)

noises = repmat(noises, 1, repeats);
parfor i = [1:length(noises)]
    fprintf('Experiment %d: ', i)
    [x, labels] = get_data(dataset, subsets, 'noise', noises(i));
    [err(:, i), mut(:, i), dur(:, i), pred(:, :, i), cs{i}, rep{i}, names{i}] ...
        = experiment(x, labels, n, sAlphas, rAlphas, hAlphas, hReps, pReps, pLambdas, pTols);
    fprintf('\n')
end

%% POST PROCESS
post_process();

%% SAVING
save(savefile)