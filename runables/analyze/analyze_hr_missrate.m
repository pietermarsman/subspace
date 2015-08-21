clean

%% Load data
name = 'data/clustering_comp_gen_7361656695.mat'; genlibsub = load(name, 'rep', 'names', 'pred'); % genlibsub
name = 'data/clustering_comp_yale3_7361955833.mat'; yale = load(name, 'rep', 'names', 'pred'); yale.rep(5) = []; yale.pred(5) = []; % Yale Ni=3
% name = 'data/clustering_comp_yale_7361656697.mat'; yale = load(name, 'rep', 'names', 'pred'); % Yale Ni=5
name = 'data/clustering_comp_hopkins_7361656698.mat'; hopkins = load(name, 'rep', 'names', 'pred'); hopkins.rep(99) = []; hopkins.pred(99) = [];% Hopkins

%% Information
save_pre = 'representatives_'
dir = 'results'
datasets = {'Generated linear subspaces', 'Hopkins 155', 'Extended Yale B'};

%% PROCESSING

dataset_i = 1;
for dataset = {genlibsub, hopkins, yale}
    dataset = dataset{1};
    idx_pos{dataset_i} = [];
    acc{dataset_i}.pospos = 0;
    acc{dataset_i}.posneg = 0;
    acc{dataset_i}.N = 0;
    rssc_i = find(cellfun(@(x) length(strfind(x,'RSSC_rep')) > 0, dataset.names));
    hssc_i = find(cellfun(@(x) length(strfind(x,'HSSC_rep')) > 0, dataset.names));
    selection = [rssc_i(2), hssc_i(2)];
    for i = 1:length(dataset.rep)
        N = size(dataset.pred{i}, 2);
        dataset.rep{i} = dataset.rep{i}(selection);
        rssc_repInd = dataset.rep{i}{1};
        nReps = length(rssc_repInd);
        
        len = length(dataset.rep{i}{2});
        dataset.rep{i}{2}([1:2:len, 2:2:len]) = dataset.rep{i}{2};
        repp = rep2mat(dataset.rep{i}, N);
        acc{dataset_i}.pospos = acc{dataset_i}.pospos + sum(sum(repp == -1, 1) == 0);
        acc{dataset_i}.posneg = acc{dataset_i}.posneg + sum(and(repp(1, :) == -1, repp(2, :) >= 0));
        acc{dataset_i}.N = acc{dataset_i}.N + size(repp, 2);
        new_repp =  repp(:, sum(repp == -1, 1) == 0);
        idx_pos{dataset_i} = [idx_pos{dataset_i}; new_repp'];
    end
    dataset_i = dataset_i + 1;
end
fprintf('\n')

%% SELECTION
% Representatives of HSR are not sorted but concatenated. Therefore it is 
% assumed that the first half of the representatives are from one subset
% and the second half from the other. But this is actually not true and
% some representatives are threaded as comming from the wrong subset. These
% typically are in the corners were no other datapoints are. They are
% removed. Only very few of the representatives are removed. 
for i = 1:length(idx_pos)
    before = length(idx_pos{i});
    idx = idx_pos{i};
    idx = idx(~(idx(:, 1) < 0.1 & idx(:, 2) > 0.9), :);
    idx = idx(~(idx(:, 1) > 0.9 & idx(:, 2) < 0.1), :);
    idx_pos{i} = idx;
    fprintf('Removed %d / %d because of HSR concatenating representatives\n', ...
        before-length(idx_pos{i}), before);
end

%% Correlation
diary_file = [dir, '/', save_pre, 'stats.txt'];
delete(diary_file)
diary(diary_file)
diary on

fprintf('\n== Correlation == \n')
for dataset_i = 1:length(idx_pos)
    pos = idx_pos{dataset_i};
    c = corr(pos(:, 1), pos(:, 2));
    fprintf('%30s : %f\n', datasets{dataset_i}, c);
end

%% Error statistics
fprintf('== Error statistics ==\n')
fprintf('%30s   %8s, %8s, %8s, %8s, %8s, %8s\n', '', 'p-value', 'kstat', 'mean', 'std', 'accuracy', 'precision')
for dataset_i = 1:length(idx_pos)
    err = idx_pos{dataset_i}(:, 1) - idx_pos{dataset_i}(:, 2);
    [h1, p1, kstat] = kstest(zscore(err));
    figure(dataset_i)
    hold on;
    cdfplot(zscore(err));
    cdfplot(zscore(randn(10000, 1)));
    xlim([-5, 5])
    accuracy = acc{dataset_i}.pospos / acc{dataset_i}.N;
    precision = acc{dataset_i}.pospos / (acc{dataset_i}.pospos + acc{dataset_i}.posneg);
    legend('Z-score error', 'Normal distribution', 'Location', 'SouthEast');
    fprintf('%30s : %f, %f, %f, %f, %f, %f\n', datasets{dataset_i}, p1, kstat, mean(err), std(err), accuracy, precision);
    beautyplot('x', 'F(x)', '', false, false);
    dataset_savename = strjoin(strsplit(lower(datasets{dataset_i})), '_');
    savefigure(dir, [save_pre, 'error_', dataset_savename])
end

diary off

%% PLOTTING
figure(4)
x_bias = -0.01;
for dataset_i = 1:length(idx_pos)
    bars = [];
    std_bars = [];
    median_bars = [];
    range = [0.1:0.2:1.0];
    for to = range
        from = to - 0.1;
        idx = (idx_pos{dataset_i}(:, 1) > from) & (idx_pos{dataset_i}(:, 1) < to);
        data = idx_pos{dataset_i}(idx, 2:end);
        bars = [bars; mean(data, 1)];
        std_bars = [std_bars; std(data, [], 1)];
        median_bars = [median_bars; median(data)];
    end
    hold on
    errorbar(range+x_bias, bars, std_bars)
    x_bias = x_bias + 0.01;
end
ylim([0, 1])
xlim([0, 1])
legend(datasets{:}, 'Location', 'NorthWest')

title('Index of representative in SMRS and HSR');
beautyplot('SMRS index', 'HSR index', '', false, false);

savefigure(dir, [save_pre, 'repind']);