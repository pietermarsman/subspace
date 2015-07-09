clear all;

name = 'rssc_noise_vs_err60662.mat';
load(['data/', name]);
dir = 'fig';
mkdir(dir);
savename = [dir, '/rssc_noise'];

unique_noises = sort(unique(noises));
avg = [];
st = [];
for noise = unique_noises
    avg = [avg, mean(err(:, noises == noise), 2)];
    st = [st, std(err(:, noises == noise), 1, 2)];
end

xs = repmat(unique_noises, length(names), 1)';
range = max(max(xs)) - min(min(xs));
for i = 1:length(names)
    shift = i - (length(names) / 2);
    xs(:, i) = xs(:, i) + shift * 0.01 * range;
end

errorbar(xs, avg', st')
title(sprintf('N=%d, D=%d, repeats=%d', N, D, repeats));
legend(names)
beautyplot('Noise', 'Error', '', false)
savefig(savename)
export_fig(savename, '-pdf', '-transparent')