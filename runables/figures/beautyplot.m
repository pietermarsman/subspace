function [  ] = beautyplot( xlab, ylab, zlab  )
%BEAUTYPLOT Summary of this function goes here
%   Detailed explanation goes here

axis equal;
axis square;

set(gca,'YTickLabel',[]);
set(gca, 'XTickLabel', []);
set(gca, 'ZTickLabel', []);

xlab = xlabel(xlab);
ylab = ylabel(ylab);
zlab = zlabel(zlab);

set([xlab, ylab, zlab], 'FontSize', 15, 'FontWeight', 'Bold');
grey = [.3, .3, .3];
set(gca, ...
    'FontName', 'helvetica', ...
    'XColor', grey, ...
    'YColor', grey, ...
    'ZColor', grey);


end

