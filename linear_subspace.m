function [u, rot, x, labels] = linear_subspace(N, d, S, D, cos_theta, noise, var)

isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
if isOctave
  pkg load statistics communications
end

% generate underlying structure
actual_N = round(N / S);
u = [];
labels = [];
for i=[1:S]
%     s = rand(d, 1);
%     s = s - min(s) + noise;
%     u(:, :, i) = rand(d, actual_N);
    s = repmat([var^2], d, 1);
    u(:, :, i) = mvnrnd(zeros(d, 1), diag(s), actual_N)';
    u(:, :, i) = u(:, :, i) - min(min(u(:, :, i))) + var^2;
    labels = [labels, repmat(i, 1, actual_N)];
end

% generate rotation
rot = [];
for i = [1:S]
    if sum(size(rot)) < 1
        [q, ~] = qr(rand(D, D));
        rot(:, :, i) = q(:, 1:d);
%         rot(:, :, i) = eye(D, d);
    else
        a = reshape(rot, size(rot, 1), []);
        avg = mean(rot, 3);
        n = null(a');
        
        l_f2 = 2 - 2 * cos_theta;
        l_i = norm(rot(:, :, 1) - avg);
        l_k2 = l_f2 - l_i^ 2;
        l_z = norm(avg);
        cos_gamma = (1 + l_z^2 - l_k2) / (2 * l_z);
        j = sin(acos(cos_gamma));
        
        idx = randperm(size(n, 2), d);
        rot(:, :, i) = n(:, idx) * j + normc(avg) * cos_gamma;
    end
end


% Generate data
for i = [1:S]
    x(:, :, i) = rot(:, :, i) * u(:, :, i);
end
x = reshape(x, size(x, 1), size(x, 2) * size(x, 3));

% Add noise
if noise > 0
    mu = zeros(D, 1);
    sigma = eye(D)*noise;
    x = x + mvnrnd(mu, sigma, size(x, 2))';
end