function [data, labels] = load_dataset(dataset_name, S, n_i)

if nargin() < 1
    dataset_name = 'ExtendedYaleBCropped'
end

if nargin() < 2
    S = 3;
end

if nargin() < 3
    n_i = 0;
end

if strcmp(dataset_name, 'ExtendedYaleBCropped') || strcmp(dataset_name, 'YaleBCropped') || strcmp(dataset_name, 'Cropped')
    [data, labels] = getExtendedYaleBCropped(S, n_i);
end


end

function [data, labels] = getExtendedYaleBCropped(S, n_i)
ExtendedYaleBCropped = '~/Datasets/ExtendedYaleBCropped/';
dirs = getAllDirs(ExtendedYaleBCropped);

data = [];
data_i = 1;
label = 1;
labels = [];

for dir = dirs(1:S)
    dir
    
    files = getAllFiles(strcat(ExtendedYaleBCropped, dir{1}, '/'), 'pgm');
    if n_i > 0
        subset_size = min(size(files, 1), n_i);
    else
        subset_size = size(files, 1);
    end
    for file = files(1:subset_size)'
        file
        data(:, data_i) = reshape(read_pgm(file{1}) / 255., [], 1);
        labels(data_i) = label;
        data_i = data_i + 1;
    end
    label = label + 1;
end
end


function fileList = getAllFiles(dirName, extension)

dirData = dir(dirName);      %# Get the data for the current directory
dirIndex = [dirData.isdir];  %# Find the index for directories
fileList2 = {dirData(~dirIndex).name}';  %'# Get a list of the files
if ~isempty(fileList2)
    fileList2 = cellfun(@(x) fullfile(dirName,x),...  %# Prepend path to files
                   fileList2,'UniformOutput',false);
end

if exist('extension')
    extensionLength = size(extension, 2) - 1;
    idx = cellfun(@(x) strcmp(x(end-extensionLength:end), extension), fileList2);
    fileList = fileList2(idx, :);
else
    fileList = fileList2
end
end


function dirList = getAllDirs(dirName)

dirData = dir(dirName);      %# Get the data for the current directory
dirIndex = [dirData.isdir];
subDirs = {dirData(dirIndex).name};  %# Get a list of the subdirectories
validIndex = ~ismember(subDirs,{'.','..'});  %# Find index of subdirectori
dirList = subDirs(validIndex);

end
