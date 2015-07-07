names = names{1};
fprintf('RESULTS\n');
for i = 1:length(names)
    fprintf('%f (STD:%f) \t %s\n', mean(err(i, :)),  std(err(i, :)), names{i})
end