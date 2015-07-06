hull_plot = true;
close all;
dir = 'fig/dim';
mkdir(dir);
S = 1;

view_3d = {3, [-45, 25]};

for D = [S:3]
    for d = [1:D/S]
        clf;
        [u, rot, x, ~] = linear_subspace(50, d, S, D, 0.2, 0.0);
        
        if D == 3
            scatter3(x(1, :), x(2, :), x(3, :));
        elseif D == 2
            scatter(x(1, :), x(2, :));
        elseif D == 1
            scatter(x, zeros(size(x)));
        end
        if d >= 2
            ind = convhulln(u');
            if hull_plot
                plot_hull(x', ind);
            end
        end
        beautyplot('x', 'y', 'z');
        name = [dir, sprintf('/D%dd%dS%d', D, d, S)];
        savefig(name);
        if D == 3
            views = view_3d;
        else
            views = {2}';
        end
        view_i = 1;
        for v = views
            view(v{1});
            export_fig(sprintf('%s_%d', name, view_i), '-pdf', '-transparent')
            view_i = view_i + 1;
        end
    end
end
