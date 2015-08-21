clean

%% Load data
name = 'data/clustering_comp_gen_7361656695.mat'; genlibsub = load(name, 'dur', 'names'); % genlibsub
name = 'data/clustering_comp_yale3_7361955833.mat'; yale = load(name, 'dur', 'names'); yale.dur(:, 5) = []; % Yale Ni=3
% name = 'data/clustering_comp_yale_7361656697.mat'; yale = load(name, 'rep', 'names'); % Yale Ni=5
name = 'data/clustering_comp_hopkins_7361656698.mat'; hopkins = load(name, 'dur', 'names'); hopkins.dur(:, 99) = []; % Hopkins

%% Info
save_pre = 'duration'
dir = 'results'
datasets = {'Generated linear subspaces', 'Hopkins 155', 'Extended Yale B'};

ratio = [2, 1, 1];
position = [0 0 800 800];

%% Aggregate
dataset_i = 1;
for dataset = {genlibsub, hopkins, yale}
    dataset = dataset{1};
    rssc_i = find(cellfun(@(x) length(strfind(x,'RSSC_rep')) > 0, dataset.names));
    hssc_i = find(cellfun(@(x) length(strfind(x,'HSSC_rep')) > 0, dataset.names));
    selection = [rssc_i(2), hssc_i(2)];
    
    dur{dataset_i} = dataset.dur(selection, :);
    dataset_i = dataset_i + 1;
end

rssc_dur = cellfun(@(x) x(1, :), dur, 'UniformOutput', false);
hssc_dur = cellfun(@(x) x(2, :), dur, 'UniformOutput', false);

dur = [];
group = [];
for dataset_i = 1:length(rssc_dur)
    dur = [dur, hssc_dur{dataset_i} ./ rssc_dur{dataset_i}];
    group = [group, repmat(dataset_i, 1, length(rssc_dur{dataset_i}))];
end

%% Statistics
fprintf('Significant difference in duration\n');
for dataset_i = 1:length(rssc_dur)
    [p, ~] = kruskalwallis([rssc_dur{dataset_i}', ...
        hssc_dur{dataset_i}'], {'RSSC', 'HSSC'}, 'off');
    fprintf('%30s : %f\n', datasets{dataset_i}, p)
end

%% Plot
fig = figure(1)
boxplot(dur, group, 'labels', datasets)
beautyplot('', 'Duration HSR / SMRS', '', false, false);
set(fig, 'Position', position);
set(gca, 'PlotBoxAspectRatio', ratio)

savefigure(dir, save_pre);