clean;

folder = '/home/pieter/Datasets/Hopkins/';
folder_length = length(folder);
addpath(genpath(folder));

[status, result] = system(['find ', folder, ' -name "*.mat"']);

if status == 0
    files = strsplit(result, '\n');
    file_length = cellfun(@length, files);
    files = files(file_length > 0);
    dataset = cell(length(files), 1);
    dataset_i = 1;
    for file = files
        dataset{dataset_i, 1} = load(file{1});
        path = strsplit(file{1}(folder_length+1:end), '/');
        dataset{dataset_i, 1}.name = path{1};
        dataset_i = dataset_i + 1;
    end
else
    warning('Status not zero')
    warning(num2str(status))
end