clean;

%% PARAMS
repeats = 10
dataset = 1
verbose = true
subsets = 3
params = {'hAlphas', [], 'pReps', []}
dataparams = {'noise', 0.001};
cosses = [0.0:0.1:1.0]

%% SETUP
[savefile] = setup_save(['rssc_cosses', num2str(round(rand() * 100000))]);

%% GET PARAMS
[ sAlphas, rAlphas, hAlphas, hReps, pReps, pLambdas, pTols ] = ...
    algo_param(params{:});
[~, ~, N, d, n, D, noise, cos ] = get_data(dataset, subsets, dataparams{:});

%% EXPERIMENT
fprintf('== %s ==\n%d Experiments with N=%d, n=%d, d=%d, D=%d and noise=%d\n', ...
    savefile, repeats, N, n, d, D, noise)

cosses = repmat(cosses, 1, repeats);
parfor i = [1:length(cosses)]
    fprintf('Experiment %d: ', i)
    [x, labels] = get_data(dataset, subsets, 'cos', cosses(i), dataparams{:});
    [err(:, i), mut(:, i), dur(:, i), pred(:, :, i), cs{i}, rep{i}, names{i}] ...
        = experiment(x, labels, n, sAlphas, rAlphas, hAlphas, hReps, pReps, pLambdas, pTols);
    fprintf('\n')
end

%% POST PROCESS
post_process();

%% SAVING
save(savefile)