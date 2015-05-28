clear
iter=1;
thetas = [0.0:0.01:1.0];
d = 5;
for theta = thetas
    [u, rot, x] = linear_subspace(1000, d, 3, 100, theta, 0.0);
    angles_norm = (x(:, :, 1)' * x(:, :, 2)) ./ (sqrt(sum(x(:, :, 1).^2, 1))' * sqrt(sum(x(:, :, 2).^2, 1)));
    mini(iter) = min(abs(reshape(angles_norm, 1, [])));
    maxi(iter) = max(abs(reshape(angles_norm, 1, [])));
    iter = iter + 1;
end

        
hold on
plot(thetas, mini)
plot(thetas, maxi)
plot(thetas, thetas)

figure(2)
hold on
plot(mini - thetas)
plot(maxi - thetas)