clean;

name = 'Hopkins16'
folder = ['/home/pieter/Datasets/', name, '/'];
folder_length = length(folder);
addpath(genpath(folder));

[status, result] = system(['find ', folder, ' -name "*.mat"']);

if status == 0
    files = strsplit(result, '\n');
    file_length = cellfun(@length, files);
    files = sort(files(file_length > 0));
    hopkins = cell(length(files), 1);
    dataset_i = 1;
    for file = files
        fprintf('Processing %s\n', file{1})
        hopkins{dataset_i, 1} = load(file{1});
        path = strsplit(file{1}(folder_length+1:end), '/');
        hopkins{dataset_i, 1}.name = path{1};
        dataset_i = dataset_i + 1;
    end
else
    warning('Status not zero')
    warning(num2str(status))
end

fprintf('Saving\n')
save(['/home/pieter/Documents/Ai/Thesis/code/datasets/', name], 'hopkins');