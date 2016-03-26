clean;

name = 'exp_rep_yale_7361657407.mat';
load(['data/', name]);
dir = 'fig';
savename = [dir, '/numrep'];

%%
numreps = [.05:.05:.95];
is_ssc = cellfun(@(x) strcmp(x(1:3), 'SSC'), names);
is_rep = cellfun(@(x) strcmp(x(1:8), 'RSSC_rep'), names);
is_no = cellfun(@(x) strcmp(x(1:7), 'RSSC_no'), names);
is_sssc = cellfun(@(x) strcmp(x(1:4), 'SSSC'), names);
is_hrep = cellfun(@(x) strcmp(x(1:8), 'HSSC_rep'), names);
is_hno = cellfun(@(x) strcmp(x(1:7), 'HSSC_no'), names);

%% Selection
is_ssc = cellfun(@(x) strcmp(x(1:3), 'SSC'), names);
is_rep = cellfun(@(x) strcmp(x(1:8), 'RSSC_rep'), names);
is_no = cellfun(@(x) strcmp(x(1:7), 'RSSC_no'), names);
is_all = any([is_ssc, is_rep, is_no], 2);
names = names(is_all);
err = err(is_all, :);
rep = cellfun(@(x) x(is_all), rep, 'UniformOutput', false);

%% Aggregation

num_rep = [];
error = [];
id_rep = [];
id_no = [];
num = 0;
for i = 1:length(rep)
    num_rep = [num_rep, cellfun(@length, rep{i})];
    error = err(:, i);
    id_rep = [id_rep, num + 1:2:size(err, 1)];
    id_no = [id_no, num + 2:2:size(err, 1)];
    num = num + size(err, 1);
end

%% PLOT
hold on;

scatter(num_rep(id_rep), error(id_rep));
scatter(num_rep(id_no), error(id_no));
legend('Representatives', 'Not representatives')
beautyplot('In-sample size', 'Error', '', false)

%% SAVE
savefig(savename)
export_fig(savename, '-pdf', '-transparent')
