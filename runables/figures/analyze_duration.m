clear all;

name = 'yale_duration87368.mat';
load(['data/', name]);
dir = 'fig/rep_vs_err';

unique_N = sort(unique(subsets * 64));
avg = [];
st = [];
for N = unique_N
    avg = [avg; mean(err(:, subsets * 64 == N), 2)'];
    st = [st; std(err(:, subsets * 64 == N), 1, 2)'];
end

plot(repmat(unique_N', 1, length(names)), avg, st)
set(gca, 'XTick', unique_N)
legend(names)
beautyplot('N', 'Error', '', false)