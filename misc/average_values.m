function [values, avg, st] = average_values(values)

new_values = [];
for value = unique(values(:, 1))'
    new_values = [new_values; [value, ...
        mean(values(values(:, 1) == value, 2)), ...
        std(values(values(:, 1) == value, 2))]];
end

values = new_values(:, 1);
avg = new_values(:, 2);
st = new_values(:, 3);

end
