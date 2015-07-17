function [ x, labels, N, d, n, D, noise, cos ] = get_data( varargin )
%SETUP_DATA Summary of this function goes here
%   Detailed explanation goes here

p = inputParser;
addRequired(p, 'dataset');
addOptional(p, 'noise', 0.001);
addOptional(p, 'cos', 0.5);
addOptional(p, 'N', 500);
addOptional(p, 'D', 2000);
addOptional(p, 'Di', 10);
addOptional(p, 'Ni', 3);

parse(p,varargin{:});
dataset_id = p.Results.dataset;
noise = p.Results.noise;
cos = p.Results.cos;
N = p.Results.N;
D = p.Results.D;
d = p.Results.Di;
n = p.Results.Ni;

% Dataset
if dataset_id == 1
    [~, ~, x, labels] = linear_subspace(N, d, n, D, cos, noise);
elseif dataset_id == 2
    load('datasets/YaleBCrop025.mat');
    d = 11;
    noise = -1;
    cos = -1;
    idx = randperm(10, n);
    yaleX = Y(:, :, idx);
    x = reshape(yaleX, size(yaleX, 1), []);
    labels = s{n};
elseif ischar(dataset_id)
    data = load('datasets/hopkins155+16.mat', 'hopkins');
    hopkins = data.hopkins;
    names = cellfun(@(x) x.name, hopkins, 'UniformOutput', false);
    dataset_bidx = cellfun(@(x) strcmp(x, dataset_id), names);
    dataset = hopkins{dataset_bidx};
    x = dataset.x;
    x = reshape(permute(x(1:2,:,:),[1 3 2]), [], size(x, 2));
    labels = dataset.s;
    n = length(unique(labels));
    d = 4 * n;
    noise = -1;
    cos = -1;
else
    error('Dataset should be between 1 and 2')
end
N = size(x, 2);
D = size(x, 1);

x = x / max(max(abs(x)));

end
