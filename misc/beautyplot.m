function [  ] = beautyplot( xlab, ylab, zlab, rmTicks, latex )
%BEAUTYPLOT Summary of this function goes here
%   Detailed explanation goes here

fontsize = 18;
axissize = 12;

axis equal;
axis square;

if rmTicks
    set(gca,'YTickLabel',[]);
    set(gca, 'XTickLabel', []);
    set(gca, 'ZTickLabel', []);
end

xlab = xlabel(xlab);
ylab = ylabel(ylab);
zlab = zlabel(zlab);

set([xlab, ylab, zlab], 'FontSize', fontsize, 'FontWeight', 'Bold');
set(gca,'FontSize',12)

grey = [.3, .3, .3];
set(gca, ...
    'FontName', 'helvetica', ...
    'XColor', grey, ...
    'YColor', grey, ...
    'ZColor', grey);

if latex
    set(xlab, 'interpreter', 'Latex');
    set(ylab, 'interpreter', 'Latex');
    set(zlab, 'interpreter', 'Latex');
end

end

