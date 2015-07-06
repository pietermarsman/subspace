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
    noise = 0.1;
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
sAlphas = 1:1:20;
rAlphas = 1:1:20;
hAlphas = 1:1:20;
hMaxReps = (d+1) * n * [1:9];
hMaxReps(hMaxReps > N) = [];
pReps = (d+1) * n * [1:9];
pReps(pReps > N) = [];

fprintf('%d Experiments with N=%d, n=%d, d=%d, D=%d and noise=%s\n', ...
    repeats, N, n, d, D, noise)

names = {'ssc', 'sssc', 'hssc', 'rssc'};

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

        [expErr, expMut, expDur, expPred, names] = experiment(x, labels, n, sAlphas, rAlphas, hAlphas, hMaxReps, pReps);

        err(:, i) = expErr;
        mut(:, i) = expMut;
        dur(:, i) = expDur;
        pred(:, :, i) = expPred;
    catch E
        warning(getReport(E))
    end
        
    fprintf('\n')
end
save([folder, '/', exp_name, '.mat'], 'dur', 'err', 'pred')
