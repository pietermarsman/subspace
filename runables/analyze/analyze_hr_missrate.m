clean

%% Load data
% name = 'data/clustering_comp_gen_7361656695.mat'; genlibsub = load(name, 'rep', 'names', 'pred'); % genlibsub
% name = 'data/clustering_comp_yale3_7361955833.mat'; yale = load(name, 'rep', 'names', 'pred'); yale.rep(5) = []; yale.pred(5) = []; % Yale Ni=3
% name = 'data/clustering_comp_yale_7361656697.mat'; yale = load(name, 'rep', 'names', 'pred'); % Yale Ni=5
% name = 'data/clustering_comp_hopkins_7361656698.mat'; hopkins = load(name, 'rep', 'names', 'pred'); hopkins.rep(99) = []; hopkins.pred(99) = [];% Hopkins

name = 'data/exp_representatives_genlinsub_noise'; datasets{1} = load(name); datasets{1}.name = 'Generated linear subspaces (\epsilon^2 = 0.1)';
name = 'data/exp_representatives_genlinsub_nonoise'; datasets{2} = load(name); datasets{2}.name = 'Generated linear subspaces (\epsilon^2 = 0.0)';
name = 'data/exp_representatives_eyb'; datasets{3} = load(name); datasets{3}.name = 'Extended Yale B';
name = 'data/exp_representatives_hopkins4'; datasets{4} = load(name); datasets{4}.name = 'Hopkins 155';

%% Information
save_pre = 'representatives_'
dir = 'results'

%% PROCESSING

dataset_i = 0;
for dataset = datasets
    dataset_i = dataset_i + 1
    dataset = dataset{1};
%     rssc_i = find(cellfun(@(x) length(strfind(x,'RSSC_rep')) > 0, dataset.names));
%     hssc_i = find(cellfun(@(x) length(strfind(x,'HSSC_rep')) > 0, dataset.names));
%     selection = [rssc_i(2), hssc_i(2)];
    repeats = length(dataset.rep);
    for i = 1:repeats;
        N = size(dataset.pred{i}, 2);
%         dataset.rep{i} = dataset.rep{i}(selection);
%         rssc_repInd = dataset.rep{i}{1};
%         nReps = length(rssc_repInd);
        
%         len = length(dataset.rep{i}{2});
%         dataset.rep{i}{2}([1:2:len, 2:2:len]) = dataset.rep{i}{2};
        if ~ischar(dataset.rep{i})
            repp = rep2mat(dataset.rep{i}, N);
            half = size(repp, 1) / 2;
            for a_i = 1:half
                if ~exist('acc') || length(acc) < dataset_i || length(acc{dataset_i}) < a_i
                    acc{dataset_i}{a_i}.pospos = 0;
                    acc{dataset_i}{a_i}.posneg = 0;
                    acc{dataset_i}{a_i}.negneg = 0;
                    acc{dataset_i}{a_i}.N = 0;
                    acc{dataset_i}{a_i}.reps = 0;
                    idx_pos{dataset_i}{a_i} = [];
                end
                r = repp([a_i, half + a_i], :);
                acc{dataset_i}{a_i}.pospos = acc{dataset_i}{a_i}.pospos + sum(sum(r == -1, 1) == 0);
                acc{dataset_i}{a_i}.posneg = acc{dataset_i}{a_i}.posneg + sum(and(r(1, :) == -1, r(2, :) >= 0));
                acc{dataset_i}{a_i}.negneg = acc{dataset_i}{a_i}.negneg + sum(sum(r == -1, 1) == 2);
                acc{dataset_i}{a_i}.N = acc{dataset_i}{a_i}.N + size(r, 2);
                acc{dataset_i}{a_i}.reps = acc{dataset_i}{a_i}.reps + sum(r(1, :) > -1) / size(r, 2) / repeats;
                new_r =  r(:, sum(r == -1, 1) == 0);
                idx_pos{dataset_i}{a_i} = [idx_pos{dataset_i}{a_i}; new_r'];
            end
        end
    end
end
fprintf('\n')

%% SELECTION
% Representatives of HSR are not sorted but concatenated. Therefore it is 
% assumed that the first half of the representatives are from one subset
% and the second half from the other. But this is actually not true and
% some representatives are threaded as comming from the wrong subset. These
% typically are in the corners were no other datapoints are. They are
% removed. Only very few of the representatives are removed. 
% for i = 1:length(idx_pos)
%     before = length(idx_pos{i});
%     idx = idx_pos{i};
%     idx = idx(~(idx(:, 1) < 0.1 & idx(:, 2) > 0.9), :);
%     idx = idx(~(idx(:, 1) > 0.9 & idx(:, 2) < 0.1), :);
%     idx_pos{i} = idx;
%     fprintf('Removed %d / %d because of HSR concatenating representatives\n', ...
%         before-length(idx_pos{i}), before);
% end

%% Correlation
close all

for dataset_i = 1:length(idx_pos)
    xvalues = cellfun(@(x) x.reps, acc{dataset_i}) * 100; %datasets{dataset_i}.alpha;
    c = [];
    accuracy = [];
    precision = [];
    mu = [];
    for a_i = 1:length(idx_pos{dataset_i})
        pos = idx_pos{dataset_i}{a_i};
        err = pos(:, 1) - pos(:, 2);
        stat = acc{dataset_i}{a_i};
        % Correlation
        c = [c, corr(pos(:, 1), pos(:, 2))];
        % Accuracy
        accuracy = [accuracy, (stat.pospos + stat.negneg) / stat.N];
        % Precision
        precision = [precision, stat.pospos / (stat.pospos + stat.posneg)];
        % Error
        mu = [mu, mean(err)];
    end
    figure(dataset_i)
    hold on;
    plot(xvalues, c)
    plot(xvalues, accuracy)
    plot(xvalues, precision)
    legend('Correlation', 'Accuracy', 'Precision', 'Location', 'SouthEast');
    beautyplot('% Representatives', 'Measure', '', false, false);
    xlim([0, 100])
    ylim([0, 1])
    savefigure(dir, [save_pre, datasets{dataset_i}.name])
end

%% Error
diary_file = [dir, '/', save_pre, 'stats.txt'];
delete(diary_file)
diary(diary_file)
diary on

for dataset_i = 1:length(idx_pos)
    for alpha_i = 1:length(idx_pos{dataset_i})
        idx = idx_pos{dataset_i}{alpha_i};
        err = idx(:, 1) - idx(:, 2);
        mu = mean(err);
        [~, p, ~, stat] = ttest(err);
        dat = datasets{dataset_i};
        fprintf('%f, %f, %f : %s (%d)\n', p, stat.tstat, mu, dat.name, dat.alpha(alpha_i)) 
    end
end
diary off