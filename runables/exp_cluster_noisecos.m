function savefile = exp_cluster_noisecos( dataparams, repeats )
%EXPERIMENT 
%   Example use: workspace; clean; savefile=exp_cluster_noisecos({}, 2);
%   dataparams = description for generation of data (dataset 1)
%   repeats = number of times to repeat the experiment

%% PARAMS
dataset = {1}
verbose = true
params = {'sAlphas', [5], ...
    'rAlphas', [50], ...
    'hAlphas', [50], ...
    'pReps', [.1] ...
    };
cosses = [0:.1:1];
noises = [0:.0001:0.005];

%% SETUP
[savefile] = setup_save(['cluster_noisecos', num2str(round(rand() * 100000))]);

%% EXPERIMENT
fprintf('==%s==', savefile)

[cosses, noises] = meshgrid(cosses, noises);
cosses = cosses(:)
noises = noises(:)
for i = 1:length(cosses)
    dataparams = {dataparams{:}, 'cos', cosses(i), 'noise', noises(i)};
    [ x, labels, N, d, n, D, noise, cos ] = get_data(dataset{1}, dataparams{:});
    fprintf('\nExperiment %d/%d with N=%d, n=%d, d=%d, D=%d, cos=%d and noise=%d\n> ', ...
        i, length(cosses), N, n, d, D, cos, noise)
    [err(:, i), mut(:, i), dur(:, i), pred{i}, cs{i}, rep{i}, names{i}] = experiment(x, labels, n, params{:});
end

%% POST PROCESS
post_process();

%% SAVING
save(savefile)
