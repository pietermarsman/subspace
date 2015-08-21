
%% LOAD data
clean;
name = 'data/cluster_cosreps_7361959905.mat'; load(name);

%% Info 
dir = 'results';
pretit = 'cosreps_nonoise_'
pred_size = 501;

%% SELECTION
rssc_i = 1;
sssc_i = 3;
hssc_i = 4;
selection = [rssc_i, sssc_i, hssc_i];
rep_selection = [rssc_i, hssc_i];

%% AGGREGATE

unique_cosses = sort(unique(cosses));
unique_reps = sort(unique(reps));

conf = zeros(length(unique_cosses), 4);
for cos_i = 1:length(unique_cosses)
    fprintf('cos=%f\n', unique_cosses(cos_i));
    for rep_i = 1:length(unique_reps)
        idx = and(cosses == unique_cosses(cos_i), reps == unique_reps(rep_i));
        avg(cos_i, rep_i, :) = mean(err(:, idx), 2);
        st(cos_i, rep_i, :) = std(err(:, idx), 1, 2);
        N(cos_i, rep_i) = sum(idx);
    end

    repeats = sum(idx);
    index = 1;
    norm_index{cos_i} = [];
    idx = and(cosses == unique_cosses(cos_i), reps >= unique_reps(2));
    for repeat_i = find(idx)'
        repp = rep2mat(rep{repeat_i}, pred_size);
        positive = sum(repp(rep_selection, :) >= 0, 1) >= 2;
        norm_index{cos_i} = [norm_index{cos_i}; repp(rep_selection, positive)'];
        
        conf(cos_i, 1, index) = sum((repp(rssc_i, :) >= 0) .* (repp(hssc_i, :) >= 0));
        conf(cos_i, 2, index) = sum((repp(rssc_i, :) > 0) .* (repp(hssc_i, :) < 0));
        conf(cos_i, 3, index) = sum((repp(rssc_i, :) < 0) .* (repp(hssc_i, :) >= 0));
        conf(cos_i, 4, index) = sum((repp(rssc_i, :) < 0) .* (repp(hssc_i, :) < 0));
        
        index = index + 1;
    end
end

%% Plot accuracy reps
figure(1)
sum_conf = sum(conf, 3);
plot(unique_cosses, (sum_conf(:, 1) + sum_conf(:, 4)) ./ sum(sum_conf, 2))
ylim([0, 1])
beautyplot('$cos(\theta_{ij})$', 'Accuracy', '', false, true);
savefigure(dir, [pretit, 'accuracy']);

%% Plot precision reps
figure(2)
sum_conf = sum(conf, 3);
plot(unique_cosses, sum_conf(:, 1) ./ (sum_conf(:, 1) + sum_conf(:, 3)))
ylim([0, 1])
beautyplot('$cos(\theta_{ij})$', 'Precision', '', false, true);
savefigure(dir, [pretit, 'precision'])

%% Plot correlation
figure(3)
corrs = cellfun(@corrcoef, norm_index, 'UniformOutput', false);
corrs = cellfun(@(x) x(2, 1), corrs);
plot(unique_cosses, corrs);
ylim([0, 1])
beautyplot('$cos(\theta_{ij})$', 'Correlation', '', false, true);
savefigure(dir, [pretit, 'correlation'])

%% Plot number of representatives
figure(4)
cos_reps = sum(mean(conf(:, 1:2, :), 3), 2);
plot(unique_cosses, cos_reps);
ylim([0, 26])
beautyplot('$cos(\theta_{ij})$', '\# Representatives', '', false, true);
savefigure(dir, [pretit, 'cosreps']);

%% Plot clustering 
for name_i = selection
    figure(name_i+4)
    data = avg(:, :, name_i);
    imagesc(data, [0, 1]);
    
    name = strrep(names{name_i}, '_', ' ');
    name = strrep(name, '(', ' (');
    title(name)
    
    yticks = unique([1, 1:2:11, 11]);
    set(gca, 'YTick', yticks);
    set(gca, 'YTickLabel', round(unique_cosses(yticks), 2));
    set(gca, 'XTick', 1:3);
    set(gca, 'XTickLabel', floor(unique_reps * 501));
    beautyplot('\# Representatives', '$cos(\theta_{ij})$', '', false, true);
    
    savefigure(dir, [pretit, strrep(names{name_i}, '.', '')]);
end

figure(100)
imshow([], [0, 1])
colormap default
colorbar()
savefigure(dir, [pretit, 'colorbar']);