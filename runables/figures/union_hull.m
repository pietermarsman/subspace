clear all;

[u, ~, x, labels] = linear_subspace(500, 2, 2, 4, 0.2, 0.0);

x1 = x(1:2, labels==1);
x2 = x(1:2, labels==2);
x = x(1:2, :);

ind1 = convhulln(x1');
ind2 = convhulln(x2');
ind = convhulln(x');

hold on;
blue = [0, 0.4470, 0.7410];
red = [0.8500, 0.3250, 0.0980];
green = [0.4660, 0.6740, 0.1880];
scatter(x1(1, :), x1(2, :));
scatter(x2(1, :), x2(2, :));
plot_hull(x1', ind1, blue);
plot_hull(x2', ind2, red);
plot_hull(x', ind, green)

beautyplot('x', 'y', '')

dir = 'fig';
name = [dir, '/union_hull'];
savefig(name)
export_fig(name, '-pdf', '-transparent')