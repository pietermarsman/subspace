
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
        cosrep_err{cos_i}{rep_i} = err(:, idx);
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
    beautyplot('In-sample size', '$cos(\theta_{ij})$', '', false, true);
    
    savefigure(dir, [pretit, strrep(names{name_i}, '.', '')]);
end

figure(100)
imshow([], [0, 1])
colormap default
colorbar()
savefigure(dir, [pretit, 'colorbar']);

%% Significance
comp1 = 1;
comp2 = 3;
for cos_i = 1:length(cosrep_err)
    for rep_i = 1:length(cosrep_err{cos_i})
        data = cosrep_err{cos_i}{rep_i}([comp1, comp2], :);
        [~, norm_p1] = kstest(data(:, 1));
        [~, norm_p2] = kstest(data(:, 2));
        p = anova1(data', [], 'off');
        fprintf('cos=%f, rep=%g, norm = (%f, %f), diff=%f\n', ...
            unique_cosses(cos_i), unique_reps(rep_i)*501, norm_p1, norm_p2, p);
        sig(cos_i, rep_i) = p;
    end
end
sig(isnan(sig)) = 1;
imagesc(sig);
yticks = unique([1, 1:2:11, 11]);
set(gca, 'YTick', yticks);
set(gca, 'YTickLabel', round(unique_cosses(yticks), 2));
set(gca, 'XTick', 1:3);
set(gca, 'XTickLabel', floor(unique_reps * 501));
beautyplot('In-sample size', '$cos(\theta_{ij})$', '', false, true);
savefigure(dir, [pretit, 'significance'])