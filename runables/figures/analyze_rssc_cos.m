clear all;

name = 'rssc_cosses81472.mat';
load(['data/', name]);
dir = 'fig/rep_vs_err';

unique_cosses = sort(unique(cosses));
avg = [];
st = [];
for cos = unique_cosses
    avg = [avg, mean(err(:, cosses == cos), 2)];
    st = [st, std(err(:, cosses == cos), 1, 2)];
end

errorbar(repmat(unique_cosses, length(names), 1)', avg', st')
set(gca, 'XTick', unique_cosses)
legend(names)
beautyplot('Cosine distance', 'Error', '', false)