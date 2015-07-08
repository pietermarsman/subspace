rho = 0:0.001:1;
y = sqrt(1 - rho);

plot(rho, y);
beautyplot('rho', 'factor', '', true)

set(gca,'YTick',[0, 1]);
set(gca, 'XTick', [0, 1]);
set(gca,'YTickLabel',[0, 1]);
set(gca, 'XTickLabel', [0, 1]);

dir = 'fig'
mkdir(dir)
name = [dir, '/complexity_breakeven'];
savefig(name)
export_fig(name, '-pdf', '-transparent')