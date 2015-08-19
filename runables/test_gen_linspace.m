clean
thetas = [0.0:0.1:1.0];
vars = [0.0:0.05:0.2];
vars = unique(sort([vars, 0]));
noise = 0.0;
d = 20;
N = 1000;
n = 3;
D = 500;
%%
theta_i = 1;
maxi = [];
for theta = thetas
    [u, rot, x, labels] = linear_subspace(N, d, n, D, theta, noise, 1.0);
    comp_i = 1;
    leg = {};
    for i = 1:n
        for j = i+1:n
            angles_norm = 1 - pdist2(x(:, labels==i)', x(:, labels==j)', 'cosine');
            maxi(theta_i, comp_i) = max(reshape(angles_norm, 1, [])) - theta;
            leg = [leg; ['$\cos(\theta_{', num2str(i), num2str(j), '})$']];
            comp_i = comp_i + 1;
        end
    end
    theta_i = theta_i + 1;
end

%%
close all;
figure(4)
hold on
plot(thetas, maxi)
leg = [leg; 'thetas'];
I = legend(leg)
set(I, 'interpreter', 'Latex')
set(I,'FontSize',18)
beautyplot('Input: $\cos^{inp}(\theta_{ij})$', ...
    'Difference: $\cos^{inp}(\theta_{ij}) - \cos(\theta_{ij})$', ...
    '', false, true);

savefigure('fig', 'genlibsub_diffcos');

%%
max_ss = [];
maxp_ss = [];
med_ss = [];
mean_ss = [];
mode_ss = [];
for var = vars
    var
    ss = [];
    [~, ~, x, labels] = linear_subspace(N, d, n, D, 0.0, noise, var);
    for l = 1:n
        l_idx = find(labels == l);
        for i = 1:10000
            idx = randperm(length(l_idx), d);
            s = svd(x(:, l_idx(idx)));
            ss = [ss, s(end) - var];
        end
    end
    max_ss = [max_ss, max(ss)];
    maxp_ss = [maxp_ss, max(ss) / var];
    med_ss = [med_ss, median(ss)];
    mean_ss = [mean_ss, mean(ss)];
    mode_ss = [mode_ss, mode(round(ss, 2))];
end

%% 
figure(5)
hold on
plot(vars, maxp_ss);
% plot(max(sing_val, [], 2));
% set(gca, 'XTick', 1:5:length(noises))
% set(gca, 'XTickLabel', noises(1:5:length(noises)))
beautyplot('Input: $\epsilon^2$', 'Output: $\max \limits_{\mathbf{\tilde{Y}}_i \in W_i} \sigma_{d_i}(\mathbf{\tilde{Y}}_i)$', '', false, true);

savefigure('fig', 'genlinsub_noise');