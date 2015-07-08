clean

name = 'duration28924.mat';
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
    st = [st; std(err(:, subsets * 64 == N), 1, 2)'];
    duri = [duri; mean(dur(:, subsets * 64 == N), 2)'];
    dur_std = [dur_std; std(dur(:, subsets * 64 == N), 1, 2)'];
end

errorbar(repmat(unique_N', 1, length(names)), avg, st)
set(gca, 'XTick', unique_N)
legend(names)
beautyplot('N', 'Error', '', false)
savename = [dir, '/err_vs_N'];
savefig(savename)
export_fig(savename, '-pdf', '-transparent')


cla;
errorbar(repmat(unique_N', 1, length(names)), duri, dur_std)
set(gca, 'XTick', unique_N)
legend(names)
beautyplot('N', 'Duration', '', false)
savename = [dir, '/dur_vs_N'];
savefig(savename)
export_fig(savename, '-pdf', '-transparent')