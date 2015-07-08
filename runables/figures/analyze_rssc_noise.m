clear all;

name = 'rssc_noise_vs_err66341.mat';
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
xs(:, 1) = xs(:, 1) * 0.99;
xs(:, 2) = xs(:, 2) * 1.01;

errorbar(xs, avg', st')
title(sprintf('N=%d, D=%d', N, D));
legend(names)
beautyplot('Noise', 'Error', '', false)
savefig(savename)
export_fig(savename, '-pdf', '-transparent')