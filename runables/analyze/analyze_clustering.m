clean
dir = 'fig'
name = 'data/param_hopkins_7361639569.mat';
load(name)

%% Selection
names = names(1:end-3);
names{17} = 'invalid';
names{18} = 'invalid'
selection = cellfun(@(x) strcmp(x(1:7), 'RSSC_no'), names);

names = names(selection);
err = err(selection, :);
mut = mut(selection, :);
dur = dur(selection, :);
rep = cell2mat(cellfun(@(x) cellfun(@length, x(selection)), rep, 'UniformOutput', false));
Ns = cellfun(@(x) size(x, 2), pred);
rep = rep ./ repmat(Ns, size(rep, 1), 1);
exp_N = length(names)

%% Information
tit = 'Hopkins155 - RSSC with non-representatives';
xlab = 'Alpha';
xvalues = alphas([1:8, 10:19]);
ratio = [2, 1, 1];
position = [0 0 800 800] ;

savetitle = lower(strjoin(strsplit(tit, ' '), ''))

%% Plot
angle = 90;

aFig = figure(1);
hold on
boxplot(err')
scatter(1:size(err, 1), mean(err, 2), 'b*')
beautyplot(xlab, 'Error rate', '', false)
title(tit);
set(gca, 'XTick', 1:length(xvalues))
set(gca, 'XTickLabel', xvalues)
set(aFig, 'Position', position);
set(gca, 'PlotBoxAspectRatio', ratio)
ylim([0, 1])
rotateticklabel(gca, angle)
name = [dir, '/', savetitle, '_error'];
savefig(name)
export_fig(name, '-pdf', '-transparent')

bFig = figure(2);
hold on
boxplot(mut')
scatter(1:size(mut, 1), mean(mut, 2), 'b*')
beautyplot(xlab, 'Mutual info', '', false)
title(tit);
set(gca, 'XTick', 1:length(xvalues))
set(gca, 'XTickLabel', xvalues)
set(bFig, 'Position', position);
set(gca, 'PlotBoxAspectRatio', ratio)
ylim([0, 1])
rotateticklabel(gca, angle)
name = [dir, '/', savetitle, '_mutual_info'];
savefig(name)
export_fig(name, '-pdf', '-transparent')

cFig = figure(3);
hold on
boxplot(dur')
scatter(1:size(dur, 1), mean(dur, 2), 'b*')
beautyplot(xlab, 'Duration', '', false)
title(tit);
ylim([0, max(max(dur))])
set(gca, 'XTick', 1:length(xvalues))
set(gca, 'XTickLabel', xvalues)
set(cFig, 'Position', position);
set(gca, 'PlotBoxAspectRatio', ratio)
rotateticklabel(gca, angle)
name = [dir, '/', savetitle, '_duration'];
savefig(name)
export_fig(name, '-pdf', '-transparent')

dFig = figure(4);
hold on

boxplot(rep')
scatter(1:size(rep, 1), mean(rep, 2), 'b*');
beautyplot(xlab, 'In-sample size', '', false)
title(tit);
ylim([0, max(max(rep))])
set(gca, 'XTick', 1:length(xvalues))
set(gca, 'XTickLabel', xvalues)
set(dFig, 'Position', position);
set(gca, 'PlotBoxAspectRatio', ratio)
rotateticklabel(gca, angle)
name = [dir, '/', savetitle, '_insamplesize'];
savefig(name)
export_fig(name, '-pdf', '-transparent')

%% Analyzes
clc;
fprintf('==Normality test==\n')
fprintf('\t\t  Error\t\tMutual info\tDuration\tIn-sample size\n')
for i = 1:length(names)
    [err_h, err_p] = kstest(err(i, :));
    [mut_h, mut_p] = kstest(mut(i, :));
    [dur_h, dur_p] = kstest(dur(i, :));
    [rep_h, rep_p] = kstest(rep(i, :));
    fprintf('%16s  %.5f \t%.5f \t%.5f \t%.5f\n', names{i}, err_p, mut_p, dur_p, rep_p);
end

fprintf('\n==Kruskal-Wallis test==\n')
[err_p, ~, err_stats] = kruskalwallis(err', xvalues, 'off');
[mut_p, ~, mut_stats] = kruskalwallis(mut', xvalues, 'off');
[dur_p, ~, dur_stats] = kruskalwallis(dur', xvalues, 'off');
[rep_p, ~, rep_stats] = kruskalwallis(rep', xvalues, 'off');
fprintf('Group medians differ for error (%.5f), mutual info (%.5f), duration (%.5f) and in-sample size (%.5f)\n', err_p, mut_p, dur_p, rep_p);

fprintf('\n==Pair wise testing==\n')
[~, err_best] = min(err_stats.meanranks);
[~, mut_best] = max(mut_stats.meanranks);
[~, dur_best] = min(dur_stats.meanranks);

err_c = multcompare(err_stats, 'display', 'off');
mut_c = multcompare(mut_stats, 'display', 'off');
dur_c = multcompare(dur_stats, 'display', 'off');
rep_c = multcompare(rep_stats, 'display', 'off');
err_cp = full(sparse(err_c(:, 1), err_c(:, 2), err_c(:, 6), exp_N, exp_N));
mut_cp = full(sparse(mut_c(:, 1), mut_c(:, 2), mut_c(:, 6), exp_N, exp_N));
dur_cp = full(sparse(dur_c(:, 1), dur_c(:, 2), dur_c(:, 6), exp_N, exp_N));
rep_cp = full(sparse(rep_c(:, 1), rep_c(:, 2), rep_c(:, 6), exp_N, exp_N));
err_cp = err_cp + err_cp';
mut_cp = mut_cp + mut_cp';
dur_cp = dur_cp + dur_cp';
rep_cp = rep_cp + rep_cp';

fprintf('\t\t\t\t\t\t   Median\tMean\n')
fprintf('Best error: \t\t%s\t=  %.3f\t%.3f\n', names{err_best}, median(err(err_best, :)), mean(err(err_best, :)));
fprintf('Best mutual info: \t%s\t=  %.3f\t%.3f\n', names{mut_best}, median(mut(mut_best, :)), mean(mut(mut_best, :)));
fprintf('Best duration: \t\t%s\t=  %.3f\t%.3f\n', names{dur_best}, median(dur(dur_best, :)), mean(dur(dur_best, :)));

fprintf('\nSimilarity: \n     ')
fprintf('%21s', names{:})
fprintf('\nError: ')
fprintf('%3f             ', err_cp(err_best, :))
fprintf('\nMutIn: ')
fprintf('%3f             ', mut_cp(mut_best, :))
fprintf('\nDurat: ')
fprintf('%3f             ', dur_cp(dur_best, :))
fprintf('\n')





