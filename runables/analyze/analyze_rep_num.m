clean

%% Load data

% name = 'data/exp_rep_gen_7361657402.mat'; load(name); % genlibsub
name = 'data/exp_rep_hopkins_7361657431.mat'; load(name); repeats=155; % Hopkins 155
% name = 'data/exp_rep_yale_7361657407.mat'; load(name); % Yale

%% Information
dataset = 'Generated linear subspaces'
xtitle = 'Part representatives'
ytitle = 'Clustering error'

dir = 'fig';
savename = [dir, '/num_rep'];
mkdir(dir);

%% Constants
position = [0.1 0.3 .85 .75];
angle = 45;
N = size(pred{1}, 2);
D = 2000;
cos = 0.5;
noise = 0.01;
di = 10;
ni = 3;

p = inputParser;
p.KeepUnmatched = 1;
p.addOptional('numreps', -1);
p.parse(params{:});
numreps = p.Results.numreps;

%% Compute

ssc = 0;
sssc_temp = [];
rsscr_temp = [];
rsscn_temp = [];
hssc_temp = [];
for j = 1:repeats
    for i = 1:length(names)
        if strcmp(names{i}(1:3), 'SSC')
            ssc = mean(err(i, :));
        elseif all(names{i}(1:4) == 'SSSC')
            sssc_temp = [sssc_temp; err(i, j)];
        elseif all(names{i}(1:15) == 'RSSC_rep(a=1.8,')
            rsscr_temp = [rsscr_temp; err(i, j)];
        elseif strcmp(names{i}(1:15), 'RSSC_no(a=1.05,')
            rsscn_temp = [rsscn_temp; err(i, j)];
        else
%             warning(sprintf('Name not recognized: %s', names{i}));
        end
    end
end
sssc_values = reshape(sssc_temp, length(numreps), []);
rsscr_values = reshape(rsscr_temp, length(numreps), []);
rsscn_values = reshape(rsscn_temp, length(numreps), []);

%% Plot
hold on;
plot([0, 1], [ssc, ssc]);
errorbar(numreps-0.01, mean(sssc_values, 2), std(sssc_values, [], 2)/10);
errorbar(numreps, mean(rsscr_values, 2), std(rsscr_values, [], 2)/10);
errorbar(numreps+0.01, mean(rsscn_values, 2), std(rsscn_values, [], 2)/10);
legend('SSC', 'SSSC', 'RSSC^{REP}', 'RSSC^{NO}');


if dataset == 'Generated linear subspaces'
    suptitle(dataset);
    tit = title(sprintf('$N=%d, D=%d, cos=%.2f, \\epsilon^2=%.2f$', N, D, cos, noise))
    set(tit, 'interpreter', 'Latex')
else
    title(dataset)
end

beautyplot(xtitle, ytitle, '', false, false)
% ylim([0, 1])
% savefig(savename)
% export_fig(savename, '-pdf', '-transparent')


