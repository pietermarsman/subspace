dir = 'fig'

close all;
boxplot(err')
set(gca, 'XTick', 1:length(names))
set(gca, 'XTickLabel', names)
ylim([0, 1])
ylabel('Error rate')
rotateticklabel(gca, 45)
name = [dir, '/error'];
savefig(name)
export_fig(name, '-pdf', '-transparent')

% close all;
% boxplot(mut')
% set(gca, 'XTick', 1:length(names))
% set(gca, 'XTickLabel', names)
% ylim([0, 1])
% ylabel('Error rate')
% rotateticklabel(gca, 45)
% name = [dir, '/mutual_info'];
% savefig(name)
% export_fig(name, '-pdf', '-transparent')

close all;
boxplot(dur')
ylim([0, max(max(dur))])
set(gca, 'XTick', 1:length(names))
set(gca, 'XTickLabel', names)
ylabel('Duration')
rotateticklabel(gca, 45)
name = [dir, '/duration'];
savefig(name)
export_fig(name, '-pdf', '-transparent')