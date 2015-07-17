fprintf('==%s==', savefile)
dataset = repmat(dataset, 1, repeats);

for i = 1:length(dataset)
    [ x, labels, N, d, n, D, noise, cos ] = get_data(dataset{i}, dataparams{:});
    fprintf('\nExperiment %d/%d with N=%d, n=%d, d=%d, D=%d and noise=%s\n> ', ...
        i, length(dataset), N, n, d, D, noise)
    [err(:, i), mut(:, i), dur(:, i), pred{i}, cs{i}, rep{i}, names{i}] = experiment(x, labels, n, params{:});
end