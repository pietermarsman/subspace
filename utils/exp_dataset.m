fprintf('==%s==', savefile)
dataset = repmat(dataset, 1, repeats);

for i = 1:length(dataset)
    try
        [ x, labels, N, d, n, D, noise, cos ] = get_data(dataset{i}, dataparams{:});
        fprintf('\nExperiment %d/%d with N=%d, n=%d, d=%d, D=%d and noise=%d\n> ', ...
            i, length(dataset), N, n, d, D, noise)
        [err(:, i), mut(:, i), dur(:, i), pred{i}, cs{i}, rep{i}, names{i}] ...
            = experiment(x, labels, n, algos, params{:});
    catch ME
        warning(ME.message)
        err(:, i) = -1;
        mut(:, i) = -1;
        dur(:, i) = -1;
        pred{i} = ME.message;
        cs{i} = ME.message;
        rep{i} = ME.message;
        names{i}{1} = ME.message;
    end
end