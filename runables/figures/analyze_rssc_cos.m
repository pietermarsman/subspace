clear all;

name = 'rssc_cosses71531.mat';
load(['data/', name]);
dir = 'fig';
savename = [dir, '/cos_err']

unique_cosses = sort(unique(cosses));
avg = [];
st = [];
for cos = unique_cosses
    avg = [avg, mean(err(:, cosses == cos), 2)];
    st = [st, std(err(:, cosses == cos), 1, 2)];
end

errorbar(repmat(unique_cosses, length(names), 1)', avg', st')
set(gca, 'XTick', unique_cosses);
cosses_names = mat2cell(unique_cosses, [1], ones(11, 1));
cosses_names{1} = 'dif';
cosses_names{end} = 'sim';
set(gca, 'XTickLabel', cosses_names)
legend(names)
beautyplot('Cosine similarity', 'Error', '', false)
savefig(savename)
export_fig(savename, '-pdf', '-transparent')