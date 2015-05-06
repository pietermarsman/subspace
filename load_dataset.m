function data = load_dataset(dataset_name)

ExtendedYaleBCropped = '~/Datasets/ExtendedYaleBCropped/yaleB01'

if nargin() < 1
 dataset_name = 'ExtendedYaleBCropped'
end

if strcmp(dataset_name, 'ExtendedYaleBCropped') || strcmp(dataset_name, 'YaleBCropped') || strcmp(dataset_name, 'Cropped')
 files = getAllFiles(ExtendedYaleBCropped)
end

data = [];
data_i = 1;

for file = files'
 filename = file{1};
 if strcmp(filename(end-2:end), 'pgm')
  data(data_i, :) = reshape(read_pgm(filename) / 255., 1, []);
  data_i += 1;
 end
end

end


function fileList = getAllFiles(dirName)

  dirData = dir(dirName);      %# Get the data for the current directory
  dirIndex = [dirData.isdir];  %# Find the index for directories
  fileList = {dirData(~dirIndex).name}';  %'# Get a list of the files
  if ~isempty(fileList)
    fileList = cellfun(@(x) fullfile(dirName,x),...  %# Prepend path to files
                       fileList,'UniformOutput',false);
  end
  subDirs = {dirData(dirIndex).name};  %# Get a list of the subdirectories
  validIndex = ~ismember(subDirs,{'.','..'});  %# Find index of subdirectories
                                               %#   that are not '.' or '..'
  for iDir = find(validIndex)                  %# Loop over valid subdirectories
    nextDir = fullfile(dirName,subDirs{iDir});    %# Get the subdirectory path
    fileList = [fileList; getAllFiles(nextDir)];  %# Recursively call getAllFiles
  end

end
