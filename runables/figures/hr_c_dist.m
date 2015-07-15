clean;

%% PARAMS
repeats = 2
dataset = 2
verbose = true
subsets = 2
params = {'sAlphas', [], ...
    'rAlphas', [5], ...
    'hAlphas', [5], ...
    'hReps', [], ...
    'pReps', []};

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

%% ANALYZE
corr = [];
fros = [];
l2s = [];
l21s = [];
for i = [1:repeats]
    a = cs{i}{1};
    b = cs{i}{4};
    diff = a - b;
    r = corrcoef([reshape(a, [], 1), reshape(b, [], 1)]);
    corr = [corr, r(1, 2)];
    fros = [fros, norm(diff, 'fro')];
    l2s = [l2s, norm(diff, 2)];
    l21s = [l21s, sum(sqrt(sum((diff .* diff).^2, 2)), 1)];
end
fprintf('Correlation(a,b): mean=%f, std=%f, std_error=%f\n', mean(corr), ...
    std(corr), std(corr) / sqrt(length(corr)));
fprintf('Frobenius norm(a-b): mean=%f, std=%f, std_error=%f\n', mean(fros), ...
    std(fros), std(fros) / sqrt(length(fros)));
fprintf('L2 norm(a-b): mean=%f, std=%f, std_error=%f\n', mean(l2s), ...
    std(l2s), std(l2s) / sqrt(length(l2s)));
fprintf('L21 norm(a-b): mean=%f, std=%f, std_error=%f\n', mean(l21s), ...
    std(l21s), std(l21s) / sqrt(length(l21s)));

%% SAVING
save(savefile)
