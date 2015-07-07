clear all;

name = 'rssc_noise_vs_err81472.mat';
load(['data/', name]);
dir = 'fig/rep_vs_err';

unique_noises = sort(unique(noises));
avg = [];
st = [];
for noise = unique_noises
    avg = [avg, mean(err(:, noises == noise), 2)];
    st = [st, std(err(:, noises == noise), 1, 2)];
end

errorbar(repmat(unique_noises, length(names), 1)', avg', st')
set(gca, 'XTick', unique_noises)
legend(names)
beautyplot('Noise', 'Error', '', false)