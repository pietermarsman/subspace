clean;

name = 'exp_hr_c_dist_7361617051.mat'
file = ['data/', name];
load(file);

corr = [];
fros = [];
l2s = [];
l21s = [];
for i = [1:length(cs)]
    a = cs{i}{1};
    b = cs{i}{3};
    diff = a - b;
    r = corrcoef([reshape(a, [], 1), reshape(b, [], 1)]);
    corr = [corr, r(1, 2)];
    fros = [fros, norm(diff, 'fro')];
    l2s = [l2s, norm(diff, 2)];
    l21s = [l21s, sum(sqrt(sum((diff .* diff).^2, 2)), 1)];
end
fprintf('Correlation(a,b): mean=%f, std=%f, std_error=%f\n', mean(corr), ...
    std(corr), std(corr) / sqrt(length(corr)));
fprintf('Frobenius norm(a-b): mean=%f, std=%f, std_error=%f\n', mean(fros), ...
    std(fros), std(fros) / sqrt(length(fros)));
fprintf('L2 norm(a-b): mean=%f, std=%f, std_error=%f\n', mean(l2s), ...
    std(l2s), std(l2s) / sqrt(length(l2s)));
fprintf('L21 norm(a-b): mean=%f, std=%f, std_error=%f\n', mean(l21s), ...
    std(l21s), std(l21s) / sqrt(length(l21s)));