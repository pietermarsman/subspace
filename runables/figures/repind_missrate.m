clean;

%% PARAMS
repeats = 20
dataset = 2
verbose = true
subsets = 10
params = {'sAlphas', [], ...
    'rAlphas', 25, ...
    'hAlphas', 25, ...
    'hReps', 64*10, ...
    'pReps', []};
dataparams = {};

%% SETUP
[savefile] = setup_save(['repind_missrate', num2str(round(rand() * 100000))]);

%% GET PARAMS
[ sAlphas, rAlphas, hAlphas, hReps, pReps, pLambdas, pTols ] = ...
    algo_param(params{:});
[ ~, ~, N, d, n, D, noise, cos ] = get_data(dataset, subsets, dataparams{:});

%% EXPERIMENT
fprintf('==%s==\n %d Experiments with N=%d, n=%d, d=%d, D=%d and noise=%s\n', ...
    savefile, repeats, N, n, d, D, noise)

parfor i = [1:repeats]
    fprintf('Experiment %d: ', i)
    [ x, labels, N, d, n, D, noise, cos ] = get_data(dataset, subsets, dataparams{:});
    [err(:, i), mut(:, i), dur(:, i), pred(:, :, i), cs{i}, rep{i}, names{i}] = experiment(x, labels, n, sAlphas, rAlphas, hAlphas, hReps, pReps, pLambdas, pTols);
end

%% POST PROCESS
post_process();

%% SAVING
save(savefile)


