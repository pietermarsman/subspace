
num_rep = [];
error = [];
id_rep = [];
id_no = [];
num = 0;
for i = 1:length(rep)
    num_rep = [num_rep, cellfun(@length, rep{i})];
    error = err(:, i);
    id_rep = [id_rep, num + 1:2:size(err, 1)];
    id_no = [id_no, num + 2:2:size(err, 1)];
    num = num + size(err, 1);
end

%% PLOT
hold on;

scatter(num_rep(id_rep), error(id_rep));
scatter(num_rep(id_no), error(id_no));
legend('Representatives', 'Not representatives')