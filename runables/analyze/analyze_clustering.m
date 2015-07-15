clean
dir = 'fig'
name = 'data/clustering_param38752.mat';
load(name)

position = [0.1 0.4 .85 .55];
angle = 45;

figure(1)
boxplot(err')
beautyplot('', 'Error rate', '', false)
set(gca, 'XTick', 1:length(names))
set(gca, 'XTickLabel', names)
ylim([0, 1])
ylabel('Error rate')
rotateticklabel(gca, angle)
set(gca,'Position',position)
name = [dir, '/error'];
savefig(name)
export_fig(name, '-pdf', '-transparent')

figure(2)
boxplot(mut')
beautyplot('', 'Mutual info', '', false)
set(gca, 'XTick', 1:length(names))
set(gca, 'XTickLabel', names)
ylim([0, 1])
ylabel('Mutual info')
rotateticklabel(gca, angle)
set(gca,'Position',position)
name = [dir, '/mutual_info'];
savefig(name)
export_fig(name, '-pdf', '-transparent')

figure(3)
boxplot(dur')
beautyplot('', 'Duration', '', false)
ylim([0, max(max(dur))])
set(gca, 'XTick', 1:length(names))
set(gca, 'XTickLabel', names)
ylabel('Duration')
rotateticklabel(gca, angle)
set(gca,'Position',position)
name = [dir, '/duration'];
savefig(name)
export_fig(name, '-pdf', '-transparent')