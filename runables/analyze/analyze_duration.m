clean

name = 'duration9198.mat';
load(['data/', name]);
dir = 'fig';
mkdir(dir);

unique_N = sort(unique(subsets * 64));
avg = [];
st = [];
duri = [];
dur_std = [];
for N = unique_N
    avg = [avg; mean(err(:, subsets * 64 == N), 2)'];
    st = [st; std(err(:, subsets * 64 == N), 1, 2)' / sqrt(sum(subsets * 64 == N))];
    duri = [duri; mean(dur(:, subsets * 64 == N), 2)'];
    dur_std = [dur_std; std(dur(:, subsets * 64 == N), 1, 2)' / sqrt(sum(subsets * 64 == N))];
end

name_idx = [2, 4, 5, 6];
errorbar(repmat(unique_N', 1, length(names(name_idx))), avg(:, name_idx), st(:, name_idx))
set(gca, 'XTick', unique_N)
legend(names(name_idx), 'Location', 'SouthEast')
title(sprintf('N=%d, D=%d, repeats=%d', N, D, repeats));
beautyplot('N', 'Error', '', false)
savename = [dir, '/err_vs_N'];
savefig(savename)
export_fig(savename, '-pdf', '-transparent')


cla;
errorbar(repmat(unique_N', 1, length(names(name_idx))), duri(:, name_idx), dur_std(:, name_idx))
set(gca, 'XTick', unique_N)
legend(names(name_idx), 'Location', 'NorthWest')
title(sprintf('N=%d, D=%d, repeats=%d', N, D, repeats));
beautyplot('N', 'Duration', '', false)
savename = [dir, '/dur_vs_N'];
savefig(savename)
export_fig(savename, '-pdf', '-transparent')