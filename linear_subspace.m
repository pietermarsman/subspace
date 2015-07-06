function [u, rot, x, labels] = linear_subspace(N, d, S, D, cos_theta, noise)

isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;
if isOctave
  pkg load statistics communications
end

% generate underlying structure
actual_N = round(N / S);
u = [];
labels = [];
mean = zeros(d, 1) + 5;
for i=[1:S]
    sigma = diag(flipud(sort(rand(d, 1))));
    u(:, :, i) = mvnrnd(mean, sigma, actual_N)';
    labels = [labels, repmat(i, 1, actual_N)];
end

% generate rotation
rot = [];
for i = [1:S]
    if sum(size(rot)) < 1
        [q, ~] = qr(rand(D, D));
        rot(:, :, i) = q(:, 1:d);
    else
        all_rot = reshape(rot, size(rot, 1), []);
        avg_rot = normc(sum(all_rot, 2));
        nullspace = null(all_rot');
        idx = randperm(size(nullspace, 2), d);
        null_coordinate = sin(acos(cos_theta)) * log(d+1)/log(2) * nullspace(:, idx);
        avg_coordinate = cos_theta * repmat(avg_rot, 1, d);
        rot(:, :, i) = normc(null_coordinate + avg_coordinate);
    end
end

% Check angle
%{
for i = [1:S]
  for j = [i+1:S]
    [i, j]
    rot(:, :, i)' * rot(:, :, j)
  end
end
%}

% Generate data
for i = [1:S]
    x(:, :, i) = rot(:, :, i) * u(:, :, i);
end
x = reshape(x, size(x, 1), size(x, 2) * size(x, 3));

% Add noise
if noise > 0
    mean = zeros(D, 1);
    sigma = eye(D)*noise;
    x = x + mvnrnd(mean, sigma, size(x, 2))';
end