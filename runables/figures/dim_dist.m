
dir = 'fig';
mkdir(dir);
name = [dir, '/dimdist'];

d = 10;
Ds = [1, 2, 4, 8, 16, 32];

fig_i = 1;

for measure = {'Euclidean', 'Cosine'}
    figure(fig_i);
    measure = measure{1};
    name = [dir, '/dimdist_', lower(measure)];
    
    dist = [];
    dist_i = 1;
    for D = Ds
        x = rand(2000, D);
        dist(dist_i, :) = pdist(x, lower(measure));
        dist_i = dist_i + 1;
    end

    range = linspace(0, max(max(dist)));
    h = histc(dist',range);
    h = h ./ repmat(sum(h), size(h, 1), 1);
    plot(range, h);
    title([measure, ' distance']);
    legend('dim=1', 'dim=2', 'dim=4', 'dim=8', 'dim=16')
    beautyplot('Distance(x,y)', '', '')
    if strcmp(measure, 'Cosine')
        ylim([0, 0.1])
    end
    savefig(name)
    export_fig(name, '-pdf', '-transparent')
    fig_i = fig_i + 1;
end