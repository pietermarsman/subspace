function savefile = exp_cluster_cosreps( dataparams, repeats )
%EXPERIMENT 
%   Example use: workspace; clean; savefile=exp_cluster_noisecos({}, 2);
%   dataparams = description for generation of data (dataset 1)
%   repeats = number of times to repeat the experiment

%% PARAMS
dataset = {1}
verbose = true
params = {'sAlphas', [20], ...
    'rAlphas', [2], ...
    'rLambda', 1e-4, ...
    'rTol', 1e-3, ...
    'hAlphas', [2], ...
    'pLambdas', 1e-4, ...
    'pTols', 1e-3 ...
    };
algos = [false, true, true, true];
cosses = [0:.1:1];
Ni = 3;
d = 10;
N_set = 501;
reps = Ni * (d+1) / N_set * [.5, 1, 1.5];

%% SETUP
[savefile] = setup_save('cluster_cosreps');

%% EXPERIMENT
[cosses, reps] = meshgrid(cosses, reps);
cosses = repmat(cosses(:), repeats, 1);
reps = repmat(reps(:), repeats, 1);
fprintf('==%s==', savefile)

parfor i = 1:length(cosses)
    try
        [ x, labels, N, d, n, D, noise, cos ] = get_data(...
            dataset{1}, dataparams{:}, 'cos', cosses(i), 'N', N_set);
        fprintf('\nExperiment %d/%d with N=%d, n=%d, d=%d, D=%d, cos=%d and noise=%g\n> ', ...
            i, length(cosses), N, n, d, D, cos, noise)
        [err(:, i), mut(:, i), dur(:, i), pred{i}, cs{i}, rep{i}, names{i}] ...
            = experiment(x, labels, n, algos, params{:}, 'numreps', reps(i));
    catch ME
        warning(ME.message)
        err(:, i) = -1;
        mut(:, i) = -1;
        dur(:, i) = -1;
        pred{i} = ME.message;
        cs{i} = ME.message;
        rep{i} = ME.message;
        names{i}{1} = ME.message;
    end
end

%% POST PROCESS
post_process();

%% SAVING
save(savefile)
