clean;

%% PARAMS
repeats = 1
dataset = 1
verbose = true
subsets = 2
params = {'hAlphas', [], 'pReps', []}
cosses = [0.0:0.1:1.0]

%% SETUP
[savefile] = setup_save(['rssc_cosses', num2str(round(rand() * 100000))]);

%% GET PARAMS
[ sAlphas, rAlphas, hAlphas, hReps, pReps, pLambdas, pTols ] = ...
    algo_param(params{:});
[~, ~, N, d, n, D, noise, cos ] = get_data(dataset, subsets);

%% EXPERIMENT
fprintf('== %s ==\n%d Experiments with N=%d, n=%d, d=%d, D=%d and noise=%d\n', ...
    savefile, repeats, N, n, d, D, noise)

cosses = repmat(cosses, 1, repeats);
for i = [1:length(cosses)]
    fprintf('Experiment %d: ', i)
    [x, labels] = get_data(dataset, subsets, 'cos', cosses(i));
    [err(:, i), mut(:, i), dur(:, i), pred(:, :, i), cs{i}, rep{i}, names{i}] ...
        = experiment(x, labels, n, sAlphas, rAlphas, hAlphas, hReps, pReps, pLambdas, pTols);
    fprintf('\n')
end

%% POST PROCESS
post_process();

%% SAVING
save(savefile)