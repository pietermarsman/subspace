function [u, rot, x] = linear_subspace(n, d, S, D, cos_theta, noise)

pkg load statistics communications

% generate underlying structure
u = [];
mean = zeros(d, 1) + 5;
for i=[1:S]
  sigma = diag(flipud(cumsum(rand(d, 1))));
  u(:, :, i) = mvnrnd(mean, sigma, n);
end

% generate rotation
rot = [];
for i = [1:S]
  if sum(size(rot)) < 1
    rot(:, :, i) = normc(rand(D, d));
  else
    all_rot = reshape(rot, size(rot, 1), []);
    avg_rot = normc(sum(all_rot, 2));
    nullspace = null(all_rot');
    scale = max(max(all_rot' * repmat(avg_rot, 1, d)));
    % lambda = acos(cos_theta / scale);
    lambda = acos(cos_theta / scale);
    idx = randint(d, 1, size(nullspace, 2))+1;
    rot(:, :, i) = normc(sin(lambda) * log(d+1)/log(2) * nullspace(:, idx) + cos(lambda) * repmat(avg_rot, 1, d));
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
  x(:, :, i) = rot(:, :, i) * u(:, :, i)';
end

% Add noise
if noise > 0
  mean = zeros(D, 1);
  sigma = eye(D)*noise;
  for i = [1:S]
    x(:, :, i) += mvnrnd(mean, sigma, n)';
  end
end
