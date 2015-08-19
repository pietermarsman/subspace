
%% LOAD data
clean;

name = 'data/cluster_cosreps_736195737.mat'; load(name);

%% Info 
dir = 'results';
pred_size = 501;

%% SELECTION
selection = [3, 5, 8];
rep_selection = [3, 8];

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
    for repeat_i = find(idx)'
%         rssc_reps = rep{repeat_i}{3};
%         hssc_reps = rep{repeat_i}{8};
%         nn = size(pred{repeat_i}, 2);
%         pospos = intersect(rssc_reps, hssc_reps);
%         posneg = setdiff(rssc_reps, hssc_reps);
%         negpos = setdiff(hssc_reps, rssc_reps);
%         negneg = setdiff(setdiff(1:nn, rssc_reps), hssc_reps);
%         conf(cos_i, 1, index) = length(pospos);
%         conf(cos_i, 2, index) = length(posneg);
%         conf(cos_i, 3, index) = length(negpos);
%         conf(cos_i, 4, index) = length(negneg);
%         index = index + 1;
        
        repmat = rep2mat(rep{repeat_i}, pred_size);
        nonzero = sum(repmat(rep_selection, :) > 1, 1) >= 2;
        norm_index{cos_i} = [norm_index{cos_i}, repmat(rep_selection, nonzero)];
    end
    
end

%% Plot accuracy reps
figure(1)
plot(unique_cosses, (conf(:, 1) + conf(:, 4)) ./ sum(conf, 2))
beautyplot('$cos(\theta_{ij})$', 'Accuracy', '', false, true);

%% Plot precision reps
figure(2)
plot(unique_cosses, conf(:, 1) ./ (conf(:, 1) + conf(:, 3)))
beautyplot('$cos(\theta_{ij})$', 'Precision', '', false, true);

%% Plot correlation


%% Plot clustering 
for name_i = selection
    figure(name_i+2)
    data = avg(:, :, name_i);
    imagesc(data, [0, 1]);
    
    name = strrep(names{name_i}, '_', ' ');
    name = strrep(name, '(', ' (');
    title(name)
    
    yticks = unique([1, 1:2:11, 11]);
    set(gca, 'YTick', yticks);
    set(gca, 'YTickLabel', round(unique_cosses(yticks), 2));
    set(gca, 'XTick', 1:3);
    set(gca, 'XTickLabel', unique_reps);
    beautyplot('Noise', 'Cosine', '', false, false);
    
    savetitle = ['/noisecos_', strrep(names{name_i}, '.', '')];
    savefigure(dir, savetitle);
end

figure(100)
imshow([], [0, 1])
colormap default
colorbar()
savefigure(dir, '/noisecos_colormap');