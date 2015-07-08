clean;

%% PARAMS
repeats = 20
dataset = 2
verbose = true
subsets = [2:10]
params = {'hReps', 1e10};

%% SETUP
[savefile] = setup_save(['duration', num2str(round(rand() * 100000))]);

%% GET PARAMS
[ sAlphas, rAlphas, hAlphas, hReps, pReps, pLambdas, pTols ] = ...
    algo_param(params{:});
[ ~, ~, N, d, n, D, noise, cos ] = get_data(dataset, subsets(1));

%% EXPERIMENT
fprintf('==%s==\n %d Experiments with N=%d, n=%d, d=%d, D=%d and noise=%f\n', ...
    savefile, repeats, N, n, d, D, noise)

subsets = repmat(subsets, 1, repeats);
for i = 1:length(subsets)
    fprintf('Experiment %d: ', i)
    [ x, labels, N, d, n, D, noise, cos ] = get_data(dataset, subsets(i));
    hReps = N;
    [err(:, i), mut(:, i), dur(:, i), ~, cs{i}, rep{i}, names{i}] = experiment(x, labels, n, sAlphas, rAlphas, hAlphas, hReps, pReps, pLambdas, pTols);
    fprintf('\n')
end

%% POST PROCESS
post_process();

%% SAVING
save(savefile)
