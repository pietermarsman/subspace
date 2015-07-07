clean;
warning('off', 'MATLAB:mir_warning_maybe_uninitialized_temporary')

%% PARAMS
repeats = 2
dataset = 2
verbose = true
subsets = 2
params = {'sAlphas', [10:10:100]};

%% SETUP
[savefile] = setup_save(['clustering_param', num2str(round(rand() * 100000))]);

%% GET PARAMS
[ sAlphas, rAlphas, hAlphas, hReps, pReps, pLambdas, pTols ] = ...
    algo_param(params{:});
[ ~, ~, N, d, n, D, noise, cos ] = get_data(dataset, subsets);

%% EXPERIMENT
fprintf('==%s==\n %d Experiments with N=%d, n=%d, d=%d, D=%d and noise=%s\n', ...
    savefile, repeats, N, n, d, D, noise)

for i = [1:repeats]
    fprintf('Experiment %d: ', i)
    [ x, labels, N, d, n, D, noise, cos ] = get_data(dataset, subsets);
    [err(:, i), mut(:, i), dur(:, i), pred(:, :, i), cs{i}, rep{i}, names{i}] = experiment(x, labels, n, sAlphas, rAlphas, hAlphas, hReps, pReps, pLambdas, pTols);
    fprintf('\n')
end

%% POST PROCESS
post_process();

%% SAVING
save(savefile)
