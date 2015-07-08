clear
iter=1;
thetas = [0.0:0.01:1.0];
d = 10;
for theta = thetas
    [u, rot, x, labels] = linear_subspace(1000, d, 2, 200, theta, 0.0);
    angles_norm = 1 - pdist2(x(:, labels==1)', x(:, labels==2)', 'cosine');
    mini(iter) = min(abs(reshape(angles_norm, 1, [])));
    maxi(iter) = max(abs(reshape(angles_norm, 1, [])));
    iter = iter + 1;
end

close all;
figure(4)
hold on
plot(thetas, mini)
plot(thetas, maxi)
plot(thetas, thetas)
legend('min', 'max', 'theta')

figure(2)
hold on
plot(mini - thetas)
plot(maxi - thetas)
legend('min - theta', 'max - theta')