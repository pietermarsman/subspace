function savefile = exp_cluster_noisecos( dataparams, repeats )
%EXPERIMENT 
%   Example use: workspace; clean; savefile=exp_cluster_noisecos({}, 2);
%   dataparams = description for generation of data (dataset 1)
%   repeats = number of times to repeat the experiment

%% PARAMS
dataset = {1}
verbose = true
params = {'sAlphas', [20], ...
    'rAlphas', [1.05, 1.8], ...
    'rLambda', 1e-4, ...
    'rTol', 1e-3, ...
    'hAlphas', [1.05, 1.8], ...
    'numreps', [.1] ...
    'pLambdas', 1e-4, ...
    'pTols', 1e-3 ...
    };
algos = true(1, 4);
cosses = [0:.1:1];
noises = [0:.001:0.02];

%% SETUP
[savefile] = setup_save('cluster_noisecos');

%% EXPERIMENT
[cosses, noises] = meshgrid(cosses, noises);
cosses = repmat(cosses(:), repeats);
noises = repmat(noises(:), repeats);
fprintf('==%s==', savefile)

parfor i = 1:length(cosses)
    try
        [ x, labels, N, d, n, D, noise, cos ] = get_data(dataset{1}, dataparams{:}, 'cos', cosses(i), 'noise', noises(i));
        fprintf('\nExperiment %d/%d with N=%d, n=%d, d=%d, D=%d and noise=%g\n> ', ...
            i, length(cosses), N, n, d, D, noise)
        [err(:, i), mut(:, i), dur(:, i), pred{i}, cs{i}, rep{i}, names{i}] ...
            = experiment(x, labels, n, algos, params{:});
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
