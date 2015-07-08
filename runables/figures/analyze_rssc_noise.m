clear all;

name = 'rssc_noise_vs_err67167.mat';
load(['data/', name]);
dir = 'fig/rep_vs_err';

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
set(gca, 'XTick', unique_noises)
legend(names)
beautyplot('Noise', 'Error', '', false)