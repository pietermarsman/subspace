close all
dir = 'fig'

position = [0.1 0.3 .85 .75];
angle = 45;

figure(1)
boxplot(err')
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
ylim([0, max(max(dur))])
set(gca, 'XTick', 1:length(names))
set(gca, 'XTickLabel', names)
ylabel('Duration')
rotateticklabel(gca, angle)
set(gca,'Position',position)
name = [dir, '/duration'];
savefig(name)
export_fig(name, '-pdf', '-transparent')