hull_size = [];
labels = {};
iter_n = 1;
ns = [10000:10000:30000];
ds = [2:5];
for n = ns
  iter_d = 1;
  for d = ds
    sprintf('N=%d, d=%d\n', n, d)
    x = linear_subspace(n, d, 1, 20, 0.0, 0.0, 1.0);
    h = convhulln(x');
    hull_size(iter_n, iter_d) = size(unique(h), 1);
    iter_d = iter_d + 1;
  end
  labels{iter_n} = num2str(n);
  iter_n = iter_n + 1;
end

size(hull_size)
size(repmat(ns, size(ds, 2), 1)')
hull_size_norm = hull_size ./ repmat(ns, size(ds, 2), 1)';
plot(ds, hull_size_norm);
legend(labels);