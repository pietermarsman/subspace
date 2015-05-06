clear
iter=1;
thetas = [0.0:0.02:1.0];
d = 1;
for theta = thetas
  [u, rot, x] = linear_subspace(100, d, 2, 4, theta, 0.1);
  angles_norm = (x(:, :, 1)' * x(:, :, 2)) ./ (sqrt(sum(x(:, :, 1).^2, 1))' * sqrt(sum(x(:, :, 2).^2, 1)));
  mini(iter) = min(abs(reshape(angles_norm, 1, [])));
  maxi(iter) = max(abs(reshape(angles_norm, 1, [])));
  iter += 1;
end
hold on
plot(thetas, mini)
plot(thetas, maxi)
