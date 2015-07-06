clear all;
close all;
clc;

folder = ['data/'];
mkdir(folder);
exp_name = ['all_', char(datetime('now', 'Format', 'yyyyMMddHHmmss'))];
diary(['data/', exp_name, '.txt']);

repeats = 100;
dataset = 2;
n = 10; % subspaces

% Dataset
if dataset == 1
    N = 500;
    noise = 0.03;
    d = 10;
    D = 1000;
    cos = 0.5;
elseif dataset == 2
    load('datasets/YaleBCrop025.mat');
    N = size(Y, 2) * n;
    d = 11;
    D = size(Y, 1);
    noise = 'unknown';
    yaleX = Y(:, :, 1:n);
    yaleX = reshape(yaleX, size(yaleX, 1), []);
    yaleLabels = s{n};
else
    error('Dataset should be between 1 and 2')
end

% Parameters
sAlphas = 2:20;
rAlphas = 2:20;
hAlphas = 2:30;
reps = (d+1) * n * [2:5];
reps(reps > N / 2) = [];
pLambda = [1e-7, 1e-6, 1e-5];
pTol = [1e-3, 1e-2, 1e-1];

fprintf('%d Experiments with N=%d, n=%d, d=%d, D=%d and noise=%s\n', ...
    repeats, N, n, d, D, noise)

warning('off', 'MATLAB:mir_warning_maybe_uninitialized_temporary')
for i = [1:repeats]
    fprintf('Experiment %d: ', i)
    try
        if dataset == 1
            [~, ~, x, labels] = linear_subspace(N, d, n, D, cos, noise);
        elseif dataset == 2
            x = yaleX;
            labels = yaleLabels;
        end
         x = normr(x); % normalize datapoints
        
        [err(:, i), mut(:, i), dur(:, i), pred(:, :, i), names{i}] = experiment(x, labels, n, sAlphas, rAlphas, hAlphas, reps, reps, pLambda, pTol);
    catch E
        warning(getReport(E))
    end
        
    fprintf('\n')
end
names = names{1};
save([folder, '/', exp_name, '.mat'], 'err', 'mut', 'dur', 'pred', 'names')