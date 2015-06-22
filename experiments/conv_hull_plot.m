x = rand(15, 2);
x = (x + 0.1) * (0.9 / 1.1);
h = convhulln(x);

f = figure(1)
plot_hull(x, h)
xlim([0, 1])
ylim([0, 1])
title('Convex hull')

W = 4; H = 3;
set(f,'PaperUnits','inches')
set(f,'PaperOrientation','portrait');
set(f,'PaperSize',[H,W])
set(f,'PaperPosition',[0,0,W,H])

FS = findall(f,'-property','FontSize');
set(FS,'FontSize',12);

print(f,'-dpng','-color','convex_hull.png')