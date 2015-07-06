function plot_hull(points, hull, color)
% Only uses the first three dimensions of hull

if ~exist('color')
    color = 'b';
end

hold on
for idx = hull'
 for i = [1, size(idx, 1)-1]
  for j = [i+1, size(idx, 1)]
   id_i = idx(i);
   id_j = idx(j);
   point_x = [points(id_i, 1), points(id_j, 1)];
   point_y = [points(id_i, 2), points(id_j, 2)];
   if size(points, 2) > 2
    point_z = [points(id_i, 3), points(id_j, 3)];
    plot3(point_x, point_y, point_z, 'Color', color);
   else
    plot(point_x, point_y, 'Color', color);
   end
  end
 end
end