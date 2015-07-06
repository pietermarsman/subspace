close all
dir = 'fig'

figure(1)
boxplot(err')
set(gca, 'XTick', 1:length(names))
set(gca, 'XTickLabel', names)
ylim([0, 1])
ylabel('Error rate')
rotateticklabel(gca, 45)
set(gca,'Position',[0.1 0.2 .85 .75])
name = [dir, '/error'];
savefig(name)
export_fig(name, '-pdf', '-transparent')

figure(2)
boxplot(mut')
set(gca, 'XTick', 1:length(names))
set(gca, 'XTickLabel', names)
ylim([0, 1])
ylabel('Mutual info')
rotateticklabel(gca, 45)
set(gca,'Position',[0.1 0.2 .85 .75])
name = [dir, '/mutual_info'];
savefig(name)
export_fig(name, '-pdf', '-transparent')

figure(3)
boxplot(dur')
ylim([0, max(max(dur))])
set(gca, 'XTick', 1:length(names))
set(gca, 'XTickLabel', names)
ylabel('Duration')
rotateticklabel(gca, 45)
set(gca,'Position',[0.1 0.2 .85 .75])
name = [dir, '/duration'];
savefig(name)
export_fig(name, '-pdf', '-transparent')