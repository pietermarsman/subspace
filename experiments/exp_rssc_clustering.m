clear all;

% Dataset
dataset = 2;
n = 2;
repeats = 50;
if dataset == 1
    N = 500;
    noise = 0.3;
    d = 10;
    D = 100;
    cos = .5;
elseif dataset == 2
    a = load('datasets/YaleBCrop025.mat');
    idx = find(a.s{10} <= n);
    N = size(idx, 1);
    d = 11;
    D = size(a.Y, 1);
    noise = 'unknown';
else
    error('Dataset should be between 1 and 2')
end

% Output containers
missrate = zeros(repeats, 8);
duration = zeros(repeats, 8);

% rssc & hssc
alpha = 10;

% hssc
max_rep = (d+1)*n*2;

fprintf('%d Experiments with N=%d, n=%d, d=%d, D=%d and noise=%s\n', ...
    repeats, N, n, d, D, noise)
fprintf('Alpha=%d, max_rep=%d\n', alpha, max_rep)

for i = [1:repeats]
    
    if dataset == 1
        [~, ~, x, labels] = linear_subspace(N, d, n, D, cos, noise);
    elseif dataset == 2
        x = reshape(a.Y, size(a.Y, 1), []);
        x = x(:, idx);
        labels = a.s{10}(idx);
    end

end

close all;
figure(10)
boxplot(missrate)
set(gca, 'XTickLabel', {'SSC', 'RSSC all', 'RSSC rep', 'RSSC Mix', 'SSSC', 'HSSC all', 'HSSC rep', 'HSSC Mix'})
ylim([0, 1])
ylabel('Error rate')

figure(11)
boxplot(duration)
ylim([0, max(max(duration))])
set(gca, 'XTickLabel', {'SSC', 'RSSC all', 'RSSC rep', 'RSSC Mix', 'SSSC', 'HSSC all', 'HSSC rep', 'HSSC Mix'})
ylabel('Duration')
