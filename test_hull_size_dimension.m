hull_size = [];
labels = {};
iter_n = 1;
ns = [10000:10000:50000];
ds = [2:8];
for n = ns
  iter_d = 1;
  for d = ds
    printf("N=%d, d=%d\n", n, d)
    x = linear_subspace(n, d, 1, 20, 0.0, 0.0);
    h = convhulln(x);
    hull_size(iter_n, iter_d) = size(unique(h), 1);
    fflush(stdout);
    iter_d += 1;
  end
  labels{iter_n} = num2str(n);
  iter_n += 1;
end

hull_size_norm = hull_size ./ repmat(ns, size(ds, 2), 1)';
plot(ds, hull_size_norm);
legend(labels);