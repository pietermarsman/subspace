clean;

%% PARAMS
repeats = 1
dataset = 1
verbose = true
subsets = 3
params = {'sAlphas', [], ...
    'rAlphas', [5], ...
    'hAlphas', [], ...
    'pReps', []};
dataparams = {'N', 100, 'noise', 0.0, 'cos', 0.0, 'di', 1, 'D', 3};

%% SETUP
[savefile] = setup_save(['clustering_param', num2str(round(rand() * 100000))]);

%% GET PARAMS
[ sAlphas, rAlphas, hAlphas, hReps, pReps, pLambdas, pTols ] = ...
    algo_param(params{:});
[ ~, ~, N, d, n, D, noise, cos ] = get_data(dataset, subsets, dataparams{:});

%% EXPERIMENT
fprintf('==%s==\n %d Experiments with N=%d, n=%d, d=%d, D=%d and noise=%s\n', ...
    savefile, repeats, N, n, d, D, noise)

i = 1;
fprintf('Experiment %d: ', i)
[ x{i}, labels{i}, ~, ~, ~, ~, ~, ~ ] = get_data(dataset, subsets, dataparams{:});
[err(:, i), mut(:, i), dur(:, i), ~, cs{i}, rep{i}, names{i}] = ...
    experiment(x{i}, labels{i}, n, sAlphas, rAlphas, hAlphas, hReps, pReps, pLambdas, pTols);
fprintf('\n')
    
%% POST PROCESS
post_process();

%% SAVING
save(savefile)

%% PLOT
hold on;
scatter3(x{1}(1, :), x{1}(2, :), x{1}(3, :))
scatter3(x{1}(1, rep{1}{1}), x{1}(2, rep{1}{1}), x{1}(3, rep{1}{1}))
view(3)
