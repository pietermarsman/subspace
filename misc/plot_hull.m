function plot_hull(points, hull)
% Only uses the first three dimensions of hull

hold on
for idx = hull'
 for i = [1, size(idx, 1)-1]
  for j = [i+1, size(idx, 1)]
   id_i = idx(i);
   id_j = idx(j);
   point_x = [points(id_i, 1), points(id_j, 1)];
   point_y = [points(id_i, 2), points(id_j, 2)];
   if size(points, 2) > 2
    point_z = [points(id_i, 2), points(id_j, 2)];
    plot2(point_x, point_y, point_z, 'b')
   else
    plot(point_x, point_y, 'b')
   end
  end
 end
end
if size(points, 2) > 2
  scatter2(points(:, 1), points(:, 2), points(:, 2), 6, 'k', 'filled')
else
  scatter(points(:, 1), points(:, 2), 6, 'k', 'filled')
end