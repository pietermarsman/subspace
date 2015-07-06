clear all;
close all;
clc;

folder = ['data/'];
mkdir(folder);
exp_name = ['all_', char(datetime('now', 'Format', 'yyyyMMddHHmmss'))];
diary(['data/', exp_name, '.txt']);

repeats = 10;
dataset = 1;
n = 3; % subspaces

% Dataset
if dataset == 1
    N = 500;
    noise = 0.05;
    d = 10;
    D = 1000;
    cos = 0.5;
elseif dataset == 2
    a = load('datasets/YaleBCrop025.mat');
    yaleIdx = find(a.s{10} <= n);
    N = size(yaleIdx, 1);
    d = 11;
    D = size(a.Y, 1);
    noise = 'unknown';
    yaleX = reshape(a.Y, size(a.Y, 1), []);
    yaleX = yaleX(:, yaleIdx);
    yaleLabels = a.s{10}(yaleIdx);
else
    error('Dataset should be between 1 and 2')
end

% Parameters
sAlphas = 10:20;
rAlphas = 10:20;
hAlphas = 10:1:40;
reps = (d+1) * n * [1:.5:5];
reps(reps > N / 2) = [];
pLambda = [1e-7, 1e-6, 1e-5];
pTol = [1e-3, 1e-2, 1e-1];

fprintf('%d Experiments with N=%d, n=%d, d=%d, D=%d and noise=%s\n', ...
    repeats, N, n, d, D, noise)

warning('off', 'MATLAB:mir_warning_maybe_uninitialized_temporary')
parfor i = [1:repeats]
    fprintf('Experiment %d: ', i)
    try
        if dataset == 1
            [~, ~, x, labels] = linear_subspace(N, d, n, D, cos, noise);
        elseif dataset == 2
            x = yaleX;
            labels = yaleLabels;
        end
        [err(:, i), mut(:, i), dur(:, i), pred(:, :, i), names{i}] = experiment(x, labels, n, sAlphas, rAlphas, hAlphas, reps, reps, pLambda, pTol);
    catch E
        warning(getReport(E))
    end
        
    fprintf('\n')
end
names = names{1};
save([folder, '/', exp_name, '.mat'], 'err', 'mut', 'dur', 'pred', 'names')
