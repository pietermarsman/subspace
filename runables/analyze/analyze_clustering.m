clean
dir = 'results';

% name = 'data/param_gen_7361639564.mat'; load(name); names = names(1:end-2); % genlibsub SSC & SSSC
% name = 'data/param_gen_7361655342.mat'; load(name); % genlibsub RSSC_r & RSSC_n
% name = 'data/param_yale_7361639566.mat'; load(name); names = names(1:end-4); % Yale RSSC
% name = 'data/param_hopkins_7361639569.mat'; load(name); names = names(1:end-3); % Hopkins155 SSSC
% name = 'data/param_hopkins_7361654963.mat'; load(name); % Hopkins155 RSSC

% name = 'data/clustering_comp_gen_7361656695.mat'; load(name); % comp genlibsub
% name = 'data/clustering_comp_hopkins_7361656698.mat'; load(name); % comp hopkins
name = 'data/clustering_comp_yale_7361656697.mat'; load(name); % comp yale

%% Selection
dataset = 'Extended Yale B';
method = 'Comparison';

if strcmp(method, 'SSC')
    selection = cellfun(@(x) strcmp(x(1:3), method), names); selection(19) = false; alphas(19) = [];
elseif strcmp(method, 'SSSC')
    selection = cellfun(@(x) strcmp(x(1:4), method), names);
elseif strcmp(method, 'RSSC with representatives')
    selection = cellfun(@(x) strcmp(x(1:6), 'RSSC_r'), names); 
elseif strcmp(method, 'RSSC without representatives')
    selection = cellfun(@(x) strcmp(x(1:6), 'RSSC_n'), names);
elseif strcmp(method, 'Comparison')
    selection = [3, 4, 6];
    names = cellfun(@(x) strjoin(strsplit(x, '0000e+00'), ''), names, 'UniformOutput', false);
end

col_selection = sum(err == -1, 1) == 0;
names = names(selection);
err = err(selection, col_selection);
mut = mut(selection, col_selection);
dur = dur(selection, col_selection);
rep = cell2mat(cellfun(@(x) cellfun(@length, x(selection)), rep(col_selection), 'UniformOutput', false));
pred = pred(col_selection)
Ns = cellfun(@(x) size(x, 2), pred);
rep = rep ./ repmat(Ns, size(rep, 1), 1);
exp_N = length(names)

%% Information
tit = sprintf('%s - %s', method, dataset);
names = cellfun(@(x) strjoin(strsplit(x, '_no'), '^{NO}'), names, 'UniformOutput', false);
names = cellfun(@(x) strjoin(strsplit(x, '_rep'), '^{REP}'), names, 'UniformOutput', false);
if strcmp(method, 'SSC')
    xlab = 'Alpha';
    xvalues = alphas;
elseif strcmp(method, 'SSSC')
    xlab = '';
    xvalues = names;
elseif  strcmp(method, 'RSSC with representatives')
    xlab = 'Alpha';
    p = inputParser;
    p.KeepUnmatched = 1;
    p.addParameter('rAlphas', []);
    p.parse(params{:});
    xvalues = p.Results.rAlphas;
elseif strcmp(method, 'RSSC without representatives')
    xlab = 'Alpha';
    p = inputParser;
    p.KeepUnmatched = 1;
    p.addParameter('rAlphas', []);
    p.parse(params{:});
    xvalues = p.Results.rAlphas;
elseif strcmp(method, 'Comparison')
    xlab = '';
    xvalues = names;
end

rotate = true;
ratio = [2, 1, 1];
position = [0 0 800 800];

savetitle = lower(strjoin(strsplit(tit, ' '), ''))
diarytitle = [dir, '/', savetitle, '.txt'];

%% Descriptives
delete(diarytitle);
diary(diarytitle);
diary on
clc;
fprintf('==Descriptives==\n')
fprintf('%40s\tError \tMutInf \tDurati \tIn-sample size\n', '')
for i = 1:length(names)
    fprintf('%40s\t%.4f \t%.4f \t%.3f \t%.3f\n', names{i}, mean(err(i, :)), mean(mut(i, :)), mean(dur(i, :)), mean(rep(i, :)));
end

%% Analyzes
fprintf('==Normality test==\n')
fprintf('%30s  Error\t\tMutual info\tDuration\tIn-sample size\n', '')
for i = 1:length(names)
    [err_h, err_p] = kstest(err(i, :));
    [mut_h, mut_p] = kstest(mut(i, :));
    [dur_h, dur_p] = kstest(dur(i, :));
%     [rep_h, rep_p] = kstest(rep(i, :));
    fprintf('%30s  %.5f \t%.5f \t%.5f \n', names{i}, err_p, mut_p, dur_p);
end

fprintf('\n==Kruskal-Wallis test==\n')
[err_p, ~, err_stats] = kruskalwallis(err', xvalues, 'off');
[mut_p, ~, mut_stats] = kruskalwallis(mut', xvalues, 'off');
[dur_p, ~, dur_stats] = kruskalwallis(dur', xvalues, 'off');
% [rep_p, ~, rep_stats] = kruskalwallis(rep', xvalues, 'off');
fprintf('Group medians differ for error (%.5f), mutual info (%.5f), duration (%.5f) \n', err_p, mut_p, dur_p);

fprintf('\n==Pair wise testing==\n')
[~, err_best] = min(err_stats.meanranks);
[~, mut_best] = max(mut_stats.meanranks);
[~, dur_best] = min(dur_stats.meanranks);

err_c = multcompare(err_stats, 'display', 'off');
mut_c = multcompare(mut_stats, 'display', 'off');
dur_c = multcompare(dur_stats, 'display', 'off');
% rep_c = multcompare(rep_stats, 'display', 'off');
err_cp = full(sparse(err_c(:, 1), err_c(:, 2), err_c(:, 6), exp_N, exp_N));
mut_cp = full(sparse(mut_c(:, 1), mut_c(:, 2), mut_c(:, 6), exp_N, exp_N));
dur_cp = full(sparse(dur_c(:, 1), dur_c(:, 2), dur_c(:, 6), exp_N, exp_N));
% rep_cp = full(sparse(rep_c(:, 1), rep_c(:, 2), rep_c(:, 6), exp_N, exp_N));
err_cp = err_cp + err_cp';
mut_cp = mut_cp + mut_cp';
dur_cp = dur_cp + dur_cp';
% rep_cp = rep_cp + rep_cp';

fprintf('%51sMedian\tMean\n', '')
fprintf('%16s: %30s = %.3f\t%.3f\n', 'Best error', names{err_best}, median(err(err_best, :)), mean(err(err_best, :)));
fprintf('%16s: %30s = %.3f\t%.3f\n', 'Best mutual info', names{mut_best}, median(mut(mut_best, :)), mean(mut(mut_best, :)));
fprintf('%16s: %30s = %.3f\t%.3f\n', 'Best duration', names{dur_best}, median(dur(dur_best, :)), mean(dur(dur_best, :)));

fprintf('\nSimilarity: \n       ')
fprintf('%20s ', names{:})
fprintf('\nError: ')
fprintf('%3f             ', err_cp(err_best, :))
fprintf('\nMutIn: ')
fprintf('%3f             ', mut_cp(mut_best, :))
fprintf('\nDurat: ')
fprintf('%3f             ', dur_cp(dur_best, :))
fprintf('\n')

diary off

%% Plot error
angle = 90;

aFig = figure(1);
hold on
boxplot(err')
scatter(1:size(err, 1), mean(err, 2), 'b*')
beautyplot(xlab, 'Error rate', '', false, false)
title(tit);
set(gca, 'XTick', 1:length(xvalues))
set(gca, 'XTickLabel', xvalues)
set(aFig, 'Position', position);
set(gca, 'PlotBoxAspectRatio', ratio)
ylim([0, 1])
if rotate
    rotateticklabel(gca, angle);
    xlabh = get(gca,'XLabel');
    set(xlabh, 'Units', 'normalized');
    set(xlabh,'Position', get(xlabh,'Position') - [0 .1 0])
end
savefigure(dir, [savetitle, '_error']);

%% Plot mutual info
bFig = figure(2);
hold on
boxplot(mut')
scatter(1:size(mut, 1), mean(mut, 2), 'b*')
beautyplot(xlab, 'Mutual info', '', false, false)
title(tit);
set(gca, 'XTick', 1:length(xvalues))
set(gca, 'XTickLabel', xvalues)
set(bFig, 'Position', position);
set(gca, 'PlotBoxAspectRatio', ratio)
ylim([0, 1])
if rotate
    rotateticklabel(gca, angle);
    xlabh = get(gca,'XLabel');
    set(xlabh, 'Units', 'normalized');
    set(xlabh,'Position', get(xlabh,'Position') - [0 .1 0])
end
savefigure(dir, [savetitle, '_mutual_info']);

%% Plot duration
cFig = figure(3);
hold on
boxplot(dur')
scatter(1:size(dur, 1), mean(dur, 2), 'b*')
beautyplot(xlab, 'Duration (sec)', '', false, false)
title(tit);
ylim([0, max(max(dur))])
set(gca, 'XTick', 1:length(xvalues))
set(gca, 'XTickLabel', xvalues)
set(cFig, 'Position', position);
set(gca, 'PlotBoxAspectRatio', ratio)
if rotate
    rotateticklabel(gca, angle);
    xlabh = get(gca,'XLabel');
    set(xlabh, 'Units', 'normalized');
    set(xlabh,'Position', get(xlabh,'Position') - [0 .1 0])
end
savefigure(dir, [savetitle, '_duration']);


%% Plot in-sample size
% dFig = figure(4);
% hold on
% 
% boxplot(rep')
% scatter(1:size(rep, 1), mean(rep, 2), 'b*');
% beautyplot(xlab, 'In-sample size', '', false, false)
% title(tit);
% ylim([0, 1])
% set(gca, 'XTick', 1:length(xvalues))
% set(gca, 'XTickLabel', xvalues)
% set(dFig, 'Position', position);
% set(gca, 'PlotBoxAspectRatio', ratio)
% if rotate
%     rotateticklabel(gca, angle)
%     xlabh = get(gca,'XLabel');
%     set(xlabh, 'Units', 'normalized');
%     set(xlabh,'Position', get(xlabh,'Position') - [0 .1 0])
% end
% savefigure(dir, [savetitle, '_insample_size']);


