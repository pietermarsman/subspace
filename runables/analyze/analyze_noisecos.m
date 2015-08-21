
%% LOAD data
clean;

name = 'cluster_noisecos_7361657054.mat';
load(['data/', name]);
dir = 'results';
cosses = cosses(:, 1);
noises = noises(:, 1);

%% SELECTION
selection = [1, 2, 5, 6, 7, 10];

%% AGGREGATE

unique_cosses = sort(unique(cosses));
unique_noises = sort(unique(noises));

conf = zeros(length(unique_cosses), length(unique_noises), 4);
for cos_i = 1:length(unique_cosses)
    fprintf('cos = %f\n', unique_cosses(cos_i));
    for noise_i = 1:length(unique_noises)
        idx = and(cosses == unique_cosses(cos_i), noises == unique_noises(noise_i));
        avg(cos_i, noise_i, :) = mean(err(:, idx), 2);
        st(cos_i, noise_i, :) = std(err(:, idx), 1, 2);
        N(cos_i, noise_i) = sum(idx);
        
        repeats = sum(idx);
        for repeat_i = find(idx)'
            rssc_reps = rep{repeat_i}{4};
            hssc_reps = rep{repeat_i}{9};
            nn = size(pred{repeat_i}, 2);
            pospos = intersect(rssc_reps, hssc_reps);
            posneg = setdiff(rssc_reps, hssc_reps);
            negpos = setdiff(hssc_reps, rssc_reps);
            negneg = setdiff(setdiff(1:nn, rssc_reps), hssc_reps);            
            conf(cos_i, noise_i, 1) = conf(cos_i, noise_i, 1) + length(pospos) / N(cos_i, noise_i) / nn;
            conf(cos_i, noise_i, 2) = conf(cos_i, noise_i, 2) + length(posneg) / N(cos_i, noise_i) / nn;
            conf(cos_i, noise_i, 3) = conf(cos_i, noise_i, 3) + length(negpos) / N(cos_i, noise_i) / nn;
            conf(cos_i, noise_i, 4) = conf(cos_i, noise_i, 4) + length(negneg) / N(cos_i, noise_i) / nn;
        end
    end
end

%% Plot accuracy reps
imagesc((conf(:, :, 1) + conf(:, :, 4)) ./ sum(conf, 3))
colorbar()
set(gca, 'XTick', 1:2:length(unique_noises), 'XTickLabel', unique_noises(1:2:end))
set(gca, 'YTick', 1:length(unique_cosses), 'YTickLabel', unique_cosses)

%% Plot precision reps
imagesc(conf(:, :, 1) ./ (conf(:, :, 1) + conf(:, :, 2)));
colorbar()
set(gca, 'XTick', 1:2:length(unique_noises), 'XTickLabel', unique_noises(1:2:end))
set(gca, 'YTick', 1:length(unique_cosses), 'YTickLabel', unique_cosses)
beautyplot('$\epsilon$', '$cos(\theta_{ij})$', '', false, true);

%% Plot clustering 
close all

for name_i = selection
    figure(name_i)
    data = avg(:, :, name_i);
    imagesc(data, [0, 1]);
    
    name = strrep(names{name_i}, '_', ' ');
    name = strrep(name, '(', ' (');
%     title(name)
    
    yticks = unique([1, 1:2:11, 11]);
    set(gca, 'YTick', yticks);
    set(gca, 'YTickLabel', unique_cosses(yticks));
    xticks = unique([1:4:21, 21]);
    set(gca, 'XTick', xticks);
    set(gca, 'XTickLabel', unique_noises(xticks));
    beautyplot('$\epsilon^2$', '$\cos(\theta_{ij})$', '', false, true);
    
    savetitle = ['/noisecos_', strrep(names{name_i}, '.', '')];
    savefigure(dir, savetitle);
end

figure(100)
imshow([], [0, 1])
colormap default
colorbar()
savefigure(dir, '/noisecos_colormap');