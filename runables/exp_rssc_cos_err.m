clear all;
close all;
clc;

folder = ['data/'];
mkdir(folder);
exp_name = 'rssc_cos_vs_err'
diary(['data/', exp_name, '.txt']);
verbose = true;

repeats = 20;
dataset = 1;

% Dataset
if dataset == 1
    N = 1000;
    d = 10;
    noise = 0.0;
    n = 3;
    D = 1000;
elseif dataset == 2
    load('datasets/YaleBCrop025.mat');
    n = 2;
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
sAlphas = [5]; %2:20;
rAlphas = [5:5:100]; %2:20;
hAlphas = []; %2:30;
reps = []; %(d+1) * n * [2]; %[2:5];
% reps(reps > N / 2) = [];
pLambda = []; %[1e-7, 1e-6, 1e-5];
pTol = [1e-3, 1e-2, 1e-1];

cosses = repmat(0.0:0.1:1.0, 1, repeats);

fprintf('%d Experiments with N=%d, n=%d, d=%d, D=%d\n', ...
    repeats, N, n, d, D)

warning('off', 'MATLAB:mir_warning_maybe_uninitialized_temporary')
for i = [1:length(cosses)]
    fprintf('Experiment %d: ', i)
    try
        if dataset == 1
            [u, rot, x, labels] = linear_subspace(N, d, n, D, cosses(i), noise);
        elseif dataset == 2
            x = yaleX;
            labels = yaleLabels;
        end
        x = normc(x); % normalize datapoints
        
        [err(:, i), mut(:, i), dur(:, i), pred(:, :, i), cs{i}, rep{i}, names{i}] = experiment(x, labels, n, sAlphas, rAlphas, hAlphas, reps, reps, pLambda, pTol);
        if verbose
            fprintf('\nname\t error\t mut\t dur\t reps\n');
            for j = 1:length(names{1})
                fprintf('%s \t%f \t%f \t%f \t%f\n', names{1}{j}, err(j, i), ...
                    mut(j, i), dur(j, i), length(rep{i}{j}));
            end
        end
    catch E
        warning(getReport(E))
    end
        
    fprintf('\n')
end
names = names{1};
save([folder, '/', exp_name, '.mat'], 'err', 'mut', 'dur', 'pred', 'names', 'cosses')

post_process()
