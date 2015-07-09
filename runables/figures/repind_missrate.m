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

for i = [1:repeats]
    fprintf('Experiment %d: ', i)
    [ x, labels, N, d, n, D, noise, cos ] = get_data(dataset, subsets, dataparams{:});
    [err(:, i), mut(:, i), dur(:, i), pred(:, :, i), cs{i}, rep{i}, names{i}] = experiment(x, labels, n, sAlphas, rAlphas, hAlphas, hReps, pReps, pLambdas, pTols);
end

%% POST PROCESS
post_process();

%% SAVING
save(savefile)

%% PROCESSING
idx_missing = [];
for i = [1:repeats]
    rssc_repInd = rep{i}{1};
    nReps = length(rssc_repInd);
    k = 1;
    for id = rssc_repInd
        missing = [k / size(rssc_repInd, 2)];
        for j = 1:length(names)
            maxReps = min(nReps, length(rep{i}{j}));
            missing = [missing, sum(rep{i}{j}(1:maxReps) == id) == 0];
        end
        idx_missing = [idx_missing; missing];
        k = k + 1;
    end
end
fprintf('\n')

%% PLOTTING
figure(2)
bars = [];
std_bars = [];
range = [0.1:0.1:1.0];
for to = range
    from = to - 0.1;
    idx = (idx_missing(:, 1) > from) & (idx_missing(:, 1) < to);
    bars = [bars; mean(idx_missing(idx, 2:end), 1)];
    std_bars = [std_bars; std(idx_missing(idx, 2:end), 1, 1)];
end
hold on
plot(repmat(range, length(names), 1)', bars)
% plot(repmat(range, length(names), 1)', bars, 'Color', colors(length(names), :));
% plot(repmat(range, length(names), 1)', bars+std_bars, 'Color', colors(length(names, :)))
ylim([0, 1]);
suptitle('Part of the representatives not found by HSSC');
title(sprintf('N=%d, d=%d, S=%d, D=%d, repeats=%d, noise=%.3f, cos=%.3f', N, d, subsets, D, repeats, noise, cos));
legend(names)
beautyplot('RSSC repInd place', 'Part not found', '', false);

dir = 'fig';
name = [dir, '/repind'];
mkdir dir;
savefig(name)
export_fig(name, '-pdf', '-transparent')
