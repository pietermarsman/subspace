clean;

%% Load dataset
% name = 'data/param_yale_7361639566.mat'; load(name); names = names(1:end-4);
% name = 'data/param_hopkins_7361654963.mat'; load(name); 
name = 'data/param_gen_7361655342.mat'; load(name);

%% Selection
dataset = 'Generated linear subspaces';
method = 'RSSC with representatives';

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

% selection(17) = 0;
% alphas(9) = [];
alphas = params{6};

%% Info
N = cellfun(@length, pred);
ratio = [2, 1, 1];
position = [0 0 800 800];

dir = 'results';
save_dataset = lower(strjoin(strsplit(dataset, ' '), ''));
savetitle = ['alpha_vs_reps_', save_dataset];

%% Aggregate
rep_length = cellfun(@(x) cellfun(@length, x), rep, 'UniformOutput', false);
rep_length = cell2mat(rep_length);
rep_length = rep_length(find(selection), :);
rep_length = rep_length ./ repmat(N, size(rep_length, 1), 1);

%% Plot
aFig = figure(1);
boxplot(rep_length', 'labels', alphas, 'labelorientation', 'inline');
beautyplot('Alpha', 'Part representatives', '', false, false);
title(dataset);
set(aFig, 'Position', position);
set(gca, 'PlotBoxAspectRatio', ratio)
ylim([0, 1.01])

savefigure(dir, [savetitle]);