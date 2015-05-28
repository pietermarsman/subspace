function data = load_dataset(dataset_name, S)

if nargin() < 1
    dataset_name = 'ExtendedYaleBCropped'
end

if strcmp(dataset_name, 'ExtendedYaleBCropped') || strcmp(dataset_name, 'YaleBCropped') || strcmp(dataset_name, 'Cropped')
    data = getExtendedYaleBCropped(S);
end


end

function data = getExtendedYaleBCropped(S)
ExtendedYaleBCropped = '~/Datasets/ExtendedYaleBCropped/';
dirs = getAllDirs(ExtendedYaleBCropped);

data = [];
data_i = 1;

for dir = dirs(1:S)
    
    files = getAllFiles(strcat(ExtendedYaleBCropped, dir{1}, '/'), 'pgm');
    for file = files'
        data(:, data_i) = reshape(read_pgm(file{1}) / 255., [], 1);
        data_i = data_i + 1;
    end
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
