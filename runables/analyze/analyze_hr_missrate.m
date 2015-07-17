%% PROCESSING
clean

name = 'exp_hr_c_dist_7361617051.mat'
file = ['data/', name];
load(file)

idx_missing = [];
for i = [1:repeats]
    rssc_repInd = rep{i}{1};
    nReps = length(rssc_repInd);
    k = 1;
    for id = rssc_repInd
        missing = [k / size(rssc_repInd, 2)];
        for j = 1:length(names)
            maxReps = min(nReps, length(rep{i}{j}));
            missing = [missing, sum(rep{i}{j}(1:maxReps) == id) == 0];
        end
        idx_missing = [idx_missing; missing];
        k = k + 1;
    end
end
fprintf('\n')

%% SELECTION
selection = [1, 3];
idx_missing = idx_missing(:, [1, selection+1]);
names = names(selection);

%% PLOTTING
figure(2)
bars = [];
std_bars = [];
range = [0.1:0.1:1.0];
for to = range
    from = to - 0.1;
    idx = (idx_missing(:, 1) > from) & (idx_missing(:, 1) < to);
    bars = [bars; mean(idx_missing(idx, 2:end), 1)];
    std_bars = [std_bars; std(idx_missing(idx, 2:end), 1, 1)];
end
hold on
plot(repmat(range, length(names), 1)', bars)
% plot(repmat(range, length(names), 1)', bars, 'Color', colors(length(names), :));
% plot(repmat(range, length(names), 1)', bars+std_bars, 'Color', colors(length(names, :)))
ylim([0, 1]);
suptitle('Part of the representatives not found by HSSC');
title(sprintf('N=%d, d=%d, S=%d, D=%d, repeats=%d', N, d, n, D, repeats));
legend(names)
beautyplot('RSSC repInd place', 'Part not found', '', false);

dir = 'fig';
name = [dir, '/repind'];
mkdir dir;
savefig(name)
export_fig(name, '-pdf', '-transparent')