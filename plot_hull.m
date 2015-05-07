function plot_hull(points, hull)
% Only uses the first three dimensions of hull

hold on
if size(points, 2) > 2
  scatter3(points(:, 1), points(:, 2), points(:, 3), 'r', 'x')
else
  scatter(points(:, 1), points(:, 2), 'r', 'x')
end
for idx = hull'
 for i = [1, size(idx, 1)-1]
  for j = [i+1, size(idx, 1)]
   id_i = idx(i);
   id_j = idx(j);
   point_x = [points(id_i, 1), points(id_j, 1)];
   point_y = [points(id_i, 2), points(id_j, 2)];
   if size(points, 2) > 2
    point_z = [points(id_i, 3), points(id_j, 3)];
    plot3(point_x, point_y, point_z)
   else
    plot(point_x, point_y)
   end
  end
 end
end