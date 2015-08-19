
%% LOAD data
clean;

name = 'cluster_noisecos_7361657054.mat';
load(['data/', name]);
dir = 'fig';
cosses = cosses(:, 1);
noises = noises(:, 1);

%% SELECTION
selection = [1, 2, 5, 6, 7, 10];

%% AGGREGATE

unique_cosses = sort(unique(cosses));
unique_noises = sort(unique(noises));

for cos_i = 1:length(unique_cosses)
    for noise_i = 1:length(unique_noises)
        idx = and(cosses == unique_cosses(cos_i), noises == unique_noises(noise_i));
        avg(cos_i, noise_i, :) = mean(err(:, idx), 2);
        st(cos_i, noise_i, :) = std(err(:, idx), 1, 2);
        N(cos_i, noise_i) = sum(idx);
    end
end

%% SHOW
close all

for name_i = selection
    figure(name_i)
    data = avg(:, :, name_i);
    imagesc(fliplr(data), [0, 1]);
    
    name = strrep(names{name_i}, '_', ' ');
    name = strrep(name, '(', ' (');
    title(name)
    
    yticks = unique([1, 1:2:11, 11]);
    set(gca, 'YTick', yticks);
    set(gca, 'YTickLabel', unique_cosses(yticks));
    xticks = unique([1, 1:3:21, 21]);
    set(gca, 'XTick', xticks);
    set(gca, 'XTickLabel', unique_noises(sort(xticks, 2, 'descend')));
    beautyplot('Noise', 'Cosine', '', false);
    
    savetitle = [dir, '/noisecos_', strrep(names{name_i}, '.', '')];
    savefig(savetitle)
    export_fig(savetitle, '-pdf', '-transparent')
end

figure(100)
imshow([], [0, 1])
colormap default
colorbar()
savetitle = [dir, '/noisecos_colormap'];
savefig(savetitle)
export_fig(savetitle, '-pdf', '-transparent')