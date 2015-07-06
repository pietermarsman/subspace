clear all;

duration = [];
performance = [];
N = 500;
d = 10;
S = 3;
D = 1000;
cos_theta = .5;
noise = 0.0001;

alpha = 5;
max_rep = N / 2;
H = 2;
subset_size = N / H;
repeats = 2;

idx_missing = [];
verbose = false;
fprintf('Repeat ');

for j = [1:repeats]
    fprintf('%d ', j);
    [u, rot, x, ~] = linear_subspace(N, d, S, D, cos_theta, noise);
    tic; [rssc_repInd, rssc_C] = rssc(x, alpha, 0, false);
    duration(j, 1) = toc;
    tic; [hssc_repInd, hssc_C] = hssc(x, alpha, max_rep, verbose); 
    duration(j, 2) = toc;
    performance(j) = size(intersect(rssc_repInd, hssc_repInd)) / size(rssc_repInd);
    
    k = 1;
    for id = rssc_repInd
        missing = sum(hssc_repInd == id) == 0;
        idx_missing = [idx_missing; [k / size(rssc_repInd, 2), missing]];
        k = k + 1;
    end
end
fprintf('\n');

figure(2)
bars = [];
std_bars = [];
range = [0.1:0.1:1.0];
for to = range
    from = to - 0.1;
    idx = (idx_missing(:, 1) > from) & (idx_missing(:, 1) < to);
    bars = [bars, mean(idx_missing(idx, 2))];
    std_bars = [std_bars, std(idx_missing(idx, 2))];
end
hold on
plot(range, bars, 'b');
plot(range, bars+std_bars, 'b--')
ylim([0, 1]);
suptitle('Part of the representatives not found by HSSC');
title(sprintf('N=%d, d=%d, S=%d, D=%d, cos=%.1f, noise=%.1f, H=%d, repeats=%d', N, d, S, D, cos_theta, noise, H, repeats));
beautyplot('RSSC repInd place', 'Part not found', '', false);

dir = 'fig';
name = [dir, '/repind'];
mkdir dir;
savefig(name)
export_fig(name, '-pdf', '-transparent')